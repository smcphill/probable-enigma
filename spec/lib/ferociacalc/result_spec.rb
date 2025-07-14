# frozen_string_literal: true

require_relative '../../../lib/ferociacalc/result'

describe Ferociacalc::Result do
  let(:calculation) { 1000.0 }
  let(:interest) { 3.5 }
  let(:result) { described_class.new(calculation, interest) }

  describe '#total' do
    it 'sets the total as a float of appropriate precision' do
      expect(result.total).to eq(1000.0)
    end
  end

  describe '#interest_accrued' do
    it 'sets the interest_accrued as a float of appropriate precision' do
      expect(result.interest_accrued).to eq(3.5)
    end
  end
end
