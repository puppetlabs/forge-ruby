PROJECT_ROOT = File.join(File.dirname(__FILE__), '..')

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end

end

require 'puppet_forge'

module StubbingHer
  def stub_api_for(klass)
    klass.use_api begin
      Her::API.new :url => "http://api.example.com" do |c|
        c.use PuppetForge::Middleware::JSONForHer
        c.adapter(:test) { |s| yield(s) }
      end
    end
  end

  def stub_fixture(api, method, path)
    api.send(method, path) do |env|
      load_fixture([ env[:url].path, env[:url].query ].compact.join('?'))
    end
  end

  def load_fixture(path)
    [ 404 ].tap do |response|
      local = File.join(PROJECT_ROOT, 'spec', 'fixtures', path.to_s)

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
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.include StubbingHer

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
