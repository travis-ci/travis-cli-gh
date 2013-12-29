require 'travis/cli'
require 'fileutils'

module Travis
  module CLI
    module Gh
      autoload :Cat,         'travis/cli/gh/cat'
      autoload :Fetch,       'travis/cli/gh/fetch'
      autoload :GitHub,      'travis/cli/gh/github'
      autoload :Login,       'travis/cli/gh/login'
      autoload :Signature,   'travis/cli/gh/signature'
      autoload :Subcommands, 'travis/cli/gh/subcommands'
      autoload :Upload,      'travis/cli/gh/upload'
      autoload :VERSION,     'travis/cli/gh/version'
      autoload :Whoami,      'travis/cli/gh/whoami'
      autoload :Write,       'travis/cli/gh/write'

      extend self

      def setup(force = false)
        setup_commands(force)
        setup_plugin(force)
        setup_completion(force)
      end

      def setup_commands(force)
        CLI.singleton_class.send(:prepend, Subcommands)
      end

      def setup_plugin(force)
        target_dir = File.expand_path('travis-cli-gh', config_path)
        target     = File.expand_path('init.rb', target_dir)
        source     = File.expand_path('../../../init.rb', __dir__)
        if force or !File.exist?(target)
          FileUtils.mkdir_p(target_dir)
          FileUtils.cp(source, target)
        end
      end

      def setup_completion(force)
        cmp_file = File.expand_path('travis.sh', config_path)
        unless File.exist?(cmp_file) and File.read(cmp_file).include?("travis-cli-gh #{VERSION}")
          require 'travis/tools/completion'
          Travis::Tools::Completion.compile
          Travis::Tools::Completion.update_completion
          content = File.read(cmp_file)
          File.write(cmp_file, "# travis-cli-gh #{VERSION}\n\n#{content}")
        end
      end

      def config_path
        ENV.fetch('TRAVIS_CONFIG_PATH') { File.expand_path('.travis', ENV['HOME']) }
      end
    end
  end
end