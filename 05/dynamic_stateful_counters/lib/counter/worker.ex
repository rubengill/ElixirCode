defmodule Counter.Worker do
  use GenServer
  @table  Counter.Table

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via(name))
  end

  def inc(name, amt \\ 1) do
    GenServer.cast(via(name), {:inc, amt})
  end

  def dec(name, amt \\ 1) do
    GenServer.cast(via(name), {:dec, amt})
  end

  def value(name) do
    GenServer.call(via(name), :value)
  end

  defp via(name) do
    {:via, Registry, {Counter.Registry, {__MODULE__, name}}}
  end

  @impl true
  def init(name) do
    value =
      case :ets.lookup(@table, name) do
        [{^name, val}] -> val
        _ -> 0
      end
    {:ok, {name, value}}
  end

  @impl true
  def handle_cast({:inc, amt}, {name, value}) do
    {:noreply, {name, value + amt}}
  end

  @impl true
  def handle_cast({:dec, amt}, {name, value}) do
    {:noreply, {name, value - amt}}
  end

  @impl true
  def handle_call(:value, _from, {_name, value} = state) do
    {:reply, value, state}
  end

  # to handle messages sent by the send function
  @impl true
  def terminate(_reason, state) do
    :ets.insert(@table, state)
  end
end
