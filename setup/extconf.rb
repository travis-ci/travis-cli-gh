$:.unshift File.expand_path('../lib', __dir__)

require 'travis/cli/gh'
Travis::CLI::Gh.setup(true)

# fake Makefile
File.open('Makefile', 'w') { |f| f.puts 'all:', 'install:' }
