module Travis::CLI
  module Gh
    module Subcommands
      module CommandMixin
        def description(input = nil)
          "GitHub plugin: #{super(input)}"
        end

        def command_name
          "gh-#{super}"
        end
      end

      def command(name)
        if name =~ /^gh-(.+)$/
          const_name = command_name($1)
          constant   = Gh.const_get(const_name) if const_name =~ /^[A-Z][a-z]+$/ and Gh.const_defined? const_name
          constant.extend(CommandMixin) if constant
        end
        command?(constant) ? constant : super
      end

      def commands
        super + gh_commands
      end

      def gh_commands
        Gh.constants.map { |c| Gh.const_get(c).extend(CommandMixin) }.select { |c| command? c }
      end
    end
  end
end