lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shipment_calculator/version'

Gem::Specification.new do |spec|
  spec.name          = 'shipment_calculator'
  spec.version       = ShipmentCalculator::VERSION
  spec.authors       = ['Mykolas Grinevicius']
  spec.email         = ['mykolas@grineviciai.eu']

  spec.summary       = 'Vinted Shipment Calculator'
  spec.description   = 'Vinted Shipment Calculator - homework assignment'
  spec.homepage      = 'http://www.vinted.com'
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = 'http://www.vinted.lt'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'http://www.vinted.lt'
  spec.metadata['changelog_uri'] = 'http://www.vinted.lt'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib', 'config', 'data', 'lib/shipment_calculator']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'factory_bot', '~> 5.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.7'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.74.0'
  spec.add_development_dependency 'simplecov', '~> 0.17.0'
end
