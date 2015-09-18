# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'amazon/search'

Gem::Specification.new do |gem|
  gem.name        = %q{amazon-search}
  gem.version     = Amazon::Search::VERSION
  gem.date        = '2015-09-18'
  gem.platform = Gem::Platform::RUBY

  gem.files = Dir['lib/   *.rb'] + Dir['bin/*']
  gem.files += Dir['[A-Z]*'] + Dir['test/**/*']
  gem.test_files = `git ls-files -- test/*`.split("\n")
  gem.require_paths = ["lib"]

  gem.summary     = "A simple screenscraper to search Amazon"
  gem.description = "Simple screenscraper to search Amazon and return product titles, urls, image href, etc."
  gem.authors     = ["John Mason"]
  gem.email       = 'mace2345@gmail.com'
  gem.homepage    = 'https://github.com/m8ss/amazon-search'

  gem.license       = 'MIT'

  gem.add_runtime_dependency('mechanize',    '~> 2.7')
end



