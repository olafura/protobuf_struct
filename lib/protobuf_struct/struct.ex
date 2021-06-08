defmodule ProtobufStruct.Struct do
  @moduledoc """
  Documentation for `ProtobufStruct.Struct`.
  """

  def encode(map) do
    fields =
      map
      |> Enum.map(fn {key, value} ->
        {to_string(key), ProtobufStruct.ValueEncode.encode(value)}
      end)
      |> Enum.into(%{})

    %{fields: fields}
  end

  def decode(%{fields: nil}) do
    nil
  end

  def decode(%{fields: map}) when is_map(map) do
    map
    |> Enum.map(fn {key, value} ->
      {key, ProtobufStruct.ValueDecode.decode(value)}
    end)
    |> Enum.into(%{})
  end
end
