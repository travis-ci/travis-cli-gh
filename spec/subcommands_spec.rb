require 'travis/cli'
require 'travis/cli/gh'

describe Travis::CLI::Gh::Subcommands do
  before :all do
    Travis::CLI::Gh.setup
  end

  it "resolves commands with gh-prefix" do
    Travis::CLI.command('gh-signature').should be == Travis::CLI::Gh::Signature
  end

  it "lists gh commands" do
    Travis::CLI.commands.should include(Travis::CLI::Gh::Signature)
  end

  it "prefixes the command name" do
    Travis::CLI.command('gh-signature').command_name.should be == 'gh-signature'
  end

  it "prefixes the description" do
    Travis::CLI.command('gh-signature').description.should start_with("GitHub plugin: ")
  end
end
