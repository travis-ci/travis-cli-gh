require "base64"

module Travis::CLI
  module Gh
    class Cat < RepoCommand
      include GitHub::AutoAuth, GitHub::Error

      description "displays the contents of a file on GitHub"
      on '-b', '--ref REF', 'ref to look up the file (defaults to default branch)'

      def run(*paths)
        paths.each do |path|
          say fetch(path)
        end
      end

      def fetch(path)
        path = "repos/#{repository.slug}/contents/#{path}"
        path << "?ref=#{ref}" if ref
        Base64.decode64(gh[path]['content'])
      rescue GH::Error => e
        gh_error(e)
      end
    end
  end
end