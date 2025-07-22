defmodule Card.Server do
  use GenServer

  def start() do
    GenServer.start(__MODULE__, [])
  end

  def new(pid) do
    GenServer.cast(pid, :new)
  end

  def shuffle(pid) do
    GenServer.cast(pid, :shuffle)
  end

  def count(pid) do
    GenServer.call(pid, :count)
  end

  def deal(pid, n \\ 1) do
    GenServer.call(pid, {:deal, n})
  end

  def init(_) do
    {:ok, new_deck()}
  end

  def handle_cast(:new, _state) do
    {:noreply, new_deck()}
  end

  def handle_cast(:shuffle, state) do
    {:noreply, Enum.shuffle(state)}
  end

  def handle_call(:count, _from, state) do
    {:reply, length(state), state}
  end

  def handle_call({:deal, n}, _from, state) when n < 0 do
    {:reply, {:error, :invalid_number_of_cards}, state}
  end

  def handle_call({:deal, n}, _from, state) do
    if n <= length(state) do
      {hand, rest} = Enum.split(state, n)
      {:reply, {:ok, hand}, rest}
    else
      {:reply, {:error, :insufficient_cards}, state}
    end
  end

  defp new_deck() do
    suits = [:clubs, :diamonds, :hearts, :spades]
    ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
    for suit <- suits, rank <- ranks, do: {suit, rank}
  end
end
