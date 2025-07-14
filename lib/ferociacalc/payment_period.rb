# frozen_string_literal: true

module Ferociacalc
  # Value object for interest payment period.
  # The class defines which periods are valid.
  class PaymentPeriod
    VALID_PERIODS = %i[monthly quarterly annually maturity].freeze
    attr_reader :period

    def initialize(period)
      @period = period.to_sym
    end

    def self.valid?(period)
      VALID_PERIODS.include?(period.to_sym)
    end

    def self.interest_periods
      VALID_PERIODS
    end
  end
end
