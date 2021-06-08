defimpl ProtobufStruct.ValueEncode, for: Integer do
  @moduledoc nil

  def encode(i) do
    %{kind: {:number_value, i}}
  end
end

defimpl ProtobufStruct.ValueEncode, for: Float do
  @moduledoc nil

  def encode(f) do
    %{kind: {:number_value, f}}
  end
end
