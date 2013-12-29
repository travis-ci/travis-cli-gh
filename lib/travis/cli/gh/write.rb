require "base64"

module Travis::CLI
  module Gh
    class Write < RepoCommand
      include GitHub::Authenticated, GitHub::Error
      USER_FORMAT = /^(?<name>.+) <(?<email>.+@.+)>$/

      description "write stdin to the given path in the repository"
      on '-b', '--branch BRANCH', 'branch to write to'
      on '-m', '--message MESSAGE', 'commit message'
      on '-C', '--create', 'only create new files'
      on '-U', '--update', 'only update existing files'
      on '-c', '--committer USER', 'set committer (format: "name <email>", defaults to current user)'
      on '-a', '--author USER', 'set author (format: "name <email>", defaults to committer)'
      on '-A', '--append', 'append to file if it already exists'

      def run(path)
        write(path, input.read)
      rescue GH::Error => e
        gh_error(e)
      end

      def write(path, content)
        current = get(path)
        error "file already exists" unless update?
        update(path, content, current)
      rescue GH::Error => e
        gh_error(e) unless e.info[:response_status] == 404
        error "file does not exist" unless create?
        create(path, content)
      end

      def update(path, content, current = get(path))
        error "#{path} is not a file" unless current.respond_to?(:to_hash) and current['type'] == 'file'
        content = Base64.decode64(current['content']) + content if append?
        put(path, content, message: "Update #{path}", sha: current['sha'])
      end

      def create(path, content)
        put(path, content, message: "Create #{path}")
      end

      def put(path, content = "", encoded_content: Base64.encode64(content), **options)
        options[:message]   = message if message
        options[:branch]    = branch  if branch
        options[:content]   = encoded_content.gsub("\n", "")
        options[:path]      = path
        options[:committer] = parse_user(:committer) if committer
        options[:author]    = parse_user(:author)    if author
        gh.put("/repos/#{repository.slug}/contents/#{path}", options)
      end

      def get(path)
        path = "repos/#{repository.slug}/contents/#{path}"
        path << "?ref=#{branch}" if branch
        gh[path]
      end

      def parse_user(field)
        error "wrong format for #{field}, should be NAME <EMAIL>." unless match = USER_FORMAT.match(send(field).to_s)
        { name: match[:name], email: match[:email] }
      end

      def create?
        @create.nil? ? @update.nil? : @create
      end

      def update?
        @update.nil? ? @create.nil? : @update
      end
    end
  end
end