# frozen_string_literal: true

# sourced from https://www.bendigobank.com.au/calculators/deposit-and-savings/

require 'ferociacalc/cli'

# I can't get this output using rspec output matchers
describe 'integration tests' do
  before do
    $stdout = StringIO.new
  end
  after do
    $stdout = STDOUT
  end

  it 'calculates "-c term_deposit -d 1000 -i 3.5 -t 12 -p monthly"' do
    Ferociacalc::CLI.new(%w[-c term_deposit -d 1000 -i 3.5 -t 12 -p monthly]).run
    $stdout.rewind
    expect($stdout.gets).to eq("Final balance: $1036.00\n")
    expect($stdout.gets).to eq("Total interest earned:  $36.00\n")
  end

  it 'calculates "-c term_deposit -d 1000 -i 0 -t 12 -p monthly"' do
    Ferociacalc::CLI.new(%w[-c term_deposit -d 1000 -i 0 -t 12 -p monthly]).run
    $stdout.rewind
    expect($stdout.gets).to eq("Final balance: $1000.00\n")
    expect($stdout.gets).to eq("Total interest earned:  $0.00\n")
  end

  it 'calculates "-c term_deposit -d 1000 -i 3.5 -t 60 -p monthly"' do
    Ferociacalc::CLI.new(%w[-c term_deposit -d 1000 -i 3.5 -t 60 -p monthly]).run
    $stdout.rewind
    expect($stdout.gets).to eq("Final balance: $1191.00\n")
    expect($stdout.gets).to eq("Total interest earned:  $191.00\n")
  end

end