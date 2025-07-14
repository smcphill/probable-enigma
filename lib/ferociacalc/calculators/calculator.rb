# frozen_string_literal: true

module Ferociacalc
  module Calculators
    # Defines the interface for all calculators
    class Calculator
      def self.inputs
        # defines the inputs the calculator requires
        raise NotImplementedError
      end

      def call
        # execute the calculation
        # returns Ferociacalc::Result
        raise NotImplementedError
      end
    end
  end
end
