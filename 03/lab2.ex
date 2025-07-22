defmodule ArithmeticServer do
  def start() do
    spawn(&loop/0)
  end

  # client API
  def square(pid, x) do
    send(pid, {:square, x, self()})
    # this version makes sure message is from the server
    receive do
      {^pid, :ok, ans} -> "The square of #{x} is #{ans}"
    end
  end

  def sqrt(pid, x) do
    send(pid, {:sqrt, x, self()})

    receive do
      {:ok, ans} -> "The square root of #{x} is #{ans}"
      {:error, error} -> "ERROR: #{error}"
    end
  end

  # implementation
  defp loop() do
    receive do
      {:square, x, from} ->
        send(from, {self(), :ok, x * x})

      {:sqrt, x, from} ->
        reply =
          if x >= 9 do
            {:ok, :math.sqrt(x)}
          else
            {:error, "square root of negative number not supported"}
          end

        send(from, reply)
    end

    loop()
  end
end

defmodule CounterServer do
  def start(n \\ 0) do
    spawn(fn -> loop(n) end)
  end

  def inc(pid) do
    send(pid, :inc)
  end

  def dec(pid) do
    send(pid, :dec)
  end

  def value(pid) do
    send(pid, {:value, self()})

    receive do
      value -> value
    end
  end

  def loop(n) do
    receive do
      :inc ->
        loop(n + 1)

      :dec ->
        loop(n - 1)

      {:value, from} ->
        send(from, n)
        loop(n)
    end
  end
end

defmodule RegisteredCounterServer do
  def start(n \\ 0) do
    Process.register(spawn(fn -> loop(n) end), __MODULE__)
  end

  def inc() do
    send(__MODULE__, :inc)
  end

  def dec() do
    send(__MODULE__, :dec)
  end

  def value() do
    send(__MODULE__, {:value, self()})

    receive do
      value -> value
    end
  end

  def loop(n) do
    receive do
      :inc ->
        loop(n + 1)

      :dec ->
        loop(n - 1)

      {:value, from} ->
        send(from, n)
        loop(n)
    end
  end
end
