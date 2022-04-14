# frozen_string_literal: true

require_relative "lib/subbundle/version"

Gem::Specification.new do |spec|
  spec.name = "subbundle"
  spec.version = Subbundle::VERSION
  spec.authors = ["Ngan Pham"]
  spec.email = ["ngan@users.noreply.github.com"]

  spec.summary = "Creates a subbundle from your project's bundle."
  spec.homepage = "https://github.com/bigrails/subbundle"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/releases"

  spec.files = Dir["{lib,exe}/**/*", "README.md"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
