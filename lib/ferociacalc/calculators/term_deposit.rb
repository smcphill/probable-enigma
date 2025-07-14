# frozen_string_literal: true

require 'ferociacalc/calculators/calculator'
require 'ferociacalc/result'

module Ferociacalc
  module Calculators
    # Term deposit calculator
    class TermDeposit < Calculator
      def inputs
        # defines the inputs this calculator requires
      end

      def call
        # perform the term deposit calculation and return a Ferociacalc::Result
        Result.new(0, 0)
      end
    end
  end
end
