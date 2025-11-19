defmodule ExAws.TransferTest do
  use ExUnit.Case, async: true

  alias ExAws.Transfer

  describe "describe_user/2" do
    test "builds correct operation struct" do
      op = Transfer.describe_user("s-1234567890abcdef0", "testuser")

      assert %ExAws.Operation.JSON{} = op
      assert op.service == :transfer
      assert op.data == %{
        "ServerId" => "s-1234567890abcdef0",
        "UserName" => "testuser"
      }
    end

    test "sets correct x-amz-target header" do
      op = Transfer.describe_user("s-abc123", "myuser")

      assert {"x-amz-target", "TransferService.DescribeUser"} in op.headers
    end

    test "sets correct content-type header" do
      op = Transfer.describe_user("s-abc123", "myuser")

      assert {"content-type", "application/x-amz-json-1.1"} in op.headers
    end
  end

  describe "delete_user/2" do
    test "builds correct operation struct" do
      op = Transfer.delete_user("s-1234567890abcdef0", "testuser")

      assert %ExAws.Operation.JSON{} = op
      assert op.service == :transfer
      assert op.data == %{
        "ServerId" => "s-1234567890abcdef0",
        "UserName" => "testuser"
      }
    end

    test "sets correct x-amz-target header" do
      op = Transfer.delete_user("s-abc123", "myuser")

      assert {"x-amz-target", "TransferService.DeleteUser"} in op.headers
    end

    test "sets correct content-type header" do
      op = Transfer.delete_user("s-abc123", "myuser")

      assert {"content-type", "application/x-amz-json-1.1"} in op.headers
      end
  end

  describe "create_user/3 and create_user/4" do
    test "builds correct operation struct with required params only" do
      op = Transfer.create_user(
        "s-1234567890abcdef0",
        "newuser",
        "arn:aws:iam::123456789012:role/my-role"
      )

      assert %ExAws.Operation.JSON{} = op
      assert op.service == :transfer
      assert op.data["ServerId"] == "s-1234567890abcdef0"
      assert op.data["UserName"] == "newuser"
      assert op.data["Role"] == "arn:aws:iam::123456789012:role/my-role"
    end

    test "sets correct x-amz-target header" do
      op = Transfer.create_user("s-abc123", "user", "arn:aws:iam::123456789012:role/test")

      assert {"x-amz-target", "TransferService.CreateUser"} in op.headers
    end

    test "pascalizes option keys" do
      op = Transfer.create_user(
        "s-abc123",
        "user",
        "arn:aws:iam::123456789012:role/test",
        ssh_public_key_body: "ssh-rsa AAAAB3..."
      )

      assert op.data["SshPublicKeyBody"] == "ssh-rsa AAAAB3..."
    end

    test "converts home_directory_type atom to uppercase string" do
      op = Transfer.create_user(
        "s-abc123",
        "user",
        "arn:aws:iam::123456789012:role/test",
        home_directory_type: :path
      )

      assert op.data["HomeDirectoryType"] == "PATH"

      op = Transfer.create_user(
        "s-abc123",
        "user",
        "arn:aws:iam::123456789012:role/test",
        home_directory_type: :logical
      )

      assert op.data["HomeDirectoryType"] == "LOGICAL"
    end

    test "formats tags correctly" do
      op = Transfer.create_user(
        "s-abc123",
        "user",
        "arn:aws:iam::123456789012:role/test",
        tags: [
          %{key: "Environment", value: "Production"},
          %{key: "Team", value: "Engineering"}
        ]
      )

      assert op.data["Tags"] == [
        %{"Key" => "Environment", "Value" => "Production"},
        %{"Key" => "Team", "Value" => "Engineering"}
      ]
    end

    test "handles multiple options together" do
      op = Transfer.create_user(
        "s-abc123",
        "user",
        "arn:aws:iam::123456789012:role/test",
        home_directory: "/bucket/user",
        home_directory_type: :path,
        ssh_public_key_body: "ssh-rsa AAAAB3...",
        tags: [%{key: "Env", value: "Prod"}]
      )

      assert op.data["HomeDirectory"] == "/bucket/user"
      assert op.data["HomeDirectoryType"] == "PATH"
      assert op.data["SshPublicKeyBody"] == "ssh-rsa AAAAB3..."
      assert op.data["Tags"] == [%{"Key" => "Env", "Value" => "Prod"}]
    end
  end

  describe "create_user/3 nested structures" do
    test "pascalizes posix_profile nested keys" do
      op = Transfer.create_user(
        "s-abc123",
        "user",
        "arn:aws:iam::123456789012:role/test",
        posix_profile: %{
          uid: 1000,
          gid: 1000,
          secondary_gids: [1001, 1002]
        }
      )

      assert op.data["PosixProfile"] == %{
        "Uid" => 1000,
        "Gid" => 1000,
        "SecondaryGids" => [1001, 1002]
      }
    end

    test "pascalizes home_directory_mappings nested structures" do
      op = Transfer.create_user(
        "s-abc123",
        "user",
        "arn:aws:iam::123456789012:role/test",
        home_directory_mappings: [
          %{entry: "/documents", target: "/bucket/docs", type: "DIRECTORY"},
          %{entry: "/photos", target: "/bucket/photos"}
        ]
      )

      assert op.data["HomeDirectoryMappings"] == [
        %{"Entry" => "/documents", "Target" => "/bucket/docs", "Type" => "DIRECTORY"},
        %{"Entry" => "/photos", "Target" => "/bucket/photos"}
      ]
    end

    test "handles deeply nested structures" do
      op = Transfer.create_user(
        "s-abc123",
        "user",
        "arn:aws:iam::123456789012:role/test",
        posix_profile: %{uid: 1000, gid: 1000},
        home_directory_mappings: [%{entry: "/", target: "/bucket"}],
        tags: [%{key: "Env", value: "Test"}]
      )

      assert op.data["PosixProfile"]["Uid"] == 1000
      assert op.data["HomeDirectoryMappings"] == [%{"Entry" => "/", "Target" => "/bucket"}]
      assert op.data["Tags"] == [%{"Key" => "Env", "Value" => "Test"}]
    end
  end

  describe "update_user/2 and update_user/3" do
    test "builds correct operation struct with required params only" do
      op = Transfer.update_user("s-1234567890abcdef0", "existinguser")

      assert %ExAws.Operation.JSON{} = op
      assert op.service == :transfer
      assert op.data["ServerId"] == "s-1234567890abcdef0"
      assert op.data["UserName"] == "existinguser"
    end

    test "sets correct x-amz-target header" do
      op = Transfer.update_user("s-abc123", "user")

      assert {"x-amz-target", "TransferService.UpdateUser"} in op.headers
    end

    test "handles role option" do
      op = Transfer.update_user(
        "s-abc123",
        "user",
        role: "arn:aws:iam::123456789012:role/new-role"
      )

      assert op.data["Role"] == "arn:aws:iam::123456789012:role/new-role"
    end

    test "handles home_directory option" do
      op = Transfer.update_user(
        "s-abc123",
        "user",
        home_directory: "/new-bucket/users/user"
      )

      assert op.data["HomeDirectory"] == "/new-bucket/users/user"
    end

    test "pascalizes option keys" do
      op = Transfer.update_user(
        "s-abc123",
        "user",
        policy: "{\"Version\":\"2012-10-17\"}"
      )

      assert op.data["Policy"] == "{\"Version\":\"2012-10-17\"}"
    end

    test "converts home_directory_type atom to uppercase string" do
      op = Transfer.update_user(
        "s-abc123",
        "user",
        home_directory_type: :path
      )

      assert op.data["HomeDirectoryType"] == "PATH"

      op = Transfer.update_user(
        "s-abc123",
        "user",
        home_directory_type: :logical
      )

      assert op.data["HomeDirectoryType"] == "LOGICAL"
    end

    test "handles multiple options together" do
      op = Transfer.update_user(
        "s-abc123",
        "user",
        role: "arn:aws:iam::123456789012:role/new-role",
        home_directory: "/bucket/user",
        home_directory_type: :path
      )

      assert op.data["Role"] == "arn:aws:iam::123456789012:role/new-role"
      assert op.data["HomeDirectory"] == "/bucket/user"
      assert op.data["HomeDirectoryType"] == "PATH"
    end
  end

  describe "update_user/2 nested structures" do
    test "pascalizes posix_profile nested keys" do
      op = Transfer.update_user(
        "s-abc123",
        "user",
        posix_profile: %{
          uid: 2000,
          gid: 2000,
          secondary_gids: [2001, 2002, 2003]
        }
      )

      assert op.data["PosixProfile"] == %{
        "Uid" => 2000,
        "Gid" => 2000,
        "SecondaryGids" => [2001, 2002, 2003]
      }
    end

    test "pascalizes home_directory_mappings nested structures" do
      op = Transfer.update_user(
        "s-abc123",
        "user",
        home_directory_mappings: [
          %{entry: "/", target: "/new-bucket/user"}
        ]
      )

      assert op.data["HomeDirectoryMappings"] == [
        %{"Entry" => "/", "Target" => "/new-bucket/user"}
      ]
    end
  end

  describe "integration with ExAws" do
    test "operation can be passed to ExAws functions" do
      op = Transfer.describe_user("s-test", "user")

      # ExAws.request/1 expects an operation struct with these fields
      assert is_atom(op.service)
      assert is_map(op.data)
      assert is_list(op.headers)
    end
  end
end
