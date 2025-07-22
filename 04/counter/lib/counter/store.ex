defmodule Counter.Store do
  use GenServer

  def start_link(file) do
    GenServer.start_link(__MODULE__, file, name: __MODULE__)
  end

  def put(value) do
    GenServer.cast(__MODULE__, {:put, value})
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  @impl true
  def init(file) do
    {:ok, file}
  end

  @impl true
  def handle_cast({:put, value}, file) do
    File.write(file, :erlang.term_to_binary(value))
    {:noreply, file}
  end

  @impl true
  def handle_call(:get, _from, file) do
    value = 
      case File.read(file) do
        {:ok, content} ->
          :erlang.binary_to_term(content)
        {:error, _} ->
          nil
      end
    {:reply, value, file}
  end
end
