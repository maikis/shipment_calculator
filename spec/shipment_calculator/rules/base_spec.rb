require 'spec_helper'

RSpec.describe ShipmentCalculator::Rules::Base do
  class TestRule < ShipmentCalculator::Rules::Base
  end

  context 'when subclass has no #apply method' do
    it 'raises error' do
      expect { TestRule.new.apply(double) }.to raise_error(NotImplementedError)
    end
  end

  context 'when subclass has #apply method' do
    let(:test_rule) { TestRule.new }

    before do
      class << test_rule
        def apply(transaction_data)
          'it works'
        end
      end
    end

    it 'does not raise error' do
      expect { test_rule.apply(double) }.not_to raise_error
    end
  end
end
