# -*- ruby -*-

clean_white_space = lambda do |entry|
  entry.gsub(/(\A\n+|\n+\z)/, '') + "\n"
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))
require "optuna/version"

Gem::Specification.new do |spec|
  spec.name = "red-optuna"
  spec.version = Optuna::VERSION
  spec.homepage = "https://github.com/red-data-tools/red-optuna"
  spec.authors = ["Kouhei Sutou"]
  spec.email = ["kou@clear-code.com"]

  readme = File.read("README.md")
  readme.force_encoding("UTF-8")
  spec.summary = clean_white_space.call(readme.split(/^\#+\s(.*)$/)[2])
  entries = readme.split(/^\#\#\s(.*)$/)
  description = clean_white_space.call(entries[entries.index("Description") + 1])
  spec.description, = description.split(/\n\n+/, 3)
  spec.license = "MIT"
  spec.files = [
    "README.md",
    "LICENSE.txt",
    "Rakefile",
    "Gemfile",
    "#{spec.name}.gemspec",
  ]
  spec.files += Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("example/**/*.rb")

  spec.add_development_dependency("bundler")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("red-datasets-numo-narray")
  spec.add_development_dependency("rumale")
end
