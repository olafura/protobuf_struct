defmodule ProtobufStruct.ValueDecode do
  @moduledoc """
  Documentation for `ProtobufStruct.ValueDecode`.
  """

  def decode(%{kind: kind}) do
    do_decode(kind)
  end

  def do_decode(nil), do: nil

  def do_decode({:null_value, :NULL_VALUE}) do
    nil
  end

  def do_decode({type, v}) when type in [:number_value, :string_value, :bool_value],
    do: v

  def do_decode({:list_value, %{values: values}}) do
    Enum.map(values, &decode/1)
  end

  def do_decode({:struct_value, struct}) do
    ProtobufStruct.Struct.decode(struct)
  end
end
