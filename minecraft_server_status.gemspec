# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minecraft_server_status/version'

Gem::Specification.new do |spec|
  spec.name          = "minecraft_server_status"
  spec.version       = MinecraftServerStatus::VERSION
  spec.authors       = ["Ryo Oba"]
  spec.email         = ["ryo.oba.ggl@gmail.com"]
  spec.summary       = %q{Ruby gem for retrieving status from Minecraft server}
  spec.description   = %q{Ruby gem for retrieving status from Minecraft server}
  spec.homepage      = "https://github.com/ryooob/minecraft_server_status"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'json', '~> 1.8.1'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-byebug"
end
