require 'jackal-github'

module Jackal
  module Github
    # Process events
    class Eventer < Callback

      # Validity of message
      #
      # @param message [Carnivore::Message]
      # @return [Truthy, Falsey]
      def valid?(message)
        super do |payload|
          payload[:repository] &&
            !payload[:id]
        end
      end

      # Format payload based on event type recevied
      #
      # @param message [Carnivore::Message]
      def execute(message)
        failure_wrap(message) do |*_|
          content = format_payload(message)
          payload = new_payload(name_for_payload(content), payload)
          job_completed(:github, payload, message)
        end
      end

      # Format the github event to store within the payload
      #
      # @param message [Carnivore::Message]
      # @return [Smash]
      def format_payload(message)
        content = Smash.new
        g_payload = message[:message][:body]
        g_headers = message[:message][:headers]
        g_query = message[:message][:query]
        content[:github] = g_payload.merge(
          Smash.new(
            :event => g_headers[:x_github_event],
            :query => g_query,
            :headers => g_headers
          )
        )
        content
      end

      # Provide payload name for given event
      #
      # @param event [String] github event
      # @return [String] payload name
      # @note defaults to `github`
      def name_for_payload(event)
        config.fetch(:names, event, :github)
      end

    end
  end
end
