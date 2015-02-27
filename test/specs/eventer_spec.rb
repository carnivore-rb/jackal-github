require 'http'
require 'jackal-github'

describe Jackal::Github::Eventer do

  before do
    @runner = run_setup(:web)
  end

  after do
    @runner.terminate if @runner && @runner.alive?
  end

  describe 'request input' do

    it 'should accept github payloads and inject into system' do
      response = HTTP.post(
        'http://127.0.0.1:5667/v2/github',
        :json => payload_for(:push, :raw => true),
        :headers => {
          'X-GitHub-Event' => 'push'
        }
      )
      response.body.to_s.must_equal 'So long and thanks for all the fish!'
      source_wait{ !MessageStore.messages.empty? }
      result = MessageStore.messages.pop
      result.get(:data, :github).wont_be :nil?
    end

  end
end
