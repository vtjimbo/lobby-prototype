defmodule LobbyCreator do
  use ConsumerSupervisor

  @moduledoc """
  Event consumer responsible for spawning lobby instances on demand.
  On receiving a create_lobby event, creates/registers a new process
  and sends back a lobby_created event with details so players can log in.

  Listens on: SQS? amqp? rabbit? wat?
  """

  def start_link() do
    ConsumerSupervisor.start_link(__MODULE__, :ok)
  end

  def init(_arg) do
    children = [%{id: Lobby, start: {Lobby, :start_link, []}, restart: :temporary}]
    opts = [strategy: :one_for_one, subscribe_to: [{DummyProducer, max_demand: 5, min_demand: 1}]]
    ConsumerSupervisor.init(children, opts)
  end
end

defmodule DummyProducer do
  @moduledoc """
  This is a simple producer that counts from the given
  number whenever there is a demand.
  """

  use GenStage

  def start_link(initial) when is_integer(initial) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  ## Callbacks

  def init(initial) do
    {:producer, initial}
  end

  def handle_demand(demand, counter) when demand > 0 do
    # If the counter is 3 and we ask for 2 items, we will
    # emit the items 3 and 4, and set the state to 5.
    events = Enum.to_list(counter..counter+demand-1)
    {:noreply, events, counter + demand}
  end
end

defmodule Test do
  @moduledoc """
  Your application entry-point.
  For actual applications, start/0 should be start/2.
  """

  def start do
    import Supervisor.Spec

    children = [
      worker(DummyProducer, [8080]),
      worker(LobbyCreator, [], id: 1)
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end

Test.start
Process.sleep(:infinity)
