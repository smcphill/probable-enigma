# frozen_string_literal: true

require 'optparse'
require 'ferociacalc/calculators'

module Ferociacalc
  # CLI interface
  class CLI < OptionParser
    def initialize(argv = [])
      @argv = argv.dup
      super('Usage: ferociacalc [options]')
      parse_inputs
    rescue StandardError => e
      # Don't emit stack traces, just return OptionParser guidance and exit -1
      puts e
      exit(-1)
    end

    def run
      # Perform the calculation and present the result
      result = @calculator.call
      present_result(result)
      exit
    end

    private_methods

    def parse_inputs
      # CLI input parsing
      accept_calculator
      accept_inputs

      parse!(@argv)
    end

    def present_result(result)
      # CLI Presentation
      output = <<~HEREDOC
        Final balance: $#{result.total}
        Total interest earned:  $#{result.interest_accrued}
      HEREDOC

      puts output
    end

    def accept_calculator
      # Acquire the desired calculator

      accept(Ferociacalc::Calculators::Calculator) do |calc_name|
        clazz = Object.const_get "Ferociacalc::Calculators::#{snake_to_camel(calc_name)}"
        clazz.new
      rescue NameError
        raise "Unknown calculator '#{calc_name}'"
      end

      on('-c CALCULATOR', Ferociacalc::Calculators::Calculator, 'CALCULATOR to use') do |calc|
        @calculator = calc
      end
    end

    def accept_inputs
      # request required inputs from the selected calculator
      raise NotImplementedError
    end

    def snake_to_camel(str)
      # Helper to instantiate the calculator
      str.split('_').map(&:capitalize).join
    end
  end
end
