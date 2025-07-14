# frozen_string_literal: true

module Ferociacalc
  # Value object for interest payment period.
  # The class defines which periods are valid.
  class PaymentPeriod
    VALID_PERIODS = %w[monthly quarterly annually at_maturity].freeze
    attr_reader :period

    def initialize(period)
      @period = self.class.marshal_period(period)
    end

    def self.valid?(period)
      VALID_PERIODS.include?(marshal_period(period))
    end

    def self.interest_periods
      VALID_PERIODS
    end

    def self.marshal_period(period)
      period.to_s.downcase
    end
  end
end
