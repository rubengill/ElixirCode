# this is basically the client API portion of 
# dynamic/lib/counter/worker_supervisor.ex
defmodule Counter.WorkerSupervisor do
  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: {:global, __MODULE__})
  end

  def start_worker(name) do
    DynamicSupervisor.start_child({:global, __MODULE__}, {Counter.Worker, name})
  end
end
