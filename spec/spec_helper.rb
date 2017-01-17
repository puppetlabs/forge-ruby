PROJECT_ROOT = File.join(File.dirname(__FILE__), '..')

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end

end

require 'puppet_forge'

module StubbingFaraday

  def stub_api_for(klass, base_url = "http://api.example.com")
    allow(klass).to receive(:conn) do
      Faraday.new :url => base_url do |builder|
        builder.use PuppetForge::Middleware::SymbolifyJson
        builder.response(:json, :content_type => /\bjson$/)
        builder.response(:raise_error)
        builder.use(:connection_failure)

        builder.adapter(:test) { |s| yield(s) }
      end
    end

    stubs = Faraday::Adapter::Test::Stubs.new
  end

  def stub_fixture(stubs, method, path)
    stubs.send(method, path) do |env|
      load_fixture([ env[:url].path, env[:url].query ].compact.join('?'))
    end
  end

  def load_fixture(path)
    xplatform_path = path.to_s.gsub('?', '__')

    [ 404 ].tap do |response|
      local = File.join(PROJECT_ROOT, 'spec', 'fixtures', xplatform_path)

      if File.exists?("#{local}.headers") && File.exists?("#{local}.json")
        File.open("#{local}.headers") do |file|
          response[0] = file.readline[/\d{3}/].to_i
          response[1] = headers = {}
          file.read.scan(/^([^:]+?):(.*)/) do |key, val|
            headers[key] = val.strip
          end
        end

        response << File.read("#{local}.json")
      end
    end
  end
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.include StubbingFaraday

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.before(:example) do
    @old_host = PuppetForge.host
  end

  config.after(:example) do
    PuppetForge.host = @old_host
  end
end
