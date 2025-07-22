# based on an example in Erlang of Joe Armstrong
defmodule UniversalServer do
  def start() do
    spawn(&become/0)
  end

  def become(pid, f) do
    send(pid, {:become, f})
  end

  defp become() do
    receive do
      {:become, f} ->
        f.()
    end
  end

  def fact_server() do
    receive do
      {from, x} -> send(from, fact(x))
    end
    fact_server()
  end

  def fact(n) when n <= 0, do: 1
  def fact(n), do: n * fact(n - 1)
end
