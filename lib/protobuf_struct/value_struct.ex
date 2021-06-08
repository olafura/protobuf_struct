defimpl ProtobufStruct.ValueEncode, for: Map do
  @moduledoc nil

  def encode(map) do
    %{kind: {:struct_value, ProtobufStruct.Struct.encode(map)}}
  end
end
