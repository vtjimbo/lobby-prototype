defmodule LobbyCreator do
  @moduledoc """
  Event consumer responsible for spawning lobby instances on demand.
  On receiving a create lobby event, creates/registers a new process
  listening on an available port.
  """

  use ConsumerSupervisor

  def start_link() do
    ConsumerSupervisor.start_link(__MODULE__, :ok)
  end

  def init(_arg) do
    children = [%{id: Lobby, start: {Lobby, :start_link, []}, restart: :temporary}]
    opts = [strategy: :one_for_one, subscribe_to: [{DummyProducer, max_demand: 5, min_demand: 1}]]
    ConsumerSupervisor.init(children, opts)
  end
end
