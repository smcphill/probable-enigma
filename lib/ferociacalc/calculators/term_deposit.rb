# frozen_string_literal: true

require 'ferociacalc/calculators/calculator'
require 'ferociacalc/result'
require 'ferociacalc/payment_period'

module Ferociacalc
  module Calculators
    # Term deposit calculator
    class TermDeposit < Calculator
      def self.inputs # rubocop:disable Metrics/MethodLength
        # defines the inputs this calculator requires. the toplevel keys here are used by `#call`
        # TODO should requires impose range conditions? (i.e. maximal rate, minimal deposit)
        {
          initial_deposit: {
            short_opt: '-d DOLLARS',
            long_opt: 'DOLLARS',
            option_type: Float,
            description: 'Required Initial deposit amount in dollars (e.g. 1000)',
            requires: lambda do |val|
              raise "must provide a positive initial deposit amount (was #{val})" unless val.positive?
            end
          },
          interest_rate: {
            short_opt: '-i PERCENT',
            long_opt: 'PERCENT',
            option_type: Float,
            description: 'Required Interest rate % p.a. (e.g. 3% is 3.0, not 0.03)',
            requires: lambda do |val|
              raise "must provide a positive interest rate number (was #{val})" unless val.positive?
            end
          },
          deposit_term: {
            short_opt: '-t MONTHS',
            long_opt: 'MONTHS',
            option_type: Integer,
            description: 'Required Deposit term in months (e.g. 12)',
            requires: lambda do |val|
              raise "must provide a positive number of months (was #{val})" unless val.positive?
            end
          },
          interest_period: {
            short_opt: '-p PERIOD < monthly | quarterly | annually | at_maturity >',
            long_opt: 'PERIOD < monthly | quarterly | annually | at_maturity >',
            option_type: String,
            description: 'Required Interest payment period (e.g. monthly)',
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
        puts inputs
        Result.new(0, 0)
      end
    end
  end
end
