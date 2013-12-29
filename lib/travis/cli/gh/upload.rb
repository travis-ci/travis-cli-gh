require "base64"

module Travis::CLI
  module Gh
    class Upload < Write
      description "upload one or more files to the repository"
      on '-p', '--prefix DIR', 'prefix to store it under'

      def run(*paths)
        paths.each do |source|
          error "cannot read #{source}" unless File.readable? source
          target  = File.basename(source)
          target  = File.join(prefix, target) if prefix
          message = "Uploading " << color(source, :important)
          message << " as " << color(target, :important) if target != source
          say message
          write(target, File.read(source))
        end
      rescue GH::Error => e
        gh_error(e)
      end
    end
  end
end