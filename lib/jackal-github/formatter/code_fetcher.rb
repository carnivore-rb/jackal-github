require 'jackal-github'

module Jackal
  module Github
    module Formatter

      class CodeFetcher < Jackal::Formatter

        # Format payloads from source
        SOURCE = '*'
        # Formats for destination
        DESTINATION = 'code_fetcher'

        # Format the payload to provide code fetcher information
        #
        # @param payload [Smash]
        # @return [Smash]
        def format(payload)
          if(payload.get(:data, :github))
            payload.set(:data, :code_fetcher, :info, :source, 'github')
            payload.set(:data, :code_fetcher, :info, :owner,
              payload.get(:data, :github, :repository, :owner, :login))
            payload.set(:data, :code_fetcher, :info, :name,
              payload.get(:data, :github, :repository, :name))
            payload.set(:data, :code_fetcher, :info, :private,
              payload.get(:data, :github, :repository, :private))
            payload.set(:data, :code_fetcher, :info, :url,
              payload.get(:data, :github, :repository, :clone_url))
            set_reference_information(payload.get(:data, :github, :event).to_s, payload)
            payload
          end
        end

        # Set repository reference information into payload if
        # available
        #
        # @param event [String] github event type
        # @param payload [Smash]
        # @return [Smash]
        def set_reference_information(event, payload)
          method_name = "#{event}_reference"
          if(self.respond_to?(method_name, true))
            ref, sha = send(method_name, payload)
            payload.set(:data, :code_fetcher, :info, :reference, ref)
            payload.set(:data, :code_fetcher, :info, :commit_sha, sha)
          end
          payload
        end

        private

        # Format for commit comment event
        #
        # @param payload [Smash]
        # @return [Array<String>] [reference, commit_id]
        def commit_comment_reference(payload)
          [payload.get(:data, :github, :comment, :commit_id),
            payload.get(:data, :github, :comment, :commit_id)]
        end

        # Format for create event
        #
        # @param payload [Smash]
        # @return [Array<String>] [reference, commit_id]
        def create_reference(payload)
          [payload.get(:data, :github, :ref),
            payload.get(:data, :github, :ref)]
        end
        alias_method :delete_reference, :create_reference

        # Format for deployment event
        #
        # @param payload [Smash]
        # @return [Array<String>] [reference, commit_id]
        def deployment_reference(payload)
          [payload.get(:data, :github, :deployment, :ref),
            payload.get(:data, :github, :deployment, :sha)]
        end
        alias_method :deployment_status_reference, :deployment_reference

        # Format for pull request event
        #
        # @param payload [Smash]
        # @return [Array<String>] [reference, commit_id]
        def pull_request_reference(payload)
          payload.set(:data, :code_fetcher, :info, :owner,
            payload.get(:data, :github, :pull_request, :head, :repo, :owner, :login))
          payload.set(:data, :code_fetcher, :info, :name,
            payload.get(:data, :github, :pull_request, :head, :repo, :name))
          payload.set(:data, :code_fetcher, :info, :private,
            payload.get(:data, :github, :pull_request, :head, :repo, :private))
          payload.set(:data, :code_fetcher, :info, :url,
            payload.get(:data, :github, :pull_request, :head, :repo, :clone_url))
          [payload.get(:data, :github, :pull_request, :head, :ref),
            payload.get(:data, :github, :pull_request, :head, :sha)]
        end

        # Format for push event
        #
        # @param payload [Smash]
        # @return [Array<String>] [reference, commit_id]
        def push_reference(payload)
          payload.set(:data, :code_fetcher, :info, :owner,
            payload.get(:data, :github, :repository, :owner, :name))
          [payload.get(:data, :github, :ref),
            payload.get(:data, :github, :head_commit, :id)]
        end

        # Format for status event
        #
        # @param payload [Smash]
        # @return [Array<String>] [reference, commit_id]
        def status_reference(payload)
          [payload.get(:data, :github, :sha),
            payload.get(:data, :github, :sha)]
        end

      end
    end
  end
end
