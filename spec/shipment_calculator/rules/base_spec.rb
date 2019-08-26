require 'spec_helper'

RSpec.describe ShipmentCalculator::Rules::Base do
  subject(:base_rule) { described_class.new }

  class TestRule < ShipmentCalculator::Rules::Base
  end

  context 'when subclass has no #apply method' do
    it 'raises error' do
      expect { TestRule.new.apply }.to raise_error(NotImplementedError)
    end
  end

  context 'when subclass has #apply method' do
    let(:test_rule) { TestRule.new }

    before do
      class << test_rule
        def apply
          'it works'
        end
      end
    end

    it 'does not raise error' do
      expect { test_rule.apply }.not_to raise_error
    end
  end
end
