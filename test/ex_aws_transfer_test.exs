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
