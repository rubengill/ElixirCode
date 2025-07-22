defmodule Card.Worker do
  use GenServer

  def start_link(state \\ nil) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def new_deck() do
    GenServer.cast(__MODULE__, :new_deck)
  end

  def shuffle() do
    GenServer.cast(__MODULE__, :shuffle)
  end

  def count() do
    GenServer.call(__MODULE__, :count)
  end

  def deal(n) do
    GenServer.call(__MODULE__, {:deal, n})
  end

  @impl true
  def init(_) do
    IO.puts("Starting Card.Worker")

    case Card.Store.get() do
      {:ok, deck} -> {:ok, deck}
      {:error, _} -> {:ok, build_new_deck()}
    end
  end

  @impl true
  def handle_cast(:new_deck, _state) do
    new_deck = build_new_deck()
    Card.Store.put(new_deck)
    {:noreply, new_deck}
  end

  @impl true
  def handle_cast(:shuffle, state) do
    shuffled_deck = Enum.shuffle(state)
    Card.Store.put(shuffled_deck)
    {:noreply, shuffled_deck}
  end

  @impl true
  def handle_call(:count, _from, state) do
    {:reply, length(state), state}
  end

  @impl true
  def handle_call({:deal, n}, _from, state) do
    if not is_integer(n) do
      raise ArgumentError, "Invalid argument: expected an integer, got #{inspect(n)}"
    end

    if length(state) >= n do
      {dealt_cards, remaining_deck} = Enum.split(state, n)
      Card.Store.put(remaining_deck)
      {:reply, {:ok, dealt_cards}, remaining_deck}
    else
      {:reply, {:error, "Not enough cards to deal"}, state}
    end
  end

  defp build_new_deck() do
    values = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
    suits = [:clubs, :diamonds, :hearts, :spades]
    for value <- values, suit <- suits, do: {value, suit}
  end
end

defmodule Card.Store do
  @file_path "cards.db"

  def get() do
    case File.read(@file_path) do
      {:ok, binary} when binary != "" ->
        try do
          {:ok, :erlang.binary_to_term(binary)}
        rescue
          _ -> {:error, "Invalid file contents"}
        end

      {:ok, ""} ->
        {:error, "Empty deck file"}

      {:error, _reason} ->
        {:error, "Failure in loading the deck"}
    end
  end

  def put(deck) do
    binary = :erlang.term_to_binary(deck)

    case File.write(@file_path, binary) do
      :ok -> :ok
      {:error, reason} -> {:error, reason}
    end
  end
end
