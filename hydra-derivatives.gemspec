# coding: utf-8
version = File.read(File.expand_path("../VERSION", __FILE__)).strip

Gem::Specification.new do |spec|
  spec.name          = "hydra-derivatives"
  spec.version       = version
  spec.authors     = ["Boston Public Library"]
  spec.email       = ["bbarber@bpl.org", "eenglish@bpl.org"]
  spec.description   = %q{Derivative generation plugin for hydra}
  spec.summary       = %q{Derivative generation plugin for hydra}
  spec.license       = "APACHE2"
  spec.homepage      = "https://github.com/samvera/hydra-derivatives"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "jettywrapper", '~> 1.8.0', '< 2'
  spec.add_development_dependency "rspec", '~> 3.8'
  spec.add_development_dependency "pry"

  spec.add_dependency 'active-fedora', '>= 8.0.1', '< 9'
  spec.add_dependency 'hydra-file_characterization', '~> 1.0.0'
  spec.add_dependency 'mini_magick', '~> 4.9.2'
  spec.add_dependency 'posix-spawn', '~> 0.3.11'
  spec.add_dependency 'activesupport', '>= 4.0', '< 6'
end
