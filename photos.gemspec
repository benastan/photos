# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'photos/version'

Gem::Specification.new do |spec|
  spec.name          = "photos"
  spec.version       = Photos::VERSION
  spec.authors       = ["Benjamin Bergstein"]
  spec.email         = ["bennyjbergstein@gmail.com"]

  spec.summary       = "Simple CLI for browsing photos on s3."
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "shotgun"
  spec.add_dependency "dotenv"
  spec.add_dependency "faraday"
  spec.add_dependency "sinatra"
  spec.add_dependency "slim"
  spec.add_dependency "aws-sdk"
end
