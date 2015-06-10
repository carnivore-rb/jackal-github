require 'jackal'

module Jackal
  module Github
    autoload :Eventer, 'jackal-github/eventer'
  end
end

require 'jackal-github/formatter'
require 'jackal-github/version'

Jackal.service(
  :github,
  :description => 'Accept GitHub event payloads',
  :category => :modifier,
  :configuration => {
    :names => {
      :type => :hash,
      :description => 'Set payload name based on event type'
    },
    :events__allowed => {
      :type => :array,
      :description => 'List of allowed event types'
    },
    :events__restricted => {
      :type => :array,
      :description => 'List of restricted event types'
    }
  }
)
