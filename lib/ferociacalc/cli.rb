# frozen_string_literal: true

require 'optparse'
require 'ferociacalc/calculators'

module Ferociacalc
  # CLI interface
  class CLI < OptionParser
    def initialize(argv = [])
      @inputs = {}
      @argv = argv.dup
      # print help if no args given, or only the calculator has been provided
      @argv << '-h' if @argv.empty? || @argv.size < 3

      super('Usage: ferociacalc -c term_deposit [options; -h for help]')
      # CLI input parsing
      accept_calculator
      calculator_options
      parse_options
    rescue StandardError => e
      # Don't emit stack traces, just return OptionParser guidance
      puts e
    end

    def run
      # Perform the calculation and present the result
      result = @calculator.call(@inputs)
      present_result(result)
    end

    private_methods

    def parse_options
      # I don't know why, but OptionParser isn't honouring my required options.
      # In order to move quickly, and given all args are required, I'm implementing that check
      # here. Perhaps the calculator shouldn't assume the option parser has parsed things.... grrr
      parse!(@argv, into: @inputs)
      required_options = @calculator.class.inputs.keys
      missing_options = required_options - @inputs.keys
      return if missing_options.empty?

      # otherwise, print help and raise
      puts self
      raise "Missing required options: #{missing_options.map(&:to_s).join(', ')}"
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
