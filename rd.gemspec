Gem::Specification.new do |s|
  s.name = 'rd'
  s.version = '0.0.3'
  s.date = '2011-05-27'

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
  s.extra_rdoc_files = %w[README.md]

  s.add_dependency 'nokogiri'
  s.add_dependency 'rainbow'

  s.homepage = "https://github.com/4pcbr/rd"
  s.require_paths = %w[lib]
end
