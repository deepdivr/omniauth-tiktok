# frozen_string_literal: true

require_relative "lib/omniauth/tiktok/version"

Gem::Specification.new do |spec|
  spec.name          = "omniauth-tiktok"
  spec.version       = Omniauth::Tiktok::VERSION
  spec.authors       = ["Cameron Kolkey"]
  spec.email         = ["Cameron@deepdivr.io"]

  spec.summary       = "Omniauth strategy for Tiktok"
  spec.homepage      = "https://www.github.com/deepdivr/omniauth-tiktok"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.github.com/deepdivr/omniauth-tiktok"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2.12"
  spec.add_runtime_dependency "omniauth-oauth2", "~> 1.6.0"
end
