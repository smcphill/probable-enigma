# frozen_string_literal: true

require 'rspec'
require_relative '../../../lib/ferociacalc/payment_period'

describe Ferociacalc::PaymentPeriod do
  describe '#initialize' do
    context 'with valid periods' do
      it 'returns the expected period as a symbol' do
        period = 'monthly'
        expect(described_class.new(period).period).to eq(:monthly)
      end
    end

    context 'with invalid periods' do
      it 'accepts unknown period' do
        expect(described_class.new('weekly').period).to eq(:weekly)
      end
    end
  end

  describe '.valid?' do
    it 'considers monthly to be valid' do
      expect(described_class.valid?('monthly')).to be true
    end

    it 'considers unknown periods to be invalid' do
      expect(described_class.valid?('daily')).to be false
    end
  end
end
