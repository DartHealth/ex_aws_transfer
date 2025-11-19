defmodule ExAws.Transfer do
  @moduledoc """
  Operations for AWS Transfer Family
  """

  @namespace "TransferService"

  @doc """
  Deletes a user from a file transfer family server.
  ## Parameters

  * `server_id` - Server id (like s-1234567890abcdef0)
  * `user_name` - The name of the user

  ## Examples

      iex> ExAws.Transfer.delete_user("s-1234567890abcdef0", "myuser")
      iex> |> ExAws.request()
      {:ok, %{}}


  ## AWS API Documentation

  https://docs.aws.amazon.com/transfer/latest/userguide/API_DeleteUser.html
  """
  @spec delete_user(server_id :: binary(), user_name :: binary()) :: ExAws.Operation.JSON.t()
  def delete_user(server_id, user_name) do
    params = %{
      "ServerId" => server_id,
      "UserName" => user_name
    }

    request(:delete_user, params)
  end

  @doc """
  Describes a user assigned to a server.

  ## Parameters

  * `server_id` - Server id (like s-1234567890abcdef0)
  * `user_name` - The name of the user

  ## Examples

      iex> ExAws.Transfer.describe_user("s-1234567890abcdef0", "myuser")
      iex> |> ExAws.request()
      {:ok, %{"User" => %{...}, "ServerId" => "s-1234567890abcdef0"}}

  ## AWS API Documentation

  https://docs.aws.amazon.com/transfer/latest/APIReference/API_DescribeUser.html
  """
  @spec describe_user(server_id :: binary(), user_name :: binary()) :: ExAws.Operation.JSON.t()
  def describe_user(server_id, user_name) do
    params = %{
      "ServerId" => server_id,
      "UserName" => user_name
    }

    request(:describe_user, params)
  end

  @doc """
  Creates a user and associates them with an existing file transfer protocol-enabled server.

  ## Parameters

  * `server_id` - Server ID (like `s-1234567890abcdef0`)
  * `user_name` - The name of the user to create
  * `role` - The ARN of the IAM role that controls the user's access (like `arn:aws:iam::123456789012:role/my-role`)

  ## Options

  * `:home_directory` - The landing directory for the user (like `/my-bucket/users/newuser`)
  * `:home_directory_type` - Either `:path` or `:logical`
  * `:home_directory_mappings` - List of logical directory mappings
  * `:policy` - A session policy to scope down user access
  * `:posix_profile` - Map with `:uid`, `:gid`, and optional `:secondary_gids`
  * `:ssh_public_key_body` - The user's public SSH key
  * `:tags` - List of tag maps with `:key` and `:value`

  ## Examples

      # Basic user
      iex> ExAws.Transfer.create_user(
      ...>   "s-1234567890abcdef0",
      ...>   "newuser",
      ...>   "arn:aws:iam::123456789012:role/my-role"
      ...> )
      ...> |> ExAws.request()
      {:ok, %{"ServerId" => "s-1234567890abcdef0", "UserName" => "newuser"}}

      # With SSH key and tags
      iex> ExAws.Transfer.create_user(
      ...>   "s-1234567890abcdef0",
      ...>   "newuser",
      ...>   "arn:aws:iam::123456789012:role/my-role",
      ...>   ssh_public_key_body: "ssh-rsa AAAAB3NzaC1yc2...",
      ...>   tags: [%{key: "Environment", value: "Production"}]
      ...> )
      ...> |> ExAws.request()
      {:ok, %{"ServerId" => "s-1234567890abcdef0", "UserName" => "newuser"}}

  ## AWS API Documentation

  https://docs.aws.amazon.com/transfer/latest/APIReference/API_CreateUser.html
  """
  @type create_user_opts :: [
          {:home_directory, binary()},
          {:home_directory_type, :path | :logical},
          {:home_directory_mappings, [map()]},
          {:policy, binary()},
          {:posix_profile, map()},
          {:ssh_public_key_body, binary()},
          {:tags, [map()]}
        ]
  @spec create_user(
          server_id :: binary(),
          user_name :: binary(),
          role :: binary()
        ) :: ExAws.Operation.JSON.t()
  @spec create_user(
          server_id :: binary(),
          user_name :: binary(),
          role :: binary(),
          opts :: create_user_opts
        ) :: ExAws.Operation.JSON.t()
  def create_user(server_id, user_name, role, opts \\ []) do
    params =
      opts
      |> format_opts()
      |> pascalize_keys()
      |> Map.merge(%{
        "ServerId" => server_id,
        "UserName" => user_name,
        "Role" => role
      })

    request(:create_user, params)
  end

  @doc """
  Updates properties for a user on a file transfer protocol-enabled server.

  ## Parameters

  * `server_id` - Server ID (like `s-1234567890abcdef0`)
  * `user_name` - The name of the user to update

  ## Options

  * `:role` - The ARN of the IAM role that controls the user's access
  * `:home_directory` - The landing directory for the user
  * `:home_directory_type` - Either `:path` or `:logical`
  * `:home_directory_mappings` - List of logical directory mappings
  * `:policy` - A session policy to scope down user access
  * `:posix_profile` - Map with `:uid`, `:gid`, and optional `:secondary_gids`

  ## Examples

      # Update user's role
      iex> ExAws.Transfer.update_user(
      ...>   "s-1234567890abcdef0",
      ...>   "existinguser",
      ...>   role: "arn:aws:iam::123456789012:role/new-role"
      ...> )
      ...> |> ExAws.request()
      {:ok, %{"ServerId" => "s-1234567890abcdef0", "UserName" => "existinguser"}}

      # Update home directory
      iex> ExAws.Transfer.update_user(
      ...>   "s-1234567890abcdef0",
      ...>   "existinguser",
      ...>   home_directory: "/new-bucket/users/existinguser",
      ...>   home_directory_type: :path
      ...> )
      ...> |> ExAws.request()
      {:ok, %{"ServerId" => "s-1234567890abcdef0", "UserName" => "existinguser"}}

  ## AWS API Documentation

  https://docs.aws.amazon.com/transfer/latest/userguide/API_UpdateUser.html
  """
  @type update_user_opts :: [
          {:role, binary()},
          {:home_directory, binary()},
          {:home_directory_type, :path | :logical},
          {:home_directory_mappings, [map()]},
          {:policy, binary()},
          {:posix_profile, map()}
        ]
  @spec update_user(
          server_id :: binary(),
          user_name :: binary()
        ) :: ExAws.Operation.JSON.t()
  @spec update_user(
          server_id :: binary(),
          user_name :: binary(),
          opts :: update_user_opts
        ) :: ExAws.Operation.JSON.t()
  def update_user(server_id, user_name, opts \\ []) do
    params =
      opts
      |> format_opts()
      |> pascalize_keys()
      |> Map.merge(%{
        "ServerId" => server_id,
        "UserName" => user_name
      })

    request(:update_user, params)
  end

  # Private methods start here

  defp pascalize_keys(map) when is_map(map) do
    Map.new(map, fn {k, v} ->
      {pascalize_key(k), pascalize_value(v)}
    end)
  end

  defp pascalize_value(list) when is_list(list) do
    Enum.map(list, &pascalize_value/1)
  end

  defp pascalize_value(map) when is_map(map) do
    pascalize_keys(map)
  end

  defp pascalize_value(value), do: value

  defp pascalize_key(key) when is_atom(key) do
    key |> Atom.to_string() |> pascalize_key()
  end

  defp pascalize_key(key) when is_binary(key) do
    # It grosses me out that Macro.camelize returns PascalCase, but here we are
    Macro.camelize(key)
  end

  defp format_opts(opts) do
    opts
    |> Enum.into(%{})
    |> normalize_home_directory_type()
    |> normalize_tags()
  end

  defp normalize_home_directory_type(%{home_directory_type: :path} = opts) do
    Map.put(opts, :home_directory_type, "PATH")
  end

  defp normalize_home_directory_type(%{home_directory_type: :logical} = opts) do
    Map.put(opts, :home_directory_type, "LOGICAL")
  end

  defp normalize_home_directory_type(opts), do: opts

  defp normalize_tags(%{tags: tags} = opts) when is_list(tags) do
    normalized_tags =
      Enum.map(tags, fn
        %{key: k, value: v} -> %{"Key" => k, "Value" => v}
        %{"Key" => _, "Value" => _} = tag -> tag
        tag -> tag
      end)

    Map.put(opts, :tags, normalized_tags)
  end

  defp normalize_tags(opts), do: opts

  defp request(action, params) do
    action_string = pascalize_key(action)

    ExAws.Operation.JSON.new(
      :transfer,
      %{
        data: params,
        headers: [
          {"x-amz-target", "#{@namespace}.#{action_string}"},
          {"content-type", "application/x-amz-json-1.1"}
        ]
      }
    )
  end
end
