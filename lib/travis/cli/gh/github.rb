require 'travis/tools/github'
require 'json'

module Travis::CLI
  module Gh
    module GitHub
      module Error
        def gh_error(e)
          raise e if explode? or not e.respond_to? :info
          message = e.info[:response_body].to_s
          message = JSON.load(message).fetch('message') rescue nil
          message = "GitHub says: #{message}"
          error message
        end
      end

      module Anonymous
        def gh
          load_gh
          GH
        end
      end

      module Authenticated
        def gh
          @gh ||= auth.with_token do |token|
            plugin_config['token'] = token
            GH.with(token: token)
          end
        end

        def auth
          load_gh
          @auth ||= Travis::Tools::Github.new(session.config['github']) do |g|
            g.note          = "token for travis-cli-gh"
            g.scopes        = ['user', 'user:email', 'repo']
            g.manual_login  = false
            g.explode       = explode?
            g.auto_token    = true
            g.auto_password = true
            g.drop_token    = false
            g.github_token  = plugin_config['token'] || endpoint_config['pr_token']
            g.check_token   = !g.github_token
            g.ask_login     = proc { ask("Username: ") }
            g.ask_password  = proc { |user| ask("Password for #{user}: ") { |q| q.echo = "*" } }
            g.ask_otp       = proc { |user| ask("Two-factor authentication code for #{user}: ") }
            g.debug         = proc { |log| debug(log) }
            g.after_tokens  = proc { g.explode = true and error("no suitable github token found, try running gh-login.") }
          end
        end

        def plugin_config
          config['gihub'] ||= {}
          config['gihub'][github_endpoint.host] ||= {}
        end
      end

      module AutoAuth
        include Authenticated
        def gh
          load_gh
          org? ? GH : super
        end
      end

      module Hooks
        def hooks
          @hooks ||= gh["/repos/#{repository.slug}/hooks"]
        rescue GH::Error
          error "admin access needed for #{repository.slug} in order to access hooks"
        end

        def travis_hook
          @travis_hook ||= hooks.detect { |h| h['name'] == 'travis' }
          error "GitHub hook not found. Project might not be enabled." unless @travis_hook
          @travis_hook
        end
      end
    end
  end
end