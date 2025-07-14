# frozen_string_literal: true

module Ferociacalc
  # Value object for calculator results
  class Result
    def initialize(calculation, interest)
      @total = calculation
      @interest_accrued = interest
    end

    def total
      @total.to_f.round(2)
    end

    def interest_accrued
      @interest_accrued.to_f.round(2)
    end
  end
end
