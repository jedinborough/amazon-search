Gem::Specification.new do |s|
  s.name        = 'amazon-search'
  s.version     = '1.1.4'
  s.date        = '2015-09-17'

  s.summary     = "A simple screenscraper to search Amazon"
  s.description = "Simple screenscraper to search Amazon and return product titles, urls, image href, etc."

  s.authors     = ["John Mason"]
  s.email       = 'mace2345@gmail.com'


  s.files       = ["lib/amazon-search.rb"]
  s.homepage    = 'https://github.com/m8ss/amazon-search'

  s.license       = 'MIT'

  s.add_runtime_dependency('mechanize',    '~> 2.7')
end
