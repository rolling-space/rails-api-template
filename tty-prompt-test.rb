# frozen_string_literal: true

def cli_indent() '      ' end
def pp(txt) puts "#{cli_indent}#{txt}" end

unless `gem list -i "^tty-prompt$"`[0..3] == 'true'
  continue = ask('    Gem tty-prompt is required to use the RAT, would you like to install it? (y/n)')
  exit unless continue.downcase == 'y'
  pp('Installing tty-prompt')
  `gem install tty-prompt`
end

require 'open-uri'
require 'fileutils'

REPO_LIB = [
  'lib/build.rb',
  'lib/ci.rb',
  'lib/config_file.rb',
  'lib/defaults.rb',
  'lib/dry_validation.rb',
  'lib/fast_jsonapi.rb',
  'lib/gemfile.rb',
  'lib/questions.rb',
  'lib/rspec.rb',
  'lib/rubocop.rb',
  'lib/travis.rb',
  'lib/writer.rb',
  'lib/capistrano.rb',
  'lib/circle.rb',
  'lib/db.rb',
  'lib/dotenv.rb',
  'lib/fasterer.rb',
  'lib/gems.rb',
  'lib/redis.rb',
  'lib/rswag.rb',
  'lib/sidekiq.rb',
  'lib/variant.rb',
  'lib/files/Gemfile',
  'lib/files/.fasterer.yml',
  'lib/files/.gitlab-ci.yml',
  'lib/files/.travis.yml',
  'lib/files/.gitignore',
  'lib/files/.env',
  'lib/files/.rubocop.yml',
  'lib/files/.rspec',
  'lib/files/.circleci/config.yml',
  'lib/files/config/application.rb',
  'lib/files/config/database-mysql.yml',
  'lib/files/config/database-pgsql.yml',
  'lib/files/config/sidekiq.yml',
  'lib/files/config/initializers/redis.rb',
  'lib/files/config/initializers/rswag_api.rb',
  'lib/files/config/initializers/sidekiq.rb',
  'lib/files/spec/rails_helper.rb',
  'lib/files/spec/spec_helper.rb',
]

def download(path, destination)
  repo_file = "https://raw.github.com/wscourge/rails-api-template/master/#{path}?ts=#{Date.new.to_time}"
  begin
    File.delete(destination) if File.exist?(destination)
    IO.copy_stream(open(repo_file), destination)
  rescue OpenURI::HTTPError
    pp("Unable to obtain #{path}")
  end
end

def build_tmp
  tmp = ('a'..'z').to_a.shuffle[0,8].join
  lib = "#{`pwd`[0..-2]}/#{tmp}/lib/"

  Dir.mkdir(tmp)
  Dir.mkdir("#{tmp}/lib")
  Dir.mkdir("#{tmp}/lib/files")
  Dir.mkdir("#{tmp}/lib/files/spec")
  Dir.mkdir("#{tmp}/lib/files/config")
  Dir.mkdir("#{tmp}/lib/files/config/initializers")
  Dir.mkdir("#{tmp}/lib/files/.circleci")
  $LOAD_PATH.unshift(tmp) unless $LOAD_PATH.include?(tmp)

  REPO_LIB.each.with_index do |path, index|
    download(path, "#{tmp}/#{path}")
    printf("\r#{cli_indent}Downloading template files: %d/#{REPO_LIB.length - 1}", index)
  end
  puts ''

  require("#{lib}build.rb")
  require("#{lib}defaults.rb")
  require("#{lib}gems.rb")
  require("#{lib}questions.rb")
  require("#{lib}variant.rb")
  # return dirname so it can be deleted later
  tmp
end

tmp = build_tmp
ask = Template::Questions.new
ask.db_provider

unless ask.db_sqlite?
  ask.db_username
  ask.db_password
  ask.db_host
end

if ask.redis
  ask.redis_url
  ask.redis_db
  ask.redis_port
  if ask.sentinel
    ask.sentinel_url
    ask.sentinel_db
    ask.sentinel_port
    ask.sentinel_hosts
  end
  ask.sidekiq_namespace if ask.sidekiq
end

ask.type

if ask.custom?
  ask.prd
  ask.dev
  ask.tst
  ask.ci
end

variant = Template::Variant.new(ask.answers).options
build = Template::Build.new(app_name: app_name, answers: variant)
build.call

after_bundle do
  run 'bundle exec rubocop --safe-auto-correct --format quiet' if build.gems.rubocop?
end

FileUtils.remove_dir(tmp)
