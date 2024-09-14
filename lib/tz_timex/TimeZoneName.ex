defmodule TzTimex.TimeZoneName do
  require Logger

  def name_of(:utc) do
    Logger.warning("Time zone name :utc should be replaced by \"Etc/UTC\"")

    "Etc/UTC"
  end

  def name_of(:local) do
    Logger.warning("Avoid configuring server in local time zone; instead, use UTC")

    Application.fetch_env!(:tz_timex, :local_time_zone)
  end

  def name_of("GMT") do
    Logger.warning("Time zone name \"GMT\" should be replaced by \"Etc/UTC\"")

    "Etc/UTC"
  end

  def name_of("UTC") do
    Logger.warning("Time zone name \"UTC\" should be replaced by \"Etc/UTC\"")

    "Etc/UTC"
  end

  def name_of("UT") do
    Logger.warning("Time zone name \"UT\" should be replaced by \"Etc/UTC\"")

    "Etc/UTC"
  end

  def name_of("Z") do
    Logger.warning("Time zone name \"Z\" should be replaced by \"Etc/UTC\"")

    "Etc/UTC"
  end

  def name_of(0) do
    Logger.warning("Time zone name 0 should be replaced by \"Etc/UTC\"")

    "Etc/UTC"
  end

  def name_of("A") do
    raise "time zone name \"A\" is not supported"
  end

  def name_of("M") do
    raise "time zone name \"M\" is not supported"
  end

  def name_of("N") do
    raise "time zone name \"N\" is not supported"
  end

  def name_of("Y") do
    raise "time zone name \"Y\" is not supported"
  end

  def name_of(offset) when is_integer(offset) do
    raise "offsets as time zone name are not supported"
  end

  def name_of("+00:00") do
    Logger.warning("Time zone name \"+00:00\" should be replaced by \"Etc/UTC\"")

    "Etc/UTC"
  end

  def name_of("-00:00") do
    Logger.warning("Time zone name \"-00:00\" should be replaced by \"Etc/UTC\"")

    "Etc/UTC"
  end

  def name_of(<<sign::utf8, _h::binary-size(2)-unit(8), ?:, ?0, ?0>>) when sign in [?+, ?-] do
    raise "offsets as time zone name are not supported"
  end

  def name_of(<<sign::utf8, _h::binary-size(1)-unit(8), ?:, ?0, ?0>>) when sign in [?+, ?-] do
    raise "offsets as time zone name are not supported"
  end

  def name_of(<<sign::utf8, _h::binary-size(2)-unit(8), ?:, _m::binary-size(2)-unit(8)>>)
      when sign in [?+, ?-] do
    raise "offsets as time zone name are not supported"
  end

  def name_of(<<sign::utf8, _h::binary-size(1)-unit(8), ?:, _m::binary-size(2)-unit(8)>>)
      when sign in [?+, ?-] do
    raise "offsets as time zone name are not supported"
  end

  def name_of(
        <<sign::utf8, _h::binary-size(2)-unit(8), ?:, _m::binary-size(2)-unit(8), ?:,
          _s::binary-size(2)-unit(8)>>
      )
      when sign in [?+, ?-] do
    raise "offsets as time zone name are not supported"
  end

  def name_of(
        <<sign::utf8, _h::binary-size(1)-unit(8), ?:, _m::binary-size(2)-unit(8), ?:,
          _s::binary-size(2)-unit(8)>>
      )
      when sign in [?+, ?-] do
    raise "offsets as time zone name are not supported"
  end

  def name_of(<<sign::utf8, _h::binary-size(2)-unit(8), _m::binary-size(2)-unit(8)>>)
      when sign in [?+, ?-] do
    raise "offsets as time zone name are not supported"
  end

  def name_of(<<sign::utf8, _h::binary-size(1)-unit(8), _m::binary-size(2)-unit(8)>>)
      when sign in [?+, ?-] do
    raise "offsets as time zone name are not supported"
  end

  def name_of(<<sign::utf8, _h::binary-size(2)-unit(8)>>) when sign in [?+, ?-] do
    raise "offsets as time zone name are not supported"
  end

  def name_of(<<sign::utf8, h::utf8>>) when sign in [?+, ?-] and h >= ?0 and h <= ?9 do
    raise "offsets as time zone name are not supported"
  end

  def name_of("Etc/UTC" <> _offset) do
    raise "offsets as time zone name are not supported"
  end

  def name_of("Etc/GMT" <> _offset) do
    raise "offsets as time zone name are not supported"
  end

  def name_of(<<"GMT", sign::utf8, _hh::utf8>>) when sign in [?+, ?-],
    do: raise("offsets as time zone name are not supported")

  def name_of(<<"GMT", sign::utf8, _hh::binary-size(2)-unit(8)>>) when sign in [?+, ?-],
    do: raise("offsets as time zone name are not supported")

  def name_of(<<"GMT", sign::utf8, _hh::binary-size(2)-unit(8), ?:, _mm::binary-size(2)-unit(8)>>)
      when sign in [?+, ?-],
      do: raise("offsets as time zone name are not supported")

  def name_of(<<"GMT", sign::utf8, _hh::binary-size(1)-unit(8), ?:, _mm::binary-size(2)-unit(8)>>)
      when sign in [?+, ?-],
      do: raise("offsets as time zone name are not supported")

  def name_of(<<"GMT", sign::utf8, _hh::binary-size(2)-unit(8), _mm::binary-size(2)-unit(8)>>)
      when sign in [?+, ?-],
      do: raise("offsets as time zone name are not supported")

  def name_of(<<"GMT", sign::utf8, _hh::binary-size(1)-unit(8), _mm::binary-size(2)-unit(8)>>)
      when sign in [?+, ?-],
      do: raise("offsets as time zone name are not supported")

  def name_of(name), do: name
end
