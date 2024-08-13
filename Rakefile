require "bundler/gem_tasks"

begin
  require 'github_changelog_generator/task'
rescue LoadError
  # Do nothing if no required gem installed
else
  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.exclude_labels = %w[duplicate question invalid wontfix wont-fix skip-changelog github_actions]
    config.user = 'puppetlabs'
    config.project = 'forge-ruby'
    gem_version = Gem::Specification.load('puppet_forge.gemspec').version
    config.future_release = gem_version
  end
end
