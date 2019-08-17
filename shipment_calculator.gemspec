lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shipment_calculator/version'

Gem::Specification.new do |spec|
  spec.name          = 'shipment_calculator'
  spec.version       = ShipmentCalculator::VERSION
  spec.authors       = ['Mykolas Grinevicius']
  spec.email         = ['mykolas@grineviciai.eu']

  spec.summary       = %q{Vinted Shipment Calculator}
  spec.description   = %q{Vinted Shipment Calculator - homework assignment}
  spec.homepage      = "http://www.vinted.com"
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = "http://www.vinted.lt"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = "http://www.vinted.lt"
  spec.metadata['changelog_uri'] = "http://www.vinted.lt"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib', 'config', 'lib/shipment_calculator']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.17.0'
  spec.add_development_dependency 'rubocop', '~> 0.74.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.7'
end
