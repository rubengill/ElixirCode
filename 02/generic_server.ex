defmodule GenericServer do
  def start(m, arg) do
    state = m.init(arg)
    spawn(fn -> loop(m, state) end)
  end

  def call(pid, request) do
    send(pid, {:call, self(), request})
    receive do
      x -> x
    end
  end

  def cast(pid, request) do
    send(pid, {:cast, request})
  end

  defp loop(m, state) do
    receive do
      {:call, from, request} ->
        {reply, new_state} = m.handle_call(request, state)
        send(from, reply)
        loop(m, new_state)
      {:cast, request} ->
        new_state = m.handle_cast(request, state)
        loop(m, new_state)
    end
  end
end

defmodule ArithmeticServer do
  def start() do
    GenericServer.start(__MODULE__, nil)
  end

  def square(pid, x) do
    GenericServer.call(pid, {:square, x})
  end

  def init(x) do
    x
  end

  def sqrt(pid, x) do
    GenericServer.call(pid, {:sqrt, x})
  end

  def handle_call({:square, x}, state) do
    {x * x, state}
  end

  def handle_call({:sqrt, x}, state) do
    reply =
      if x >= 0, do: :math.sqrt(x), else: :error
    {reply, state}
  end
end

defmodule CounterServer do
  def start(n \\ 0) do
    GenericServer.start(__MODULE__, n)
  end

  def inc(pid) do
    GenericServer.cast(pid, :inc)
  end

  def value(pid) do
    GenericServer.call(pid, :value)
  end

  def init(x) do
    x
  end
  def handle_cast(:inc, state) do
    state + 1
  end

  def handle_call(:value, state) do
    {state, state}
  end
end
