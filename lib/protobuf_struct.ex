defmodule ProtobufStruct do
  @moduledoc """
  Documentation for `ProtobufStruct`.
  """

  def from_map(map) when is_map(map) do
    ProtobufStruct.Struct.encode(map)
  end

  def to_map(map) when is_map(map) do
    ProtobufStruct.Struct.decode(map)
  end
end
