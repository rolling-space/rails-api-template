# frozen_string_literal: true

require 'open-uri'

REPO_LIB = [
  'lib/build.rb',
  # 'lib/ci.rb',
  # 'lib/config_file.rb',
  # 'lib/defaults.rb',
  # 'lib/dry_validation.rb',
  # 'lib/fast_jsonapi.rb',
  # 'lib/gemfile.rb',
  # 'lib/questions.rb',
  # 'lib/rspec.rb',
  # 'lib/rubocop.rb',
  # 'lib/travis.rb',
  # 'lib/writer.rb',
  # 'lib/capistrano.rb',
  # 'lib/circle.rb',
  # 'lib/db.rb',
  # 'lib/dotenv.rb',
  # 'lib/fasterer.rb',
  # 'lib/gems.rb',
  # 'lib/redis.rb',
  # 'lib/rswag.rb',
  # 'lib/sidekiq.rb',
  # 'lib/variant.rb',
  # 'lib/files/Gemfile',
  # 'lib/files/.fasterer.yml',
  # 'lib/files/.gitlab-ci.yml',
  # 'lib/files/.travis.yml',
  # 'lib/files/.gitignore',
  # 'lib/files/.env',
  # 'lib/files/.rubocop.yml',
  # 'lib/files/.rspec',
  # 'lib/files/.circleci/config.yml',
  # 'lib/files/config/application.rb',
  # 'lib/files/config/database-mysql.yml',
  # 'lib/files/config/database-pgsql.yml',
  # 'lib/files/config/sidekiq.yml',
  # 'lib/files/config/initializers/redis.rb',
  # 'lib/files/config/initializers/rswag_api.rb',
  # 'lib/files/config/initializers/sidekiq.rb',
  # 'lib/files/spec/rails_helper.rb',
  # 'lib/files/spec/spec_helper.rb',
]

def download(path, destination)
  repo_file = "https://raw.github.com/wscourge/rails-api-template/master/#{path}"
  begin
    # File.delete(destination) if File.exist?(destination)
    # IO.copy_stream(open(repo_file), destination)
    remove_file destination
    get repo_file, destination
  rescue OpenURI::HTTPError
    puts "Unable to obtain #{path}"
  end
end

def build_tmp
  tmp = ('a'..'z').to_a.shuffle[0,8].join
  Dir.mkdir(tmp)
  Dir.mkdir("#{tmp}/lib")
  Dir.mkdir("#{tmp}/lib/files")
  Dir.mkdir("#{tmp}/lib/files/spec")
  Dir.mkdir("#{tmp}/lib/files/config")
  Dir.mkdir("#{tmp}/lib/files/config/initializers")
  Dir.mkdir("#{tmp}/lib/files/.circleci")

  REPO_LIB.each do |path|
    download(path, "#{tmp}/#{path}")
  end
  puts "pwd: #{`pwd`}"
  puts "__dir__: #{__dir__}"
  puts "__FILE__: #{__FILE__}"
  puts "exp: #{File.expand_path("#{tmp}/lib/build", `pwd`)}"
  puts `ls -altrh #{tmp}/lib/build.rb`
  require_relative("#{tmp}/lib/build.rb")
  puts "class: #{Template::Build.class}"
  # require_relative("#{`pwd`}/#{tmp}/lib/defaults.rb")
  # require_relative("#{`pwd`}/#{tmp}/lib/gems.rb")
  # require_relative("#{`pwd`}/#{tmp}/lib/questions.rb")
  # require_relative("#{`pwd`}/#{tmp}/lib/variant.rb")
  # return dirname so it can be deleted later
  tmp
end

def red(text)
  "\033[31m#{text}\033[0m"
end

def red_bold(text)
  "\033[31;1m#{text}\033[0m"
end

def tty_required_message
  puts red_bold('┌────────────────────────────────────────────────────┐')
  puts red_bold('│ TEMPLATE ERROR:                                    │')
  puts      red('│ tty-prompt is required to use this template - run: │')
  puts red_bold('│ gem install tty-prompt                             │')
  puts      red('│ and try again afer installation finishes           │')
  puts      red('│ https://github.com/piotrmurach/tty-prompt          │')
  puts red_bold('└────────────────────────────────────────────────────┘ ')
end

begin
  tmp = build_tmp
  return 
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
  File.delete(tmp)
# rescue LoadError
#   tty_required_message
end
