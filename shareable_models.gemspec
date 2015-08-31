require File.expand_path('../lib/shareable_models/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'shareable_models'
  s.version     = ShareableModels::VERSION
  s.summary     = 'Share resources between your models'
  s.description = 'Dashboards, articles, reports... can be models that '\
                  'users share. We help you to do it easily.'
  s.authors     = ['Angel M Miguel']
  s.email       = 'angelmm@redborder.net'
  s.files       = Dir['{app,lib}/**/*'] + %w(LICENSE README.md)
  s.homepage    = 'http://redborder.net'
  s.require_paths = ['lib']
  s.licenses     = ['AGPL']
  # Main dependencies
  s.add_dependency 'activerecord', '>= 3.2.0'
  s.add_dependency 'railties', '>= 3.2.0'
  # Dependencies for testing
  s.add_development_dependency 'rspec', '>= 3.2'
  s.add_development_dependency 'rspec-rails', '>= 3.2'
end
