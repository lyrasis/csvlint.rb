lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "csvlint/version"

Gem::Specification.new do |spec|
  spec.name = "csvlint"
  spec.version = Csvlint::VERSION
  spec.authors = ["pezholio"]
  spec.email = ["pezholio@gmail.com"]
  spec.description = "CSV Validator"
  spec.summary = "CSV Validator"
  spec.homepage = "https://github.com/theodi/csvlint.rb"
  spec.license = "MIT"

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = [">= 2.5", "< 3.5"]

  spec.add_dependency "csv"
  spec.add_dependency "rainbow"
  spec.add_dependency "open_uri_redirections"
  spec.add_dependency "activesupport"
  spec.add_dependency "addressable"
  spec.add_dependency "typhoeus"
  spec.add_dependency "escape_utils"
  spec.add_dependency "uri_template"
  spec.add_dependency "thor"
  spec.add_dependency "rack"
  spec.add_dependency "net-http-persistent"
  spec.add_dependency "mutex_m" # For Ruby 3.4+

  spec.add_development_dependency "bundler", ">= 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "simplecov-rcov"
  spec.add_development_dependency "spork"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-pride"
  spec.add_development_dependency "rspec-expectations"
  spec.add_development_dependency "coveralls_reborn"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "github_changelog_generator"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "rdf", "< 4.0"
  spec.add_development_dependency "rdf-turtle"
  # spec.add_development_dependency "standardrb"
  spec.add_development_dependency "appraisal"
end
