# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version = '0.1'
  gem.authors = ["Nestor Salceda"]
  gem.email = ["nestor@nestorsalceda.com"]
  gem.description = ""
  gem.summary = ""
  gem.homepage = ""
  gem.license = ''

  gem.files = `git ls-files`.split($\)
  gem.executables = gem.files.grep(%r{^bin}).map{ |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)})
  gem.name = "bolt"
  gem.require_paths = ["lib"]
end

