
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tetromino/version"

Gem::Specification.new do |spec|
  spec.name          = "tetromino"
  spec.version       = Tetromino::VERSION
  spec.authors       = ["deliver.ee"]
  spec.email         = ["1337@deliver.ee"]

  spec.summary       = %q{
                        First fit heuristic algorithm for 4D
                        bin packing problem solver (4dbpp)
                      }
  spec.description   = %q{
                        An implementation of the "4D" bin packing
                        problem i.e. given a list of items, how many boxes
                        do you need to fit them all in taking into account
                        physical dimensions and weights.
                        It also allow to declare items that are not stackables
                        nor invertibles (ie. you need to pack fragile items).
                      }
  spec.homepage      = "https://github.com/deliver-ee/tetromino"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "pry", "~> 0.11.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.16.1"
end
