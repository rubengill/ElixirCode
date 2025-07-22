defmodule Two do

  def reverse_bytes(n) do
    reverse_acc(n, <<>>)
  end

  def reverse_acc(<<>>, acc), do: acc

  # Get the first element of the binary, recursivley call
  def reverse_acc(<<byte, rest::binary>>, acc) do
    reverse_acc(rest, <<byte>> <> acc)
  end

  def sine_stream(x) do
    # Generate infinite number stream
    Stream.unfold({x, 1, 1}, fn {term, power, fact} ->
      calc_fac = fact * (power + 1) * (power + 2)
      num = (-1) * term * x * x

      calc_num = if power == 1 do
        x
      else
        (num / calc_fac) * (-1)
      end

      {calc_num, {num, power + 2, calc_fac}} end)
  end

  def sin(x) do
     # Reduce x to the range [0, 2π] using floating point modulus
    y = x - (2 * :math.pi) * Float.floor(x / (2 * :math.pi))
    sine_terms = sine_stream(y)

    sine_terms
    |> Enum.take(10)
    |> Enum.sum()
  end

end
