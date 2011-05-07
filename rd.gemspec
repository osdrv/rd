Gem::Specification.new do |s|
  s.name = 'rd'
  s.version = '0.0.1'
  s.date = '2011-05-07'

  s.description = 'ruby kernel classes documentation cli tool'
  s.summary = s.description

  s.authors = ['4pcbr']
  s.email = 'i4pcbr@gmail.com'

  s.files = %w[
    README.md
    bin/rd
    lib/rklass.rb
  ]

  s.executables = ['rd']
  s.extra_rdoc_files = %w[README]

  s.add_dependency 'nokogiri'
  s.add_dependency 'rainbow'

  s.homepage = "http://rd.4pcbr.com"
  s.require_paths = %w[lib]
end
