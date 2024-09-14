defmodule TzTimex do
  require Logger

  def today() do
    Logger.warning("""
    TzTimex.today/0 may safely be replaced by:
    ```
    Date.utc_today/0
    ```
    """)

    Date.utc_today()
  end

  def today(time_zone) do
    Logger.warning("""
    TzTimex.today/1 may safely be replaced by:
    ```
    DateTime.now!(time_zone) |> DateTime.to_date()
    ```
    """)

    now(time_zone) |> DateTime.to_date()
  end

  def now() do
    Logger.warning("""
    TzTimex.now/0 may safely be replaced by:
    ```
    DateTime.utc_now/0
    ```
    """)

    DateTime.utc_now()
  end

  def now(time_zone) do
    Logger.warning("""
    TzTimex.now/1 returns either an error-tuple or the datetime (no ok-tuple).

    If you use valid IANA time zone identifiers, you may replace TzTimex.now/1 by:
    ```
    DateTime.now(time_zone)
    ```
    """)

    time_zone = TzTimex.TimeZoneName.name_of(time_zone)

    # TODO: what about ambiguous?
    with {:ok, dt} <- DateTime.now(time_zone, Tz.TimeZoneDatabase) do
      dt
    end
  end

  def local() do
    Logger.warning("""
    Avoid configuring server in local time zone; instead, use UTC.

    If you need the server to be in local time zone, add a config providing the local time zone into your app:
    ```
    config :my_app, :local_time_zone, "America/New_York"
    ```

    You may then safely replace TzTimex.local/0 by:
    ```
    local_time_zone = Application.fetch_env!(:my_app, :local_time_zone)

    with {:ok, dt} <- DateTime.now(local_time_zone), do: dt
    ```
    """)

    now(Application.fetch_env!(:tz_timex, :local_time_zone))
  end

  def local(%DateTime{} = dt) do
    Logger.warning("""
    Avoid configuring server in local time zone; instead, use UTC.

    If you need the server to be in local time zone, add a config providing the local time zone into your app:
    ```
    config :my_app, :local_time_zone, "America/New_York"
    ```

    If you ensure that only DateTime structs are passed to the function, you may then replace TzTimex.local/1 by:
    ```
    local_time_zone = Application.fetch_env!(:my_app, :local_time_zone)

    with {:ok, dt} <- DateTime.shift_zone(dt, local_time_zone), do: dt
    ```
    """)

    with {:ok, dt} <-
           DateTime.shift_zone(
             dt,
             Application.fetch_env!(:tz_timex, :local_time_zone),
             Tz.TimeZoneDatabase
           ) do
      dt
    end
  end

  def local(%Date{} = date) do
    local(DateTime.new!(date, ~T[00:00:00]))
  end

  def local(%Time{}) do
    {:error, :insufficient_date_information}
  end

  def local(_) do
    {:error, :invalid_date}
  end

  def epoch() do
    Logger.warning("""
    TzTimex.epoch/0 may safely be replaced by:
    ```
    %Date{year: 1970, month: 1, day: 1}
    ```
    """)

    %Date{year: 1970, month: 1, day: 1}
  end

  def zero() do
    Logger.warning("""
    TzTimex.zero/0 may safely be replaced by:
    ```
    %Date{year: 0, month: 1, day: 1}
    ```
    """)

    %Date{year: 0, month: 1, day: 1}
  end

  def from_unix(secs, time_unit \\ :second) do
    time_unit = time_unit(time_unit)

    Logger.warning("""
    Make sure that you use the correct time unit names:
    - change :seconds to :second
    - change :milliseconds to :millisecond
    - change :microseconds to :microsecond
    - change :nanoseconds to :nanosecond

    You may then safely replace TzTimex.from_unix/2 by:
    ````
    DateTime.from_unix!/2
    ```
    """)

    DateTime.from_unix!(secs, time_unit)
  end

  def diff(%Time{} = a, %Time{} = b) do
    Logger.warning("""
    TzTimex.diff/2 receiving `Time` structs with a default 3rd argument may safely be replaced by:
    ```
    Time.diff(t1, t2, :microsecond)
    ```
    Note that the native API defaults to :second, while Timex uses :microsecond, so :microsecond must be specified explicitly.
    """)

    Time.diff(a, b, :microsecond)
  end

  def diff(%Time{} = a, %Time{} = b, time_unit) do
    Logger.warning("""
    Make sure that you use the correct time unit names:
    - change :seconds to :second
    - change :milliseconds to :millisecond
    - change :microseconds to :microsecond
    - change :nanoseconds to :nanosecond

    You may then safely replace TzTimex.diff/3 receiving Time structs by:
    ```
    Time.diff(t1, t2, time_unit)
    ```
    """)

    time_unit = time_unit(time_unit)

    Time.diff(a, b, time_unit)
  end

  def diff(%Date{} = a, %Date{} = b, time_unit) when time_unit in [:day, :days] do
    Logger.warning("""
    TzTimex.diff/2 receiving Date structs with a time unit of :day or :days may safely be replaced by:
    ```
    Date.diff(a, b)
    ```
    """)

    Date.diff(a, b)
  end

  def diff(%Date{} = a, %Date{} = b, time_unit) do
    Logger.warning("""
    When using Date structs with diff, only use :day as the time unit.

    In an attempt to be as close as possible to Timex, TzTimex simplifies calculations: a year is 365 days, a month is 30 days, and a week is 7 days. \
    The output may differ from Timex, as it performs additional calculations.
    """)

    days =
      case time_unit do
        :years -> 365
        :year -> 365
        :months -> 30
        :month -> 30
        :weeks -> 7
        :week -> 7
      end

    Date.diff(a, b) |> div(days)
  end

  def diff(%DateTime{} = a, %DateTime{} = b, time_unit)
      when time_unit in [
             :day,
             :days,
             :hour,
             :hours,
             :minute,
             :minutes,
             :second,
             :seconds,
             :millisecond,
             :milliseconds,
             :microsecond,
             :microseconds,
             :nanosecond,
             :nanoseconds
           ] do
    time_unit = time_unit(time_unit)

    Logger.warning("""
    TzTimex.diff/2 receiving DateTime structs with a time unit of \
    :day, :hour, :minute, :second, :millisecond, :microsecond, :nanosecond \
    may safely be replaced by:
    ```
    DateTime.diff(a, b, time_unit)
    ```
    """)

    DateTime.diff(a, b, time_unit)
  end

  def diff(%DateTime{} = a, %DateTime{} = b, time_unit) do
    Logger.warning("""
    When using DateTime structs with diff, use only of the following time units:
    :day, :hour, :minute, :second, :millisecond, :microsecond, :nanosecond

    In an attempt to be as close as possible to Timex, TzTimex simplifies calculations: a year is 365 days, a month is 30 days, a week is 7 days, etc. \
    The output may differ from Timex, as it performs additional calculations.
    """)

    days =
      case time_unit do
        :years -> 365
        :year -> 365
        :months -> 30
        :month -> 30
        :weeks -> 7
        :week -> 7
      end

    DateTime.diff(a, b) |> div(days)
  end

  def format(moment, format_string, :strftime) do
    Logger.warning("""
    TzTimex.format/3 using :strftime as the formatter may safely be replaced by:
    ```
    Calendar.strftime(moment, format_string)
    ```
    """)

    try do
      {:ok, Calendar.strftime(moment, format_string)}
    rescue
      _ -> {:error, :invalid_format_string}
    end
  end

  def format!(moment, format_string, :strftime) do
    Logger.warning("""
    TzTimex.format/3 using :strftime as the formatter may be replaced by:
    ```
    Calendar.strftime(moment, format_string)
    ```
    """)

    Calendar.strftime(moment, format_string)
  end

  def shift(%Time{}, options) do
    Enum.each(options, fn {duration, _value} ->
      time_unit(duration)
    end)

    Logger.warning("""
    TzTimex.shift/2 passing Time structs is supported by the native API but not Timex; it will result into:
    ```
    {:error, :insufficient_date_information}
    ```
    """)

    {:error, :insufficient_date_information}
  end

  def shift(%Date{} = d, options) do
    options =
      Enum.map(options, fn {duration, value} ->
        duration = time_unit(duration)
        {duration, value}
      end)

    Logger.warning("""
    Make sure that you use the correct time unit names:
    - change :years to :year
    - change :months to :month
    - change :weeks to :week
    - change :days to :day

    Other units are not supported for Date structs.

    TzTimex.shift/2 passing Date structs may be replaced by:
    ```
    Date.shift(date, options)
    ```
    """)

    Date.shift(d, options)
  end

  def shift(%DateTime{} = dt, options) do
    options =
      Enum.map(options, fn {duration, value} ->
        duration = time_unit(duration)
        {duration, value}
      end)

    Logger.warning("""
    Make sure that you use the correct time unit names:
    - change :years to :year
    - change :months to :month
    - change :weeks to :week
    - change :days to :day
    - change :hours to :hour
    - change :minutes to :minute
    - change :seconds to :second
    - change :microseconds to :microsecond

    Other units are not supported for DateTime structs.

    TzTimex.shift/2 passing DateTime structs may then be replaced by:
    ```
    DateTime.shift(dt, options)
    ```
    """)

    DateTime.shift(dt, options)
  end

  def parse(datetime_string, "{ISO:Extended}") do
    Logger.warning("""
    Timex.parse/2 with {ISO:Extended} allows for strings without offset or with missing time information, whereas the native API does not. \
    The ISO extended format should follow this pattern: 2015-01-23T23:50:07Z, 2015-01-23T23:50:07Z+02:00, 2015-01-23T23:50:07Z+02, etc.

    If you make sure you have valid iso strings, you may then replace Timex.parse(datetime_string, "{ISO:Extended}") by:
    ```
    with {:ok, dt, _} <- DateTime.from_iso8601(datetime_string, Calendar.ISO, :extended) do
      {:ok, dt}
    end
    ```
    """)

    with {:ok, dt, _} <- DateTime.from_iso8601(datetime_string, Calendar.ISO, :extended) do
      {:ok, dt}
    end
  end

  def parse(_, _) do
    raise_parse()
  end

  def parse!(datetime_string, "{ISO:Extended}") do
    {:ok, datetime} = parse(datetime_string, "{ISO:Extended}")
    datetime
  end

  def parse!(_, _) do
    raise_parse()
  end

  def parse(_, _, _) do
    raise_parse()
  end

  def parse!(_, _, _) do
    raise_parse()
  end

  defp raise_parse() do
    raise """
    Timex.parse/2 and Timex.parse/3 (and their bang-version) can be replaced by one of the following:
    - Date.from_iso8601/2
    - Time.from_iso8601/2
    - NaiveDateTime.from_iso8601/2
    - DateTime.from_iso8601/2 and DateTime.from_iso8601/3
    - Calendar.ISO.parse_date/1 and Calendar.ISO.parse_date/2
    - Calendar.ISO.parse_time/1 and Calendar.ISO.parse_time/2
    - Calendar.ISO.parse_naive_datetime/1 and Calendar.ISO.parse_naive_datetime/2
    - Calendar.ISO.parse_utc_datetime/1 and Calendar.ISO.parse_utc_datetime/2
    """
  end

  def to_date(%Date{} = date) do
    date
  end

  def to_date(%DateTime{} = dt) do
    Logger.warning("""
    TzTimex.to_date/1 passing a DateTime struct may safely be replaced by:
    ```
    DateTime.to_date(dt)
    ```
    """)

    DateTime.to_date(dt)
  end

  def to_date(%NaiveDateTime{} = ndt) do
    Logger.warning("""
    TzTimex.to_date/1 passing a NaiveDateTime struct may safely be replaced by:
    ```
    NaiveDateTime.to_date(ndt)
    ```
    """)

    NaiveDateTime.to_date(ndt)
  end

  def to_datetime(%Date{} = date) do
    Logger.warning("""
    TzTimex.to_datetime/1 passing a Date struct may safely be replaced by:
    ```
    DateTime.new!(date, ~T[00:00:00])
    ```
    """)

    DateTime.new!(date, ~T[00:00:00])
  end

  def to_datetime(%DateTime{} = dt) do
    dt
  end

  def to_datetime(%NaiveDateTime{} = ndt) do
    Logger.warning("""
    TzTimex.to_datetime/1 passing a NaiveDateTime struct may safely be replaced by:
    ```
    DateTime.from_naive!(ndt, "Etc/UTC")
    ```
    """)

    DateTime.from_naive!(ndt, "Etc/UTC")
  end

  def to_naive_datetime(%Date{} = date) do
    Logger.warning("""
    TzTimex.to_naive_datetime/1 passing a Date struct may safely be replaced by:
    ```
    NaiveDateTime.new!(date, ~T[00:00:00])
    ```
    """)

    NaiveDateTime.new!(date, ~T[00:00:00])
  end

  def to_naive_datetime(%DateTime{} = dt) do
    Logger.warning("""
    TzTimex.to_naive_datetime/1 passing a DateTime struct may safely be replaced by:
    ```
    DateTime.to_naive(dt)
    ```
    """)

    DateTime.to_naive(dt)
  end

  def to_naive_datetime(%NaiveDateTime{} = ndt) do
    ndt
  end

  def before?(%Date{} = date1, %Date{} = date2) do
    Logger.warning("""
    TzTimex.before?/2 with Date structs may safely be replaced by:
    ```
    Date.before?/2
    ```
    """)

    Date.before?(date1, date2)
  end

  def before?(%Time{} = time1, %Time{} = time2) do
    Logger.warning("""
    TzTimex.before?/2 with Time structs may safely be replaced by:
    ```
    Time.before?/2
    ```
    """)

    Time.before?(time1, time2)
  end

  def before?(%DateTime{} = dt1, %DateTime{} = dt2) do
    Logger.warning("""
    TzTimex.before?/2 with DateTime structs may safely be replaced by:
    ```
    DateTime.before?/2
    ```
    """)

    DateTime.before?(dt1, dt2)
  end

  def before?(%NaiveDateTime{} = ndt1, %NaiveDateTime{} = ndt2) do
    Logger.warning("""
    TzTimex.before?/2 with NaiveDateTime structs may safely be replaced by:
    ```
    NaiveDateTime.before?/2
    ```
    """)

    NaiveDateTime.before?(ndt1, ndt2)
  end

  def after?(%Date{} = date1, %Date{} = date2) do
    Logger.warning("""
    TzTimex.after?/2 with Date structs may safely be replaced by:
    ```
    Date.after?/2
    ```
    """)

    Date.after?(date1, date2)
  end

  def after?(%Time{} = time1, %Time{} = time2) do
    Logger.warning("""
    TzTimex.after?/2 with Time structs may safely be replaced by:
    ```
    Time.after?/2
    ```
    """)

    Time.after?(time1, time2)
  end

  def after?(%DateTime{} = dt1, %DateTime{} = dt2) do
    Logger.warning("""
    TzTimex.after?/2 with DateTime structs may safely be replaced by:
    ```
    DateTime.after?/2
    ```
    """)

    DateTime.after?(dt1, dt2)
  end

  def after?(%NaiveDateTime{} = ndt1, %NaiveDateTime{} = ndt2) do
    Logger.warning("""
    TzTimex.after?/2 with NaiveDateTime structs may safely be replaced by:
    ```
    NaiveDateTime.after?/2
    ```
    """)

    NaiveDateTime.after?(ndt1, ndt2)
  end

  def between?(moment, start, ending, options \\ []) do
    if Keyword.has_key?(options, :cycled) do
      raise "cycled not supported"
    end

    struct_name = moment.__struct__

    case Keyword.get(options, :inclusive, false) do
      :start ->
        (struct_name.after?(moment, start) or struct_name.compare(moment, ending) == :eq) and
          struct_name.before?(moment, ending)

      :end ->
        struct_name.after?(moment, start) and
          (struct_name.before?(moment, ending) or struct_name.compare(moment, ending) == :eq)

      true ->
        (struct_name.after?(moment, start) or struct_name.compare(moment, start) == :eq) and
          (struct_name.before?(moment, ending) or struct_name.compare(moment, ending) == :eq)

      _ ->
        struct_name.after?(moment, start) and struct_name.before?(moment, ending)
    end
  end

  def equal?(%Date{} = date1, %Date{} = date2) do
    Logger.warning("""
    TzTimex.equal?/2 with Date structs may safely be replaced by:
    ```
    Date.compare(date1, date2) == :eq
    ```
    """)

    Date.compare(date1, date2) == :eq
  end

  def equal?(%Time{} = time1, %Time{} = time2) do
    Logger.warning("""
    TzTimex.equal?/2 with Time structs may safely be replaced by:
    ```
    Time.compare(time1, time2) == :eq
    ```
    """)

    Time.compare(time1, time2) == :eq
  end

  def equal?(%DateTime{} = dt1, %DateTime{} = dt2) do
    Logger.warning("""
    TzTimex.equal?/2 with DateTime structs may safely be replaced by:
    ```
    DateTime.compare(dt1, dt2) == :eq
    ```
    """)

    DateTime.compare(dt1, dt2) == :eq
  end

  def equal?(%NaiveDateTime{} = ndt1, %NaiveDateTime{} = ndt2) do
    Logger.warning("""
    TzTimex.equal?/2 with NaiveDateTime structs may safely be replaced by:
    ```
    NaiveDateTime.compare(ndt1, ndt2) == :eq
    ```
    """)

    NaiveDateTime.compare(ndt1, ndt2) == :eq
  end

  def compare(%Date{} = date1, %Date{} = date2) do
    Logger.warning("""
    TzTimex.compare/2 with Date structs may be replaced by:
    ```
    Date.compare(date1, date2)
    ```
    Note that return values are :lt | :eq | :gt while Timex returns -1 | 0 | 1
    """)

    case Date.compare(date1, date2) do
      :eq -> 0
      :gt -> 1
      :lt -> -1
    end
  end

  def compare(%Time{} = time1, %Time{} = time2) do
    Logger.warning("""
    TzTimex.compare/2 with Time structs may safely be replaced by:
    ```
    Time.compare(time1, time2) == :eq
    ```
    """)

    case Time.compare(time1, time2) do
      :eq -> 0
      :gt -> 1
      :lt -> -1
    end
  end

  def compare(%DateTime{} = dt1, %DateTime{} = dt2) do
    Logger.warning("""
    TzTimex.compare/2 with DateTime structs may safely be replaced by:
    ```
    DateTime.compare(dt1, dt2) == :eq
    ```
    """)

    case DateTime.compare(dt1, dt2) do
      :eq -> 0
      :gt -> 1
      :lt -> -1
    end
  end

  def compare(%NaiveDateTime{} = ndt1, %NaiveDateTime{} = ndt2) do
    Logger.warning("""
    TzTimex.compare/2 with NaiveDateTime structs may safely be replaced by:
    ```
    NaiveDateTime.compare(ndt1, ndt2) == :eq
    ```
    """)

    case NaiveDateTime.compare(ndt1, ndt2) do
      :eq -> 0
      :gt -> 1
      :lt -> -1
    end
  end

  def is_leap?(%Date{} = date) do
    Logger.warning("""
    TzTimex.is_leap?/1 may safely be replaced by:
    ```
    Date.leap_year?(date)
    ```
    """)

    Date.leap_year?(date)
  end

  def days_in_month(%Date{} = date) do
    Logger.warning("""
    TzTimex.days_in_month/1 may safely be replaced by:
    ```
    Date.days_in_month(date)
    ```
    """)

    Date.days_in_month(date)
  end

  def add() do
  end

  def subtract() do
  end

  def set() do
  end

  defp time_unit(:hours) do
    Logger.warning("Use :hour, not :hours")

    :hour
  end

  defp time_unit(:minutes) do
    Logger.warning("Use :minute, not :minutes")

    :minute
  end

  defp time_unit(:seconds) do
    Logger.warning("Use :second, not :seconds")

    :second
  end

  defp time_unit(:milliseconds) do
    Logger.warning("Use :millisecond, not :milliseconds")

    :millisecond
  end

  defp time_unit(:microseconds) do
    Logger.warning("Use :microsecond, not :microseconds")

    :microsecond
  end

  defp time_unit(:nanoseconds) do
    Logger.warning("Use :nanosecond, not :nanoseconds")

    :nanosecond
  end

  defp time_unit(unit), do: unit
end
