Gem::Specification.new do |s|
  s.name         = 'fyodor'
  s.version      = '0.1.1'
  s.licenses     = ['GPL-3.0-only']
  s.summary      = 'Kindle clippings parser'
  s.description  = "Parse Kindle clippings into markdown files"
  s.authors      = ["Rafael Cavalcanti"]
  s.email        = 'code@rafaelc.org'
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(README.md LICENSE)
  s.executables  = ['fyodor']
  s.add_dependency 'toml', '~> 0.0.3'
  s.homepage     = 'https://github.com/rccavalcanti/fyodor'
  s.metadata     = { "source_code_uri" => "https://github.com/rccavalcanti/fyodor" }
end
