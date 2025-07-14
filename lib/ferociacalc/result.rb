# frozen_string_literal: true

module Ferociacalc
  # Value object for calculator results
  class Result
    attr_reader :total, :interest_accrued

    def initialize(calculation, interest)
      @total = calculation
      @interest_accrued = interest
    end
  end
end
