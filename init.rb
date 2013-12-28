begin
  raise LoadError, "requires Ruby 2.0 or later" if RUBY_VERSION < '2.0'
  require 'travis/cli/gh'
  Travis::CLI::Gh.setup
rescue LoadError => e
  require 'travis/cli'

  dummy = Class.new(Travis::CLI::Command) do
    define_method(:run) { error "GitHub plugin not available: #{color e.message, :bold}" }
  end

  Travis::CLI.module_eval do
    alias_method :command_without_gh, :command unless method_defined? :command_without_gh
    define_method(:command) do |name|
      name =~ /^gh-/ ? dummy : command_without_gh(name)
    end
  end
end
