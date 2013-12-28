require 'digest/sha2'

module Travis::CLI
  module Gh
    class Signature < RepoCommand
      description "generates the signature used to verify Travis CI web hooks"
      include GitHub::Authenticated, GitHub::Hooks

      def run
        signature = Digest::SHA2.hexdigest(repository.slug + travis_hook["config"]["token"])
        say signature, "Signature used for #{repository.slug} web hooks: %s"
      end
    end
  end
end