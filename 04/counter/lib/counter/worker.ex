defmodule Counter.Worker do
  use GenServer

  def start_link(arg \\ 0) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def inc(amt \\ 1) do
    GenServer.cast(__MODULE__, {:inc, amt})
  end

  def dec(amt \\ 1) do
    GenServer.cast(__MODULE__, {:dec, amt})
  end

  def value() do
    GenServer.call(__MODULE__, :value)
  end

  @impl true
  def init(_arg) do
    value = 
      case Counter.Store.get() do
        nil -> 0
        x -> x
      end
    {:ok, value}
  end

  @impl true
  def handle_cast({:inc, amt}, state) do
    {:noreply, state + amt}
  end

  @impl true
  def handle_cast({:dec, amt}, state) do
    {:noreply, state - amt}
  end

  @impl true
  def handle_call(:value, _from, state) do
    {:reply, state, state}
  end

  # to handle messages sent by the send function
  @impl true
  def handle_info(:reset, _state) do
    {:noreply , 0}
  end
    
  @impl true
  def terminate(_reason, state) do
    Counter.Store.put(state)
  end
end
