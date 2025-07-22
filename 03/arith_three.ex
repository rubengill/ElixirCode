defmodule ArithWorker do
  use GenServer

  # Starts the worker
  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def square(pid, x) do
    GenServer.call(pid, {:square, x})
  end

  def sqrt(pid, x) do
    GenServer.call(pid, {:sqrt, x})
  end

  @impl true
  def init(_) do
    {:ok, nil}
  end

  @impl true
  def handle_call({:square, x}, _from, state) do
    result = x * x
    {:reply, {self(), result}, state}
  end

  @impl true
  def handle_call({:sqrt, x}, _from, state) do
    result = if x >= 0, do: :math.sqrt(x), else: :error
    {:reply, {self(), result}, state}
  end
end

defmodule ArithServer do
  use GenServer

  def start(num_workers) when num_workers > 0 do
    case GenServer.start(__MODULE__, num_workers) do
      {:ok, pid} ->
        IO.puts("ArithServer started with PID: #{inspect(pid)}")
        {:ok, pid}

      error ->
        error
    end
  end
end
