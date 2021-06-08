defimpl ProtobufStruct.ValueEncode, for: List do
  @moduledoc nil

  def encode(list) do
    values =
      list
      |> Enum.map(&ProtobufStruct.ValueEncode.encode/1)

    %{kind: {:list_value, %{values: values}}}
  end
end
