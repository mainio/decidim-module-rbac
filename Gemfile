# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

# Inside the development app, the relative require has to be one level up, as
# the Gemfile is copied to the development_app folder (almost) as is.
base_path = ""
base_path = "../" if File.basename(__dir__) == "development_app"
require_relative "#{base_path}lib/decidim/rbac/version"

# Temporarily load Decidim from GitHub because developing against the current
# development version.
# DECIDIM_VERSION = Decidim::RBAC.decidim_version

gem "decidim", github: "decidim/decidim", branch: "develop"
gem "decidim-rbac", path: "."

gem "bootsnap", "~> 1.4"
gem "puma", ">= 6.6.0"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", github: "decidim/decidim", branch: "develop"
end

group :development do
  gem "faker", "~> 3.2"
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.9"
  gem "web-console", "~> 4.2"
end
