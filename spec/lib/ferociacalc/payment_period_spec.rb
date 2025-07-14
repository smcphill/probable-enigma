# frozen_string_literal: true

require 'rspec'
require_relative '../../../lib/ferociacalc/payment_period'

describe Ferociacalc::PaymentPeriod do
  describe '#initialize' do
    context 'with valid periods' do
      it 'accepts lowercase' do
        period = 'monthly'
        expect(described_class.new(period).period).to eq('monthly')
      end

      it 'accepts uppercase' do
        period = 'QUARTERlY'
        expect(described_class.new(period).period).to eq('quarterly')
      end

      it 'accepts strings with underscores like at_maturity' do
        period = 'at_maturity'
        expect(described_class.new(period).period).to eq('at_maturity')
      end
    end

    context 'with invalid periods' do
      it 'accepts unknown period' do
        expect(described_class.new('weekly').period).to eq('weekly')
      end
    end
  end

  describe '.valid?' do
    it 'considers monthly to be valid' do
      expect(described_class.valid?('monthly')).to be true
    end

    it 'considers unknown periods to be invalid' do
      expect(described_class.valid?('DAILY')).to be false
    end
  end
end
