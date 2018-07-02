defmodule LobbyCreator.MixProject do
  use Mix.Project

  def project do
    [
      app: :lobby_creator,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:logger, :gen_stage]
      # registered: [LobbyCreator]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gen_stage, "~> 0.14.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    IO.puts "start running"
    children = [
      # worker(GenstageExample.Producer, [0]),
      # worker(GenstageExample.ProducerConsumer, []),
      # worker(GenstageExample.Consumer, [])
      worker(LobbyCreator, [])
    ]

    opts = [strategy: :one_for_one, name: GenstageExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
