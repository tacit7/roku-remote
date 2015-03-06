Gem::Specification.new do |spec|
  spec.name          = 'roku-remote-rb'
  spec.version       = '0.0.1'
  spec.summary       = "" 
  spec.description   = "A CLI for controlling your roku."
  spec.authors       = "Uriel Maldonado"
  spec.email         = 'uriel781@gmail.com'

  spec.files         = ["lib/roku_cli.rb", "lib/roku_client.rb"]
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]
  spec.executables   = ['roku-remote-rb']

  spec.add_runtime_dependency "httparty"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
end
