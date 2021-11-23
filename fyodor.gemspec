$:.push File.expand_path("../lib", __FILE__)
require "fyodor/version"

Gem::Specification.new do |s|
  s.name         = 'fyodor'
  s.version      = Fyodor::VERSION
  s.licenses     = ['GPL-3.0-only']
  s.summary      = 'Kindle clippings parser'
  s.description  = "Parse Kindle clippings into markdown files"
  s.authors      = ["Rafael Cavalcanti"]
  s.email        = 'dev@rafaelc.org'
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(README.md LICENSE)
  s.executables  = ['fyodor']
  s.add_dependency 'toml', '~> 0.1'
  s.add_dependency 'optimist', '~> 3.0'
  s.required_ruby_version = '>= 2.5', '< 3'
  s.homepage     = 'https://github.com/rccavalcanti/fyodor'
  s.metadata     = { "source_code_uri" => "https://github.com/rccavalcanti/fyodor" }
end
