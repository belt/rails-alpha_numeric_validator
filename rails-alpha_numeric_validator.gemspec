# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails/alpha_numeric_validator/version'

REQUIREMENTS = {
  runtime: {
    rails: ['~> 3.2.13']},
  development: {
    bundler: ['~> 1.3'],
    rake: ['>= 0'],
    sqlite3: ['>= 1.3.7'],
    debugger: ['>= 1.5.0'],
    rspec: ['>= 2.13.0']}
}

Gem::Specification.new do |spec|
  spec.name = 'rails-alpha_numeric_validator'
  spec.version = Rails::AlphaNumericValidator::VERSION
  spec.authors = ['Paul Belt']
  spec.email = %w(saprb@channing.harvard.edu)
  spec.description = %q{validate model attributes follow specific guidelines e.g. only printable characters, no whitespace, etc}
  spec.summary = %q{validate model attributes follow specific guidelines e.g. only printable characters, no whitespace, etc}
  spec.homepage = 'https://github.com/belt/rails-alpha_numeric_validator'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |fn| File.basename(fn) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.required_ruby_version = Gem::Requirement.new('>= 1.9.2')
  spec.required_rubygems_version = Gem::Requirement.new('>= 0') if spec.respond_to? :required_rubygems_version=

  [:runtime, :development].each do |mode|
    REQUIREMENTS[mode].each do |req, ver|
      if spec.respond_to? :specification_version
        spec.specification_version = 3
        if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0')
          if mode == :runtime
            spec.add_runtime_dependency req.to_s, ver
          else
            spec.add_development_dependency req.to_s, ver
          end
        else
          spec.add_dependency req.to_s, ver
        end
      else
        spec.add_dependency req.to_s, ver
      end
    end
  end
end
