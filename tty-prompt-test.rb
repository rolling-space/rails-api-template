# frozen_string_literal: true

require 'open-uri'

def download(path, destination)
  repo_file = "https://raw.github.com/wscourge/rails-api-template/master/#{path}"
  begin
    File.delete(destination) if File.exist?(destination)
    IO.copy_stream(open(repo_file), destination)
    # remove_file destination
    # get source, destination
  rescue OpenURI::HTTPError
    puts "Unable to obtain #{source}"
  end
end

def build_tmp
  # tmp = ('a'..'z').to_a.shuffle[0,8].join
  # lib = "#{tmp}/lib"
  # files = "#{tmp}/files"
  # Dir.mkdir(tmp)
  # Dir.mkdir(lib)
  # Dir.mkdir(files)
  # download('lib/ask.rb', "#{lib}/ask.rb")
  # download('lib/defaults.rb', "#{lib}/defaults.rb")


  require_relative('lib/build.rb')
  require_relative('lib/defaults.rb')
  require_relative('lib/gems.rb')
  require_relative('lib/questions.rb')
  require_relative('lib/variant.rb')
  # return dirname so it can be deleted later
  # tmp
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
  # cleanup_tmp
# rescue LoadError
#   tty_required_message
end
