Compile client code first:
in static_client, run: elixirc worker.ex
in dynamic_client, run:
  elixirc worker.ex
  elixirc worker_supervisor.ex

To run static/static_client:
static$ iex --sname homer -S mix  # this starts worker
iex(1)>

static_client$ iex --sname bart
iex(1)> Counter.Worker.value

static_client$ iex --sname lisa
iex(1)> Node.ping(:homer@elixir)  # change to your machine name
:pong
iex(2)> Node.ping(:bart@elixir)   # now all 3 nodes are connected
:pong
iex(3)> Counter.Worker.inc
...

To run dynamic/dynamic_client:
dynamic$ iex --sname homer -S mix  # this starts worker
iex(1)>

dynamic_client$ iex --sname bart
iex(1)> Counter.Worker.value("c1")  # after "c1" is created by lisa

dynamic_client$ iex --sname lisa
iex(1)> Node.ping(:homer@elixir)  # change to your machine name
:pong
iex(2)> Node.ping(:bart@elixir)   # now all 3 nodes are connected
:pong
iex(3)> Counter.WorkerSupervisor.start_worker("c1")

iex(4)> Counter.Worker.inc("c1")
...
