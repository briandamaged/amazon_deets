
Gem::Specification.new do |s|
  s.name        = 'amazon_deets'
  s.version     = '0.0.1'
  s.date        = '2013-08-18'
  s.summary     = "Scrapes product details from an Amazon product page"
  s.description = "Scrapes product details from an Amazon product page"
  s.authors     = ["Brian Lauber"]
  s.email       = 'constructible.truth@gmail.com'
  s.files       = Dir["lib/**/*.rb"]
  s.license     = "MIT"


  s.add_dependency "logbert", "~> 0.6.14"

  s.add_dependency "mechanize", "~> 2.7.0"

end

