defmodule DistStages.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Clusterable, [], restart: :transient),
      worker(DistStages.Producer, [1000, [name: {:global, DSP}]]),
      worker(DistStages.Consumer, [[name: DSC]])
    ]

    opts = [strategy: :one_for_one, name: DistStages.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
