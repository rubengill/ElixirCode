defmodule ActiveEchoServer do
  require Logger

  def start(port \\ 1234) do
    opts = [:binary, active: true, packet: :line, reuseaddr: true]
    {:ok, listen_socket} = :gen_tcp.listen(port, opts)
    Logger.info("#{inspect(self())}: listening #{inspect(listen_socket)}")
    accept(listen_socket)
  end

  def accept(listen_socket) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    pid = spawn(fn -> loop(socket) end)
    :gen_tcp.controlling_process(socket, pid)
    Logger.info("#{inspect(pid)} spawned to handle #{inspect(socket)}")
    accept(listen_socket)
  end

  def loop(socket) do
    receive do
      {:tcp, ^socket, data} ->
        :ok = :gen_tcp.send(socket, data)
        loop(socket)
      {:tcp_closed, ^socket} ->
        Logger.info("#{inspect(self())}: closing #{inspect(socket)}")
        :ok = :gen_tcp.close(socket)
    end
  end
end

defmodule PassiveEchoServer do
  require Logger

  def start(port \\ 1234) do
    opts = [:binary, active: false, packet: :line, reuseaddr: true]
    {:ok, listen_socket} = :gen_tcp.listen(port, opts)
    Logger.info("#{inspect(self())}: listening #{inspect(listen_socket)}")
    accept(listen_socket)
  end

  def accept(listen_socket) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    pid = spawn(fn -> loop(socket) end)
    Logger.info("#{inspect(pid)} spawned to handle #{inspect(socket)}")
    accept(listen_socket)
  end

  def loop(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        :gen_tcp.send(socket, data)
        loop(socket)
      {:error, _reason} ->
        Logger.info("#{inspect(self())}: closing #{inspect(socket)}")
        :gen_tcp.close(socket)
    end
  end
end

defmodule HybridEchoServer do
  require Logger

  def start(port \\ 1234) do
    opts = [:binary, active: :once, packet: :line, reuseaddr: true]
    {:ok, listen_socket} = :gen_tcp.listen(port, opts)
    Logger.info("#{inspect(self())}: listening #{inspect(listen_socket)}")
    accept(listen_socket)
  end

  def accept(listen_socket) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    pid = spawn(fn -> loop(socket) end)
    :gen_tcp.controlling_process(socket, pid)
    Logger.info("#{inspect(pid)} spawned to handle #{inspect(socket)}")
    accept(listen_socket)
  end

  def loop(socket) do
    receive do
      {:tcp, ^socket, data} ->
        :inet.setopts(socket, [active: :once])
        :ok = :gen_tcp.send(socket, data)
        loop(socket)
      {:tcp_closed, ^socket} ->
        Logger.info("#{inspect(self())}: closing #{inspect(socket)}")
        :ok = :gen_tcp.close(socket)
    end
  end
end


