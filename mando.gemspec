# frozen_string_literal: true

require_relative "lib/mando/version"

Gem::Specification.new do |spec|
  spec.name = "mando"
  spec.version = Mando::VERSION
  spec.authors = ["Tom de Grunt"]
  spec.email = ["tom@degrunt.nl"]

  spec.summary = "Command pattern"
  spec.description = "Command pattern for Ruby"
  spec.homepage = "https://github.com/entdec/mando"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/entdec/mando"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "actionpack", "~> 7.1"
  spec.add_dependency "activemodel", "~> 7.1"
  spec.add_dependency "activejob", "> 7.1"
  spec.add_dependency "activesupport", "~> 7.1"
  spec.add_development_dependency "debug", "~> 1.9"
  spec.add_development_dependency "rubocop", "~> 1"
  spec.add_development_dependency "standard", "~> 1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
