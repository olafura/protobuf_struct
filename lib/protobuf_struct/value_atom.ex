defimpl ProtobufStruct.ValueEncode, for: Atom do
  @moduledoc nil

  def encode(nil) do
    %{kind: {:null_value, nil}}
  end

  def encode(bool) when bool in [true, false] do
    %{kind: {:bool_value, bool}}
  end
end
