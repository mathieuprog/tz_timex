# TzTimex

if using :local ->
    Application.get_env(:tz_timex, :local_time_zone)

POSIX time zone identifiers not supported: `CET-1CEST,M3.5.0/2,M10.5.0/3`, `CST6CDT,M3.2.0/2:00:00,M11.1.0/2:00:00`, ...

No use of TimezoneInfo


    The following non-IANA time zones are supported by Timex but not TzTimex:
    - POSIX strings (e.g. CET-1CEST,M3.5.0/2,M10.5.0/3, CST6CDT,M3.2.0/2:00:00,M11.1.0/2:00:00, ...);
    - One-letter time zone names A, M, N and Y
    - An integer representing an offset
    - A string representing an offset such as "+02:00", "UTC+1", "GMT-2", "Etc/UTC+1", etc.


Formatting dates in locale languages is not supported.
You may use CLDR https://github.com/elixir-cldr/cldr_dates_times

