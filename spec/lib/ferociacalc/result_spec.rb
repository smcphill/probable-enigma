# frozen_string_literal: true

require_relative '../../../lib/ferociacalc/result'

describe Ferociacalc::Result do
  let(:calculation) { 1000.123456 }
  let(:interest) { 5.012357 }
  let(:result) { described_class.new(calculation, interest) }

  describe '#total' do
    it 'sets the total as a float' do
      expect(result.total).to eq(calculation)
    end
  end

  describe '#interest_accrued' do
    it 'sets the interest_accrued as a float' do
      expect(result.interest_accrued).to eq(interest)
    end
  end
end
