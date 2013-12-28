module Travis::CLI
  module Gh
    class Login < ApiCommand
      description "authenticates against GitHub and stores the token"
      include GitHub::Authenticated

      def run
        say color("Successfully logged in as #{color(gh['user']['login'], :bold)}", :success)
      end

      def auth
        auth               = super
        auth.manual_login  = true
        auth.auto_password = false
        auth.auto_token    = false
        auth.github_token  = nil
        auth.check_token   = false
        auth.login_header  = proc { login_header }
        auth
      end

      def login_header
        say "We need your #{color("GitHub login", :important)} to identify you against #{color(github_endpoint.host, :info)}."
        say "The password will not be displayed. No information will be sent to Travis CI."
        empty_line
      end
    end
  end
end