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
      result = @calculator.call(@inputs)
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
      # Acquire the desired calculator and inputs
      accept(Ferociacalc::Calculators::Calculator) do |calc_name|
        clazz = Object.const_get "Ferociacalc::Calculators::#{self.class.snake_to_class_case(calc_name)}"
        clazz.new
      rescue NameError
        raise "Unknown calculator '#{calc_name}'"
      end
    end

    def calculator_options # rubocop:disable Metrics/MethodLength
      # Given calculators know their specific inputs, source CLI options from them instead of codifying here
      on('-c CALCULATOR', '--calculator CALCULATOR', Ferociacalc::Calculators::Calculator,
         'Required CALCULATOR to use (currently, only `term_deposit` is available)') do |calc|
        @calculator = calc
        @calculator.class.inputs.each do |input, details|
          long_option = "--#{input} #{details[:long_opt]}"
          on(details[:short_opt], long_option, details[:option_type], details[:description]) do |option|
            # this enforces any requirements the calculator imposes on the given option (i.e. non-negative balances!)
            details[:requires].call(option)
            @inputs[input] = option
          end
        end
      end
    end

    def self.snake_to_class_case(str)
      # Helper to instantiate the calculator - CLI accepts snake_case inputs but classes are defined in ClassCase
      str.split('_').map(&:capitalize).join
    end
  end
end
