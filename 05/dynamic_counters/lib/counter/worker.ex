defmodule Counter.Worker do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, name: via(name))
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
  def init(_value) do
    {:ok, 0}
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
end
