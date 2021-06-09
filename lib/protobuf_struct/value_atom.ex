defimpl ProtobufStruct.ValueEncode, for: Atom do
  @moduledoc nil

  def encode(nil) do
    %{kind: {:null_value, :NULL_VALUE}}
  end

  def encode(bool) when bool in [true, false] do
    %{kind: {:bool_value, bool}}
  end
end
