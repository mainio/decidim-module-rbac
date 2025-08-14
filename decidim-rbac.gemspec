# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "decidim/rbac/version"

Gem::Specification.new do |spec|
  spec.metadata = { "rubygems_mfa_required" => "true" }
  spec.name = "decidim-rbac"
  spec.version = Decidim::RBAC.version
  spec.required_ruby_version = ">= 3.3"
  spec.authors = ["Antti Hukkanen"]
  spec.email = ["antti.hukkanen@mainiotech.fi"]

  spec.summary = "Provides RBAC for Decidim."
  spec.description = "Adds RBAC controls for Decidim."
  spec.homepage = "https://github.com/mainio/decidim-module-rbac"
  spec.license = "AGPL-3.0"

  spec.files = Dir[
    "{app,config,db,lib}/**/*",
    "LICENSE-AGPLv3.txt",
    "Rakefile",
    "README.md"
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "decidim-core", Decidim::RBAC.decidim_version
end
