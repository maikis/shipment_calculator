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

  describe '#providers' do
    let(:provider_config) { { 'MR' => { 'S' => 2 }, 'LP' => { 'S' => 1.5 } } }

    let(:all_providers) do
      [ShipmentCalculator::Provider.new(
         provider_config.keys[0],
         provider_config.values[0]
       ),
       ShipmentCalculator::Provider.new(
        provider_config.keys[1],
        provider_config.values[1]
       )]
    end

    before do
      allow(ShipmentCalculator).to receive(:providers).and_return(all_providers)
    end

    it 'has providers' do
      expect(base_rule.providers).to include(ShipmentCalculator::Provider)
    end
  end
end
