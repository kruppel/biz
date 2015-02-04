module Biz
  class Validation

    RULES = Set.new(
      Rule.new('Business hours must be provided.') { |raw|
        raw.business_hours.empty?
      },
      Rule.new('Business hours not in valid format.') { |raw|
        begin
          raw.business_hours.each do |_weekday, hours|
            hours.each do |start_time, end_time|
              [start_time, end_time].all? { |time| time.is_a?(String) }
            end
          end

          true
        rescue
          false
        end
      },
      Rule.new('Specified weekday is invalid.') { |raw|
        raw.business_hours.to_enum.map(&:first).all? { |weekday|
          DayOfWeek::SYMBOLS.include?(weekday)
        }
      },
      Rule.new('Holidays must be a collection.') { |raw|
        raw.holidays.respond_to?(:each)
      },
      Rule.new('Holidays must be date-like.') { |raw|
        raw.holidays.to_enum.all? { |holiday| holiday.respond_to?(:to_date) }
      }
    )

    def self.perform(raw)
      new(raw).perform
    end

    attr_reader :raw

    def initialize(raw)
      @raw = raw
    end

    def perform
      RULES.each do |rule| rule.check(raw) end

      self
    end

    class Rule

      def initialize(message, &condition)
        @message   = message
        @condition = condition
      end

      def check(raw)
        fail Error::Configuration, message unless condition.call(raw)
      end

    end
  end
end
