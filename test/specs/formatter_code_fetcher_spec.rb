require 'jackal-github'

describe Jackal::Github::Eventer do

  before do
    @runner = run_setup(:formatter)
  end

  after do
    @runner.terminate if @runner && @runner.alive?
  end


  [:commit_comment, :create, :delete, :deployment, :deployment_status,
    :pull_request, :push, :status].each do |event_name|

    describe "code fetcher formatting for #{event_name} event" do

      it 'should apply code fetcher formatting' do
        response = HTTP.post(
          'http://127.0.0.1:5667/v2/github',
          :json => payload_for(event_name, :raw => true),
          :headers => {
            'X-GitHub-Event' => event_name
          }
        )
        response.body.to_s.must_equal 'So long and thanks for all the fish!'
        source_wait{ !MessageStore.messages.empty? }
        result = MessageStore.messages.pop
        result.get(:data, :code_fetcher, :info, :name).must_equal 'public-repo'
        result.get(:data, :code_fetcher, :info, :source).must_equal 'github'
        result.get(:data, :code_fetcher, :info, :private).must_equal false
        result.get(:data, :code_fetcher, :info, :url).must_equal 'https://github.com/baxterthehacker/public-repo.git'
        result.get(:data, :code_fetcher, :info, :owner).must_equal 'baxterthehacker'
      end

    end
  end
end
