defmodule FortuneWeb.CockpitLive do
  use FortuneWeb, :live_view

  alias FortuneWeb.Endpoint
  alias FortuneWeb.ActiveStreamsLive

  @trades_topic "trades"
  @klines_topic "klines"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@trades_topic)
      Endpoint.subscribe(@klines_topic)
    end

    {
      :ok,
      socket
      |> assign(:active_streams_component_id, "active-streams")
    }
  end

  def handle_info({:start, event_stream}, socket) do
    send_update(
      ActiveStreamsLive,
      id: socket.assigns.active_streams_component_id,
      event_stream: event_stream
    )

    {:noreply, socket}
  end
end
