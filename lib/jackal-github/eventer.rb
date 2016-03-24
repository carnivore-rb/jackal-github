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
          payload.get(:pusher) ||
            message[:message].get(:headers, :x_github_event)
        end
      end

      # Format payload based on event type recevied
      #
      # @param message [Carnivore::Message]
      def execute(message)
        failure_wrap(message) do |_|
          content = format_payload(message)
          payload = new_payload(name_for_payload(content), content)
          filter(message, payload) do
            job_completed(:github, payload, message)
          end
        end
      end

      # Apply filters to payload. If filters are enabled
      # and no filter matches, discard payload
      #
      # @param message [Carnivore::Message]
      # @param payload [Smash]
      # @yield block to execute if payload is allowed
      def filter(message, payload)
        valid = true
        a_events = allowed_events(payload)
        r_events = restricted_events(payload)
        if(a_events && !a_events.include?(payload.get(:data, :github, :event)))
          valid = false
        end
        if(r_events && r_events.include?(payload.get(:data, :github, :event)))
          valid = false
        end
        if(valid)
          yield
        else
          warn "Message has been filtered and is restricted from entering pipeline (#{message})"
          message.confirm!
        end
      end

      # Event types allowed to be dropped into pipeline
      #
      # @param payload [Smash]
      # @return [Array, NilClass]
      def allowed_events(payload)
        a_events = config.fetch(:events, :allowed, [])
        a_events += payload.fetch(:data, :github, :query, {}).map do |k,v|
          k if v == 'enabled'
        end.compact
        a_events.empty? ? nil : a_events
      end

      # Event types restricted from being dropped into pipeline
      #
      # @param payload [Smash]
      # @return [Array, NilClass]
      def restricted_events(payload)
        r_events = config.fetch(:events, :restricted, [])
        r_events += payload.fetch(:data, :github, :query, {}).map do |k,v|
          k if v == 'disabled'
        end.compact
        r_events.empty? ? nil : a_events
      end

      # Format the github event to store within the payload
      #
      # @param message [Carnivore::Message]
      # @return [Smash]
      def format_payload(message)
        content = Smash.new
        g_payload = message[:message].get(:headers, :x_github_event) ? message[:message][:body] : unpack(message)
        g_headers = message[:message][:headers] || {}
        g_query = message[:message][:query] || {}
        content[:github] = g_payload.merge(
          Smash.new(
            :event => g_headers.fetch(:x_github_event, 'push'),
            :query => g_query,
            :headers => g_headers,
            :url_path => (message[:message][:request] && message[:message][:request].path)
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
        config.fetch(:names, event,
          config.fetch(:names, :default, :github)
        )
      end

    end
  end
end
