defmodule ProtobufStructTest do
  use ExUnit.Case
  doctest ProtobufStruct

  describe "from_map" do
    test "simple map" do
      assert ProtobufStruct.from_map(%{a: 1}) == %{fields: %{"a" => %{kind: {:number_value, 1}}}}
    end

    test "null" do
      assert ProtobufStruct.from_map(%{a: nil}) == %{
               fields: %{"a" => %{kind: {:null_value, nil}}}
             }
    end

    test "bool" do
      assert ProtobufStruct.from_map(%{a: true}) == %{
               fields: %{"a" => %{kind: {:bool_value, true}}}
             }

      assert ProtobufStruct.from_map(%{a: false}) == %{
               fields: %{"a" => %{kind: {:bool_value, false}}}
             }
    end

    test "string" do
      assert ProtobufStruct.from_map(%{a: "hello"}) == %{
               fields: %{"a" => %{kind: {:string_value, "hello"}}}
             }
    end

    test "nested map" do
      assert ProtobufStruct.from_map(%{a: %{b: 1}}) == %{
               fields: %{
                 "a" => %{kind: {:struct_value, %{fields: %{"b" => %{kind: {:number_value, 1}}}}}}
               }
             }
    end

    test "simple list" do
      expected = %{
        fields: %{
          "a" => %{
            kind:
              {:list_value,
               %{
                 values: [
                   %{kind: {:number_value, 1}},
                   %{kind: {:number_value, 2}},
                   %{kind: {:number_value, 3}}
                 ]
               }}
          }
        }
      }

      assert ProtobufStruct.from_map(%{a: [1, 2, 3]}) == expected
    end

    test "complex list" do
      expected = %{
        fields: %{
          "a" => %{
            kind:
              {:list_value,
               %{
                 values: [
                   %{kind: {:struct_value, %{fields: %{"b" => %{kind: {:number_value, 2}}}}}},
                   %{kind: {:bool_value, false}},
                   %{
                     kind: {:struct_value, %{fields: %{"c" => %{kind: {:string_value, "hello"}}}}}
                   }
                 ]
               }}
          }
        }
      }

      assert ProtobufStruct.from_map(%{a: [%{b: 2}, false, %{c: "hello"}]}) == expected
    end
  end

  describe "to_map" do
    test "simple map" do
      from = %{fields: %{"a" => %{kind: {:number_value, 1}}}}
      to = %{"a" => 1}

      assert ProtobufStruct.to_map(from) == to
    end

    test "null" do
      from = %{
        fields: %{"a" => %{kind: {:null_value, nil}}}
      }

      to = %{"a" => nil}

      assert ProtobufStruct.to_map(from) == to
    end

    test "bool" do
      from_true = %{
        fields: %{"a" => %{kind: {:bool_value, true}}}
      }

      to_true = %{"a" => true}

      assert ProtobufStruct.to_map(from_true) == to_true

      from_false = %{
        fields: %{"a" => %{kind: {:bool_value, false}}}
      }

      to_false = %{"a" => false}

      assert ProtobufStruct.to_map(from_false) == to_false
    end

    test "string" do
      from = %{
        fields: %{"a" => %{kind: {:string_value, "hello"}}}
      }

      to = %{"a" => "hello"}

      assert ProtobufStruct.to_map(from) == to
    end

    test "nested map" do
      from = %{
        fields: %{
          "a" => %{kind: {:struct_value, %{fields: %{"b" => %{kind: {:number_value, 1}}}}}}
        }
      }

      to = %{"a" => %{"b" => 1}}

      assert ProtobufStruct.to_map(from) == to
    end

    test "simple list" do
      from = %{
        fields: %{
          "a" => %{
            kind:
              {:list_value,
               %{
                 values: [
                   %{kind: {:number_value, 1}},
                   %{kind: {:number_value, 2}},
                   %{kind: {:number_value, 3}}
                 ]
               }}
          }
        }
      }

      to = %{"a" => [1, 2, 3]}

      assert ProtobufStruct.to_map(from) == to
    end

    test "complex list" do
      from = %{
        fields: %{
          "a" => %{
            kind:
              {:list_value,
               %{
                 values: [
                   %{kind: {:struct_value, %{fields: %{"b" => %{kind: {:number_value, 2}}}}}},
                   %{kind: {:bool_value, false}},
                   %{
                     kind: {:struct_value, %{fields: %{"c" => %{kind: {:string_value, "hello"}}}}}
                   }
                 ]
               }}
          }
        }
      }

      to = %{"a" => [%{"b" => 2}, false, %{"c" => "hello"}]}

      assert ProtobufStruct.to_map(from) == to
    end
  end

  describe "round trip" do
    test "simple map" do
      inital = %{"a" => 1}

      assert inital |> ProtobufStruct.from_map() |> ProtobufStruct.to_map() == inital

      assert inital
             |> ProtobufStruct.from_map()
             |> Google.Protobuf.Struct.new()
             |> Protobuf.encode()
             |> Protobuf.decode(Google.Protobuf.Struct)
             |> ProtobufStruct.to_map() == inital
    end

    test "null" do
      inital = %{"a" => nil}

      assert inital |> ProtobufStruct.from_map() |> ProtobufStruct.to_map() == inital

      assert inital
             |> ProtobufStruct.from_map()
             |> Google.Protobuf.Struct.new()
             |> Protobuf.encode()
             |> Protobuf.decode(Google.Protobuf.Struct)
             |> ProtobufStruct.to_map() == inital
    end

    test "bool" do
      inital_true = %{"a" => true}

      assert inital_true |> ProtobufStruct.from_map() |> ProtobufStruct.to_map() == inital_true

      assert inital_true
             |> ProtobufStruct.from_map()
             |> Google.Protobuf.Struct.new()
             |> Protobuf.encode()
             |> Protobuf.decode(Google.Protobuf.Struct)
             |> ProtobufStruct.to_map() == inital_true

      inital_false = %{"a" => false}

      assert inital_false |> ProtobufStruct.from_map() |> ProtobufStruct.to_map() == inital_false

      assert inital_false
             |> ProtobufStruct.from_map()
             |> Google.Protobuf.Struct.new()
             |> Protobuf.encode()
             |> Protobuf.decode(Google.Protobuf.Struct)
             |> ProtobufStruct.to_map() == inital_false
    end

    test "string" do
      inital = %{"a" => "hello"}

      assert inital |> ProtobufStruct.from_map() |> ProtobufStruct.to_map() == inital

      assert inital
             |> ProtobufStruct.from_map()
             |> Google.Protobuf.Struct.new()
             |> Protobuf.encode()
             |> Protobuf.decode(Google.Protobuf.Struct)
             |> ProtobufStruct.to_map() == inital
    end

    test "nested map" do
      inital = %{"a" => %{"b" => 1}}

      assert inital |> ProtobufStruct.from_map() |> ProtobufStruct.to_map() == inital

      assert inital
             |> ProtobufStruct.from_map()
             |> Google.Protobuf.Struct.new()
             |> Protobuf.encode()
             |> Protobuf.decode(Google.Protobuf.Struct)
             |> ProtobufStruct.to_map() == inital
    end

    test "simple list" do
      inital = %{"a" => [1, 2, 3]}

      assert inital |> ProtobufStruct.from_map() |> ProtobufStruct.to_map() == inital

      assert inital
             |> ProtobufStruct.from_map()
             |> Google.Protobuf.Struct.new()
             |> Protobuf.encode()
             |> Protobuf.decode(Google.Protobuf.Struct)
             |> ProtobufStruct.to_map() == inital
    end

    test "complex list" do
      inital = %{"a" => [%{"b" => 2}, false, %{"c" => "hello"}]}

      assert inital |> ProtobufStruct.from_map() |> ProtobufStruct.to_map() == inital

      assert inital
             |> ProtobufStruct.from_map()
             |> Google.Protobuf.Struct.new()
             |> Protobuf.encode()
             |> Protobuf.decode(Google.Protobuf.Struct)
             |> ProtobufStruct.to_map() == inital
    end
  end
end
