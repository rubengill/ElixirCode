defmodule Card.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Card.Worker, []}
    ]

    opts = [strategy: :one_for_one, name: Card.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
