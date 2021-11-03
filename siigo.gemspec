require File.expand_path('../lib/siigo/version', __FILE__)

Gem::Specification.new do |s|
  s.name    = "siigo"
  s.version = Siigo::VERSION

  s.required_ruby_version = '>= 2.7.2'

  s.authors = ["Andrés Carvajal"]
  s.email = ["andres.carvajal@prodalca.com.co"]
  s.summary = "Tool for migration of Siigo data"
  s.description = s.summary
  #s.homepage = "http://pryrepl.org"
  s.licenses = ['MIT']

  #s.executables   = ["siigo"]
  s.require_paths = ["lib"]
  s.files         = `git ls-files bin lib *.md LICENSE`.split("\n")

  #s.add_dependency 'coderay',       '~> 1.1.0'
  #s.add_dependency 'method_source', '~> 0.8.1'
  #s.add_development_dependency 'bundler', '~> 1.0'
end
