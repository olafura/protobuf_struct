defimpl ProtobufStruct.ValueEncode, for: BitString do
  @moduledoc nil

  def encode(string) do
    %{kind: {:string_value, string}}
  end
end
