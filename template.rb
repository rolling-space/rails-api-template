# frozen_string_literal: true

def cli_indent() '      ' end
def pp(txt) puts "#{cli_indent}#{txt}" end

unless `gem list -i "^tty-prompt$"`[0..3] == 'true'
  continue = ask('    Gem tty-prompt is required to use the RAT, would you like to install it? (y/n)')
  exit unless continue.downcase == 'y'
  pp('Installing tty-prompt')
  pp(`gem install tty-prompt`)
  Gem.clear_paths
end

require 'open-uri'
require 'fileutils'

REPO_LIB = [
  'lib/action_cable.rb',
  'lib/action_mailer.rb',
  'lib/active_job.rb',
  'lib/active_storage.rb',
  'lib/build.rb',
  'lib/config_file.rb',
  'lib/config_application.rb',
  'lib/config_env_development.rb',
  'lib/config_env_production.rb',
  'lib/config_env_test.rb',
  'lib/ci.rb',
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
  'lib/files/config/routes.rb',
  'lib/files/config/sidekiq.yml',
  'lib/files/config/environments/development.rb',
  'lib/files/config/environments/production.rb',
  'lib/files/config/environments/test.rb',
  'lib/files/config/initializers/redis.rb',
  'lib/files/config/initializers/rswag_api.rb',
  'lib/files/config/initializers/sidekiq.rb',
  'lib/files/spec/rails_helper.rb',
  'lib/files/spec/spec_helper.rb'
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
  Dir.mkdir("#{tmp}/lib/files/config/environments")
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

if ask.git
  ask.git_remote
  if ask.git_credentials
    ask.git_username
    ask.git_email
  end
  ask.git_branching_model
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
  run 'rails db:setup'
  run 'bundle exec rubocop --safe-auto-correct --format quiet' if build.gems.rubocop?
  if variant[:git]
    gitflow = variant[:git_branching_model] == :gitflow
    hubflow = variant[:git_branching_model] == :hubflow
    run "git remote add origin #{variant[:git_remote]}"
    run "git config user.email #{variant[:git_email]}" if variant[:git_credentials]
    run "git config user.name #{variant[:git_username]}" if variant[:git_credentials]
    run "git add ."
    run "git commit -m 'Initial commit (RAT)'"
    run "git flow init" if gitflow
    run "git hf init" if hubflow
    run "git push -u origin master"
    run "git push -u origin develop" unless hubflow
  end
end

FileUtils.remove_dir(tmp)
