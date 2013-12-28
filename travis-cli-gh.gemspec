$:.unshift File.expand_path("../lib", __FILE__)
require "travis/cli/gh/version"

Gem::Specification.new do |s|
  s.name                  = "travis-cli-gh"
  s.version               = Travis::CLI::Gh::VERSION
  s.author                = "Konstantin Haase"
  s.email                 = "konstantin@travis-ci.com"
  s.homepage              = "https://github.com/travis-ci/travis-cli-gh"
  s.summary               = %q{GitHub plugin for Travis CI command line client}
  s.description           = %q{Adds commands to interact with the GitHub API}
  s.license               = 'MIT'
  s.files                 = `git ls-files`.split("\n")
  s.test_files            = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables           = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path          = 'lib'
  s.extensions            = ["setup/extconf.rb"]
  s.required_ruby_version = '>= 2.0.0'

  # runtime dependencies
  s.add_dependency 'travis', '~> 1.6'
  s.add_dependency 'gh',     '~> 0.13'

  # development depenendencies
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"

  # prereleases from Travis CI
  s.version = s.version.to_s.succ + ".travis.#{ENV['TRAVIS_JOB_NUMBER']}" if ENV['CI']
end