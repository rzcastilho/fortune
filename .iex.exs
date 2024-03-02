alias Fortune.{
  Analyzer,
  Streamer,
  Streams
}

Streams.stop_all_klines()
Streams.stop_all_trades()

DynamicSupervisor.start_child(
  Fortune.DynamicStreamsSupervisor,
  {Streamer, ["omusdt", "5m"]}
)

DynamicSupervisor.start_child(
  Fortune.DynamicStreamsSupervisor,
  {Analyzer, ["omusdt", "5m"]}
)
