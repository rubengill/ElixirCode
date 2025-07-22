defmodule ArithWorker do
  use GenServer

  # Client API
  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def square(pid, x) do
    GenServer.call(pid, {:square, x})
  end

  def sqrt(pid, x) do
    GenServer.call(pid, {:sqrt, x})
  end

  # Server (GenServer) Callbacks
  @impl true
  def init(_) do
    {:ok, nil}
  end

  @impl true
  def handle_call({:square, x}, _from, state) when is_number(x) do
    {:reply, x * x, state}
  end

  @impl true
  def handle_call({:sqrt, x}, _from, state) when is_number(x) do
    {:reply, :math.sqrt(x), state}
  end

  @impl true
  def handle_call(_, _from, state) do
    # Crash the worker when it receives an invalid argument
    raise "Worker crashed due to invalid input!"
    {:stop, :normal, :error, state}
  end
end

defmodule ArithServer do
  use GenServer

  # Client API
  def start(num_workers) do
    GenServer.start(__MODULE__, num_workers)
  end

  def square(pid, x) do
    GenServer.call(pid, {:square, x})
  end

  def sqrt(pid, x) do
    GenServer.call(pid, {:sqrt, x})
  end

  # Server (GenServer) Callbacks
  @impl true
  def init(num_workers) do
    workers = for _ <- 1..num_workers, do: start_worker()
    {:ok, {workers, 0}} # Store workers and current index
  end

  @impl true
  def handle_call({:square, x}, _from, {workers, idx}) do
    case safe_worker_call(Enum.at(workers, idx), {:square, x}) do
      {:ok, result} ->
        new_idx = rem(idx + 1, length(workers))
        {:reply, result, {workers, new_idx}}

      {:error, _reason} ->
        # Retry logic if a worker crashes
        {:reply, "Worker crashed, please try again", {workers, idx}}
    end
  end

  @impl true
  def handle_call({:sqrt, x}, _from, {workers, idx}) do
    case safe_worker_call(Enum.at(workers, idx), {:sqrt, x}) do
      {:ok, result} ->
        new_idx = rem(idx + 1, length(workers))
        {:reply, result, {workers, new_idx}}

      {:error, _reason} ->
        # Retry logic if a worker crashes
        {:reply, "Worker crashed, please try again", {workers, idx}}
    end
  end

  # Handle worker termination and restart
  @impl true
  def handle_info({:DOWN, _ref, :process, pid, _reason}, {workers, idx}) do
    # Find the dead worker in the worker list
    new_workers = List.delete(workers, pid)

    # Start a new worker and add it to the pool
    new_worker = start_worker()
    IO.puts("Worker crashed! Restarting new worker with PID: #{inspect new_worker}")

    {:noreply, {new_workers ++ [new_worker], idx}}
  end

  # Private function to start a worker and monitor it
  defp start_worker() do
    {:ok, worker_pid} = ArithWorker.start()
    Process.monitor(worker_pid)
    worker_pid
  end

  # Safe worker call with error handling
  defp safe_worker_call(pid, message) do
    try do
      {:ok, GenServer.call(pid, message)}
    catch
      :exit, _reason ->
        # Handle worker crash
        {:error, :worker_crashed}
    end
  end
end
