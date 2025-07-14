# frozen_string_literal: true

require 'ferociacalc/calculators/calculator'
require 'ferociacalc/result'
require 'ferociacalc/payment_period'

module Ferociacalc
  module Calculators
    # Term deposit calculator
    class TermDeposit < Calculator
      def self.inputs # rubocop:disable Metrics/MethodLength
        interest_periods = Ferociacalc::PaymentPeriod.interest_periods
        # defines the inputs this calculator requires. the toplevel keys here are used by `#call`
        {
          initial_deposit: {
            short_opt: '-d DOLLARS',
            long_opt: 'DOLLARS',
            option_type: Float,
            description: 'Required Initial deposit amount in dollars (minimum 1000.00)',
            requires: lambda do |val|
              raise "must provide a valid initial deposit amount (was #{val})" unless val.positive? && val >= 1_000
            end
          },
          interest_rate: {
            short_opt: '-i PERCENT',
            long_opt: 'PERCENT',
            option_type: Float,
            description: 'Required Interest rate % p.a (0-15; e.g. 3% is 3, not 0.03)',
            requires: lambda do |val|
              raise "must provide a valid interest rate number (was #{val})" unless (val >= 0) && (val <= 15)
            end
          },
          deposit_term: {
            short_opt: '-t MONTHS',
            long_opt: 'MONTHS',
            option_type: Integer,
            description: 'Required Deposit term in months (0-60; e.g. 12)',
            requires: lambda do |val|
              raise "must provide a valid number of months (was #{val})" unless (val.positive?) && (val <= 60)
            end
          },
          interest_period: {
            short_opt: "-p PERIOD < #{interest_periods.join(' | ')} >",
            long_opt: "PERIOD < #{interest_periods.join(' | ')} >",
            option_type: String,
            description: "Required Interest payment period (e.g. #{interest_periods[0]})",
            requires: lambda do |val|
              raise "must provide a valid interest period (was #{val})" unless Ferociacalc::PaymentPeriod.valid?(val)
            end
          }
        }
      end

      def call(inputs)
        # perform the term deposit calculation and return a Ferociacalc::Result
        # Formula for compounding deposits: A = P (1 + r)^(n)
        # where
        # A = ending balance
        # P = starting balance (or principal)
        # r = interest rate per period as a decimal (for example, 2% becomes 0.02)
        # n = the number of time periods
        # (source: https://moneysmart.gov.au/saving/compound-interest)
        #
        # note our interest rate is per annum, and our stated deposit period is monthly
        # and the compounding period can be any of Ferociacalc::PaymentPeriod.class.VALID_PERIODS,
        # so don't forget to take this into consideration
        #
        # note also our percentage is not expected as a decimal (e.g. 2% is 2.0, not 0.02)
        #
        # furthermore, we need to compound a _term_ deposit: A = P (1 + r/n)^(nt)
        # which introduces the term (t) element
        # (source: https://www.ujjivansfb.in/banking-blogs/deposits/how-compound-interest-in-fixed-deposits-work)
        if inputs[:interest_period] != 'monthly'
          raise NotImplementedError, 'This submission only supports interest being paid monthly at the moment'
        end
        puts inputs
        calculation = 0
        inputs[:initial_deposit] = 0
        # interest accrued will be the final calculation, less initial deposit
        # note this will need updating should we need to model fees or other transactions
        Result.new(calculation, calculation - inputs[:initial_deposit])
      end
    end
  end
end
