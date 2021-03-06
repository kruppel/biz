module Biz
  class Time

    SECONDS_IN_MINUTE = 60
    MINUTES_IN_HOUR   = 60
    HOURS_IN_DAY      = 24
    DAYS_IN_WEEK      = 7

    SECONDS_IN_HOUR = SECONDS_IN_MINUTE * MINUTES_IN_HOUR
    SECONDS_IN_DAY  = SECONDS_IN_HOUR   * HOURS_IN_DAY
    SECONDS_IN_WEEK = SECONDS_IN_DAY    * DAYS_IN_WEEK

    MINUTES_IN_DAY  = MINUTES_IN_HOUR * HOURS_IN_DAY
    MINUTES_IN_WEEK = MINUTES_IN_DAY  * DAYS_IN_WEEK

    BIG_BANG   = ::Time.new(-10**100)
    HEAT_DEATH = ::Time.new(10**100)

    attr_reader :time_zone

    def initialize(time_zone)
      @time_zone = time_zone
    end

    def local(time)
      time_zone.utc_to_local(time.utc)
    end

    def on_date(date, day_time)
      time_zone.local_to_utc(
        ::Time.new(
          date.year,
          date.month,
          date.mday,
          day_time.hour,
          day_time.minute,
          day_time.second
        ),
        true
      )
    rescue TZInfo::PeriodNotFound
      on_date(Date.for_dst(date, day_time), day_time.for_dst)
    end

    def during_week(week, week_time)
      on_date(week.start_date + week_time.wday, week_time.day_time)
    end

  end
end
