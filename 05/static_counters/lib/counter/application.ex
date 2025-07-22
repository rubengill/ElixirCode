defmodule Counter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Counter.Worker.start_link(arg)
      #  {Counter.Worker, W1}, # this doesn't work; both have same id
      #  {Counter.Worker, W2}
      Supervisor.child_spec({Counter.Worker, W1}, id: 1),
      Supervisor.child_spec({Counter.Worker, W2}, id: 2)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Counter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
