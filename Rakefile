# frozen_string_literal: true

# Fix for the rake tasks failing to run when not within an actual application.
# require "decidim/dev/common_rake"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "parallel_tests/tasks"
require "decidim/dev"

Rake.add_rakelib "lib/tasks"

# Fix for the decidim_dev rake tasks not being loaded because of the fix above
load "#{Gem::Specification.find_by_name("decidim-dev").gem_dir}/lib/tasks/generators.rake"

def install_module(path)
  Dir.chdir(path) do
    system("bundle exec rake decidim_rbac:install:migrations")
    system("bundle exec rake db:migrate")
  end
end

def seed_db(path)
  Dir.chdir(path) do
    system("bundle exec rake db:seed")
  end
end

desc "Generates a dummy app for testing"
task :test_app do
  generate_decidim_app(
    "spec/decidim_dummy_app",
    "--app_name",
    "#{base_app_name}_test_app",
    "--path",
    "../..",
    "--recreate_db",
    "--skip_gemfile",
    "--skip_spring",
    "--force_ssl",
    "false",
    "--locales",
    "en,ca,es"
  )

  ENV["RAILS_ENV"] = "test"
  install_module("spec/decidim_dummy_app")
end

desc "Generates a development app."
task :development_app do
  Bundler.with_original_env do
    generate_decidim_app(
      "development_app",
      "--app_name",
      "#{base_app_name}_development_app",
      "--path",
      "..",
      "--recreate_db",
      "--locales",
      "en,ca,es"
    )
  end

  install_module("development_app")
  seed_db("development_app")
end
