defmodule ExAws.Transfer do
  @moduledoc """
  Operations for AWS Transfer Family
  """

  @namespace "TransferService"

  @doc """
  Describes a user assigned to a server.

  ## Parameters

  * `server_id` - Server id (like s-1234567890abcdef0)
  * `user_name` - The name of the user

  ## Examples

      iex> ExAws.Transfer.describe_user("s-1234567890abcdef0", "myuser")
      iex> |> ExAws.request()
      {:ok, %{"User" => %{...}}}

  ## AWS API Documentation

  https://docs.aws.amazon.com/transfer/latest/userguide/API_DescribeUser.html
  """
  @spec describe_user(server_id :: binary(), user_name :: binary()) :: ExAws.Operation.JSON.t()
  def describe_user(server_id, user_name) do
    params = %{
      "ServerId" => server_id,
      "UserName" => user_name
    }

    request(:describe_user, params)
  end

  def delete_user(server_id, user_name) do
    params = %{
      "ServerId" => server_id,
      "UserName" => user_name
    }

    request(:delete_user, params)
  end

  defp request(action, params) do
    action_string = action |> Atom.to_string() |> Macro.camelize()

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
