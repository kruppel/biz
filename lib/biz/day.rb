module Biz
  class Day

    extend Forwardable

    def self.from_date(date)
      new((date - Date::EPOCH).to_i)
    end

    delegate to_i: :day

    def initialize(day)
      @day = Integer(day)
    end

    def to_date
      Date.from_day(day)
    end

    protected

    attr_reader :day

  end
end
