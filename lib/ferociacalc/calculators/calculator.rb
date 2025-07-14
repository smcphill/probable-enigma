# frozen_string_literal: true

module Ferociacalc
  module Calculators
    # Defines the interface for all calculators
    class Calculator
      def self.inputs
        # defines the inputs the calculator requires
        # return a hash with values that our CLI can understand and corresponding keys `#call(inputs)`` will understand
        raise NotImplementedError
      end

      def call(inputs)
        # execute the calculation with the provided inputs, keyed as per `.inputs`
        # returns Ferociacalc::Result
        raise NotImplementedError
      end
    end
  end
end
