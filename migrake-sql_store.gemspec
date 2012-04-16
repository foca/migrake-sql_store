# For some reason, 'require "migrake/version"' doesn't work in jruby (1.6.6, on
# 1.9 mode), even with RUBYOPT=-Ilib, so resorting to this hackery.
require File.expand_path("../lib/migrake/sql_store/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "migrake-sql_store"
  s.version     = Migrake::SqlStore::VERSION
  s.description = "Migrake storage engine to use a SQL database instead of the filesystem"
  s.summary     = "SQL storage engine for Migrake"
  s.authors     = ["Nicolas Sanguinetti"]
  s.email       = "hi@nicolassanguinetti.info"
  s.homepage    = "http://github.com/foca/migrake-sql_store"
  s.has_rdoc    = false
  s.files       = `git ls-files`.split "\n"
  s.platform    = Gem::Platform::RUBY

  s.add_dependency("migrake", "~> 0.2")
  s.add_dependency("sequel",  "~> 3.34")
  s.add_development_dependency("minitest")
  s.add_development_dependency("sqlite3")
end
