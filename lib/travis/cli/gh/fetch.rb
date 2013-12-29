module Travis::CLI
  module Gh
    class Fetch < Cat
      description "download a file from a repository"
      on '-p', '--prefix DIR', 'prefix to store it under'
      on '-f', '--force', 'override existing files'

      def run(*paths)
        error "no such directory #{prefix}" unless prefix.nil? or File.directory? prefix
        paths.each do |path|
          target = File.expand_path(path, prefix || Dir.pwd)
          error "#{path} already exists, use -f to override" if !force and File.exist?(target)
          say "storing contents of #{color(path, :bold)} as #{color(target, :bold)}"
          File.write(target, fetch(path))
        end
      end
    end
  end
end