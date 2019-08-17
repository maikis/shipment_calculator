require 'shipment_calculator'

ARGV[0].nil? ? ShipmentCalculator.calculate : ShipmentCalculator.calculate(ARGV[0])
