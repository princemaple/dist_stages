defmodule DistStages.Consumer do
  use GenStage

  @sleep_seconds Enum.to_list(3..7)

  def start_link(opts \\ []) do
    GenStage.start_link(DistStages.Consumer, :ok, opts)
  end

  def init(:ok) do
    opts = [subscribe_to: [{{:global, DSP}, [min_demand: 5, max_demand: 10]}]]
    {:consumer, :the_state_does_not_matter, opts}
  end

  def handle_events(events, _from, state) do
    IO.inspect(events, label: inspect(Node.self))

    Process.sleep(Enum.random(@sleep_seconds) * 1000)

    {:noreply, [], state}
  end
end
