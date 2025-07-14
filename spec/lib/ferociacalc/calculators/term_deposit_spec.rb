# frozen_string_literal: true
require 'ferociacalc/calculators/term_deposit'

describe Ferociacalc::Calculators::TermDeposit do
  describe '#call' do
    let(:initial_deposit) { 1000.0 }
    let(:interest_rate) { 3.5 }
    let(:deposit_term) { 12 }
    let(:interest_period) { 'monthly' }
    let(:result) do
      inputs = {
        initial_deposit: initial_deposit,
        interest_rate: interest_rate,
        deposit_term: deposit_term,
        interest_period: interest_period
      }
      described_class.new.call(inputs)
    end

    it 'returns a Result' do
      returned_result = class_double(Ferociacalc::Result).as_stubbed_const
      allow(Ferociacalc::Result).to receive(:new).with(0, 0).and_return(returned_result)

      result

      # TODO: update once #call has been implemented
      # expect(returned_result).to have_received(:new).with(1036, 36)
      expect(returned_result).to have_received(:new).with(0, 0)
    end
  end

  describe '.inputs' do
    it 'has the 4 input args required for the calculation' do
      expect(described_class.inputs.size).to eq(4)
    end

    it 'has the expected input keys' do
      expected_keys = %i[initial_deposit interest_rate deposit_term interest_period]
      expect(described_class.inputs.keys).to match_array(expected_keys)
    end

    describe 'initial_deposit' do
      let(:input) { described_class.inputs[:initial_deposit] }

      it 'has the expected short option' do
        expect(input[:short_opt]).to eq('-d DOLLARS')
      end

      it 'is a float' do
        expect(input[:option_type]).to eq(Float)
      end

      it 'requires positive values gte 1000' do
        expect { input[:requires].call(1000) }.to_not raise_error

      end

      it 'raises on positive values lt 1000' do
        expect { input[:requires].call(10) }.to raise_error(/must provide a valid initial deposit amount/)
      end

      it 'raises on negative values' do
        expect { input[:requires].call(-2) }.to raise_error(/must provide a valid initial deposit amount/)
      end
    end

    describe 'interest_rate' do
      let(:input) { described_class.inputs[:interest_rate] }

      it 'has the expected short option' do
        expect(input[:short_opt]).to eq('-i PERCENT')
      end

      it 'is a float' do
        expect(input[:option_type]).to eq(Float)
      end

      it 'requires positive values' do
        expect { input[:requires].call(2) }.to_not raise_error

      end

      it 'raises on negative values' do
        expect { input[:requires].call(-2) }.to raise_error(/must provide a valid interest rate number/)
      end
    end

    describe 'deposit_term' do
      let(:input) { described_class.inputs[:deposit_term] }

      it 'has the expected short option' do
        expect(input[:short_opt]).to eq('-t MONTHS')
      end

      it 'is an integer' do
        expect(input[:option_type]).to eq(Integer)
      end

      it 'requires positive values' do
        expect { input[:requires].call(2) }.to_not raise_error

      end

      it 'raises on negative values' do
        expect { input[:requires].call(-2) }.to raise_error(/must provide a valid number of months/)
      end
    end

    describe 'interest_period' do
      let(:input) { described_class.inputs[:interest_period] }

      it 'has the expected short option' do
        expect(input[:short_opt]).to match(/^-p/)
      end

      it 'is a String' do
        expect(input[:option_type]).to eq(String)
      end

      it 'requires a valid interest period' do
        expect { input[:requires].call('monthly') }.to_not raise_error

      end

      it 'raises on an invalid interest period' do
        expect { input[:requires].call('daily') }.to raise_error(/must provide a valid interest period/)
      end
    end
  end
end
