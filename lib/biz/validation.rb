module Biz
  class Validation

    def self.perform(raw)
      new(raw).perform
    end

    def initialize(raw)
      @raw = raw
    end

    def perform
      RULES.each do |rule| rule.check(raw) end

      self
    end

    protected

    attr_reader :raw

    class Rule

      def initialize(message, &condition)
        @message   = message
        @condition = condition
      end

      def check(raw)
        fail Error::Configuration, message unless condition.call(raw)
      end

      protected

      attr_reader :message,
                  :condition

    end

    RULES = Set.new(
      [
        Rule.new('Hours must be hash-like.') { |raw|
          raw.hours.respond_to?(:to_h)
        },
        Rule.new('Hours must be provided.') { |raw|
          raw.hours.to_h.any?
        }
      ]
    )

  end
end
