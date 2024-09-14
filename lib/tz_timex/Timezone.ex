defmodule TzTimex.Timezone do
  require Logger

  def convert(moment, :local) do
    Logger.warning("""
    Avoid configuring server in local time zone; instead, use UTC.

    If you need the server to be in local time zone, add a config providing the local time zone into your app:
    ```
    config :my_app, :local_time_zone, "America/New_York"
    ```

    You may then replace TzTimex.Timezone.convert/2 by:
    ```
    local_time_zone = Application.fetch_env!(:my_app, :local_time_zone)

    {:ok, dt} = DateTime.shift_zone(moment, local_time_zone)
    ```
    """)

    DateTime.shift_zone!(
      moment,
      Application.fetch_env!(:tz_timex, :local_time_zone),
      Tz.TimeZoneDatabase
    )
  end
end
