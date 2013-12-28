module Travis::CLI
  module Gh
    class Whoami < ApiCommand
      description "displays the user you are logged in as on GitHub"
      include GitHub::Authenticated

      def run
        say gh['user']['login'], 'logged in as %s'
      end
    end
  end
end