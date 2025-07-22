defmodule CardServer do
  def start() do
    initial_deck = new()

    pid = spawn(fn -> server_loop(initial_deck) end)
    Process.register(pid, :card_server)

    {:ok, pid}
  end

  defp server_loop(deck) do
    receive do
      {:new, caller} ->
        new_deck = new()
        send(caller, {:ok, new_deck})
        server_loop(new_deck)

      {:shuffle, caller} ->
        shuffled_deck = Enum.shuffle(deck)
        send(caller, {:ok, shuffled_deck})
        server_loop(shuffled_deck)

      {:count, caller} ->
        send(caller, {:ok, length(deck)})
        server_loop(deck)

      {:deal, caller, n} when n > 0 ->
        if length(deck) >= n do
          {dealt_cards, remaining_deck} = Enum.split(deck, n)
          send(caller, {:ok, dealt_cards})
          server_loop(remaining_deck)
        else
          send(caller, {:error, "Not enough cards left to deal"})
          server_loop(deck)
        end

      {:deal, caller, n} when n <= 0 ->
        send(caller, {:error, "Invalid number of cards"})
        serverloop(deck)

       ->
        server_loop(deck)
    end
  end

  def new() do
    values = 2..14
    suits = [:clubs, :diamonds, :hearts, :spades]
    for value <- values, suit <- suits, do: {value, suit}
  end

  def deal(n) do
    send(:card_server, {:deal, self(), n})
    receive do
      response -> response
    end
  end

  def shuffle() do
    send(:card_server, {:shuffle, self()})
    receive do
      response -> response
    end
  end

  def count() do
    send(:card_server, {:count, self()})
    receive do
      response -> response
    end
  end

  def new_deck() do
    send(:card_server, {:new, self()})
    receive do
      response -> response
    end
  end
end
