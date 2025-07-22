defmodule Counter.WorkerSupervisor do
  use DynamicSupervisor

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_worker(name) do
    DynamicSupervisor.start_child(__MODULE__, {Counter.Worker, name})
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one, max_children: 100)
  end
end
