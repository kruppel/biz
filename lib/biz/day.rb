module Biz
  class Day

    include Comparable
    include Concord.new(:day)

    extend Forwardable

    def self.from_date(date)
      new((date - Date::EPOCH).to_i)
    end

    def self.from_time(time)
      from_date(time.to_date)
    end

    class << self

      alias_method :since_epoch, :from_time

    end

    delegate %i[
      to_s
      to_i
      to_int
    ] => :day

    def initialize(day)
      super(Integer(day))
    end

    def to_date
      Date.from_day(day)
    end

    def coerce(other)
      [self.class.new(Integer(other)), self]
    end

    def <=>(other)
      return nil unless other.respond_to?(:to_i)

      day <=> other.to_i
    end

  end
end
