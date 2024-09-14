defmodule UpdaterTest do
  use ExUnit.Case

  test "now/0" do
    native_now = DateTime.utc_now() |> DateTime.truncate(:second)
    timex_now = Timex.now() |> DateTime.truncate(:second)
    tz_timex_now = TzTimex.now() |> DateTime.truncate(:second)

    assert native_now == timex_now
    assert native_now == tz_timex_now
  end

  test "now/1" do
    tz_id = "invalid"
    native_now = DateTime.now(tz_id, Tz.TimeZoneDatabase)
    timex_now = Timex.now(tz_id)
    tz_timex_now = TzTimex.now(tz_id)

    assert native_now == timex_now
    assert native_now == tz_timex_now

    tz_id = "Asia/Manila"
    native_now = DateTime.now!(tz_id, Tz.TimeZoneDatabase) |> DateTime.truncate(:second)
    timex_now = Timex.now(tz_id) |> DateTime.truncate(:second)
    tz_timex_now = TzTimex.now(tz_id) |> DateTime.truncate(:second)

    assert native_now == timex_now
    assert native_now == tz_timex_now

    timex_now = Timex.now(:utc) |> DateTime.truncate(:second)
    tz_timex_now = TzTimex.now(:utc) |> DateTime.truncate(:second)

    assert timex_now == tz_timex_now

    Config.Reader.read!("test/config.exs")
    |> Application.put_all_env()

    for timezone <- [:local, "GMT", "UTC", "UT", "Z", 0] do
      timex_now = Timex.now(timezone) |> DateTime.truncate(:second)
      tz_timex_now = TzTimex.now(timezone) |> DateTime.truncate(:second)

      assert timex_now == tz_timex_now
    end
  end

  test "today/0" do
    tz_id = "America/New_York"
    timex_today = Timex.today(tz_id)
    tz_timex_today = TzTimex.today(tz_id)

    assert timex_today == tz_timex_today
  end

  test "today/1" do
    native_today = Date.utc_today()
    timex_today = Timex.today()
    tz_timex_today = TzTimex.today()

    assert native_today == timex_today
    assert native_today == tz_timex_today
  end

  test "local/0" do
    Config.Reader.read!("test/config.exs")
    |> Application.put_all_env()

    native_now =
      DateTime.now!(Application.fetch_env!(:tz_timex, :local_time_zone), Tz.TimeZoneDatabase)
      |> DateTime.truncate(:second)

    timex_now = Timex.local() |> DateTime.truncate(:second)
    tz_timex_now = TzTimex.local() |> DateTime.truncate(:second)

    assert native_now == timex_now
    assert timex_now == tz_timex_now
  end

  test "local/1" do
    Config.Reader.read!("test/config.exs")
    |> Application.put_all_env()

    timex_now =
      Timex.local(DateTime.now!("America/New_York", Tz.TimeZoneDatabase))
      |> DateTime.truncate(:second)

    tz_timex_now =
      TzTimex.local(DateTime.now!("America/New_York", Tz.TimeZoneDatabase))
      |> DateTime.truncate(:second)

    assert timex_now == tz_timex_now

    timex_now = Timex.local(Date.utc_today()) |> DateTime.truncate(:second)
    tz_timex_now = Timex.local(Date.utc_today()) |> DateTime.truncate(:second)

    assert timex_now == tz_timex_now

    timex_now = Timex.local(Time.utc_now())
    tz_timex_now = Timex.local(Time.utc_now())

    assert timex_now == tz_timex_now

    timex_now = Timex.local("invalid")
    tz_timex_now = Timex.local("invalid")

    assert timex_now == tz_timex_now
  end

  test "from_unix/2" do
    ts = 1_704_067_200
    timex_dt = Timex.from_unix(ts)
    tz_timex_dt = TzTimex.from_unix(ts)
    native_dt = DateTime.from_unix!(ts)

    assert timex_dt == native_dt
    assert timex_dt == tz_timex_dt
  end

  test "diff/2" do
    t1 = ~T[10:00:00]
    t2 = ~T[11:30:30]
    timex_diff = Timex.diff(t1, t2)
    tz_timex_diff = TzTimex.diff(t1, t2)
    native_diff = Time.diff(t1, t2, :microsecond)

    assert timex_diff == native_diff
    assert timex_diff == tz_timex_diff

    d1 = ~D[2023-01-01]
    d2 = ~D[2024-01-01]
    timex_diff = Timex.diff(d1, d2, :days)
    tz_timex_diff = TzTimex.diff(d1, d2, :days)
    native_diff = Date.diff(d1, d2)

    assert timex_diff == native_diff
    assert timex_diff == tz_timex_diff

    d1 = ~D[2024-01-01]
    d2 = ~D[2024-03-01]
    timex_diff = Timex.diff(d1, d2, :month)
    tz_timex_diff = TzTimex.diff(d1, d2, :month)

    assert timex_diff == tz_timex_diff

    d1 = ~D[2024-01-01]
    d2 = ~D[2024-03-01]
    timex_diff = Timex.diff(d1, d2, :week)
    tz_timex_diff = TzTimex.diff(d1, d2, :week)

    assert timex_diff == tz_timex_diff

    d1 = ~D[2024-01-01]
    d2 = ~D[2024-03-01]
    timex_diff = Timex.diff(d1, d2, :year)
    tz_timex_diff = TzTimex.diff(d1, d2, :year)

    assert timex_diff == tz_timex_diff

    dt1 = ~U[2024-01-01 13:30:10Z]
    dt2 = ~U[2024-03-01 17:40:20Z]
    timex_diff = Timex.diff(dt1, dt2, :minute)
    tz_timex_diff = TzTimex.diff(dt1, dt2, :minute)

    assert timex_diff == tz_timex_diff
  end

  test "format/3" do
    dt = ~U[2024-12-01 12:20:10Z]

    timex_formatted = Timex.format(dt, "%m/%d", :strftime)
    tz_timex_formatted = TzTimex.format(dt, "%m/%d", :strftime)

    assert timex_formatted == tz_timex_formatted

    assert {:error, _} = Timex.format(dt, "%K/%d", :strftime)
    assert {:error, _} = TzTimex.format(dt, "%K/%d", :strftime)

    timex_formatted = Timex.format!(dt, "%m/%d", :strftime)
    tz_timex_formatted = TzTimex.format!(dt, "%m/%d", :strftime)

    assert timex_formatted == tz_timex_formatted

    assert_raise Timex.Format.FormatError, fn ->
      Timex.format!(dt, "%K/%d", :strftime)
    end

    assert_raise ArgumentError, fn ->
      TzTimex.format!(dt, "%K/%d", :strftime)
    end
  end

  test "shift/2" do
    time = ~T[10:00:00]
    timex_shift = Timex.shift(time, hour: 2, minutes: -5)
    tz_timex_shift = TzTimex.shift(time, hour: 2, minutes: -5)

    assert timex_shift == tz_timex_shift

    date = ~D[2024-01-01]
    timex_shift = Timex.shift(date, days: 2, months: -5)
    tz_timex_shift = TzTimex.shift(date, day: 2, month: -5)
    native_shift = Date.shift(date, day: 2, month: -5)

    assert timex_shift == native_shift
    assert timex_shift == tz_timex_shift

    datetime = ~U[2024-01-01 10:30:20Z]

    timex_shift =
      Timex.shift(datetime, days: 2, months: -5, hours: 2, minutes: -5)
      |> DateTime.truncate(:second)

    tz_timex_shift = TzTimex.shift(datetime, day: 2, month: -5, hour: 2, minutes: -5)
    native_shift = DateTime.shift(datetime, day: 2, month: -5, hour: 2, minute: -5)

    assert timex_shift == native_shift
    assert timex_shift == tz_timex_shift
  end

  test "parse/2" do
    dt_string = "2024-09-11 14:00:00Z"
    timex_parsed = Timex.parse(dt_string, "{ISO:Extended}")
    tz_timex_parsed = TzTimex.parse(dt_string, "{ISO:Extended}")

    assert timex_parsed == tz_timex_parsed

    dt_string = "invalid"
    assert {:error, _} = Timex.parse(dt_string, "{ISO:Extended}")
    assert {:error, _} = TzTimex.parse(dt_string, "{ISO:Extended}")

    dt_string = "2024-09-11 14:00:00Z"
    timex_parsed = Timex.parse!(dt_string, "{ISO:Extended}")
    tz_timex_parsed = TzTimex.parse!(dt_string, "{ISO:Extended}")

    assert timex_parsed == tz_timex_parsed

    dt_string = "invalid"

    assert_raise Timex.Parse.ParseError, fn ->
      assert Timex.parse!(dt_string, "{ISO:Extended}")
    end

    assert_raise MatchError, fn ->
      assert TzTimex.parse!(dt_string, "{ISO:Extended}")
    end
  end

  test "convert/2" do
    Config.Reader.read!("test/config.exs")
    |> Application.put_all_env()

    datetime = ~U[2024-01-01 10:30:20Z]

    timex_converted = Timex.Timezone.convert(datetime, :local)
    tz_timex_converted = TzTimex.Timezone.convert(datetime, :local)

    assert timex_converted == tz_timex_converted
  end

  test "to_x" do
    date = ~D[2024-01-01]
    dt = ~U[2024-01-01 13:30:10Z]
    ndt = ~N[2024-01-01 13:30:10]

    assert Timex.to_date(ndt) == TzTimex.to_date(ndt)
    assert Timex.to_date(dt) == TzTimex.to_date(dt)
    assert Timex.to_date(date) == TzTimex.to_date(date)

    assert Timex.to_datetime(ndt) == TzTimex.to_datetime(ndt)
    assert Timex.to_datetime(dt) == TzTimex.to_datetime(dt)
    assert Timex.to_datetime(date) == TzTimex.to_datetime(date)

    assert Timex.to_naive_datetime(ndt) == TzTimex.to_naive_datetime(ndt)
    assert Timex.to_naive_datetime(dt) == TzTimex.to_naive_datetime(dt)
    assert Timex.to_naive_datetime(date) == TzTimex.to_naive_datetime(date)
  end
end
