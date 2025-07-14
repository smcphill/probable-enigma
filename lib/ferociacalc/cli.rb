# frozen_string_literal: true

require 'optparse'

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
      raise NotImplementedError
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
      raise NotImplementedError
    end

    def accept_calculator
      # Acquire the desired calculator
      raise NotImplementedError
    end

    def accept_inputs
      # request required inputs from the selected calculator
      raise NotImplementedError
    end
  end
end
