gem 'dotenv-rails'
gem 'dry-validation'

gem_group :development do
  gem 'capistrano', '~> 3.11'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'overcommit'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.8'
  gem 'rubocop'
end

gem_group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'fuubar'
  gem 'simplecov'
end

gem_group :development, :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'fasterer'
  gem 'ffaker'
  gem 'pry-byebug'
  gem 'rails_best_practices'
  gem 'rails-controller-testing'
  gem 'reek'
  gem 'rspec-rails'
  gem 'rubocop-rspec'
end

file 'app/services/application_service.rb', <<-CODE
# frozen_string_literal: true

module Services
  class ApplicationService
    def self.call(*args)
      new(*args).call
    end
  end
end
CODE

lib 'generators/service_generator.rb', <<-'CODE'
# frozen_string_literal: true

class ServiceGenerator < Rails::Generators::NamedBase
  def create_service_file
    service_name
    create_file service_file_path, <<-FILE
# frozen_string_literal: true

#{open_modules_nesting}#{open_class}
#{code_indent}def call

#{code_indent}end
    
#{code_indent}private
#{end_class}#{close_modules_nesting}
    FILE

    create_file service_spec_file_path, <<-FILE
# frozen_string_literal: true

RSpec.describe Services::#{class_name}Service do
  describe '#call' do
    
  end
end
    FILE
  end

  private

  def service_name
    @service_name ||= "#{last_part.underscore}_service"
  end

  def last_part
    @last_part ||= namespaces.pop
  end

  def namespaces
    @namespaces ||= %w[Services] + class_name.split('::')
  end

  def service_file_path
    "#{(%w[app] + namespaces.map(&:underscore)).join('/')}/#{service_name}.rb"
  end

  def service_spec_file_path
    "#{(%w[spec] + namespaces.map(&:underscore)).join('/')}/#{service_name}_spec.rb"
  end

  def open_modules_nesting
    namespaces.each.with_index.map { |namespace, index| "#{indent * index}module #{namespace}" }.join('
')
  end

  def close_modules_nesting
    namespaces.each.with_index.map { |_namespace, index| "#{indent * index}end" }.reverse.join('
')
  end

  def open_class
    "
#{class_indent}class #{last_part} < ApplicationService"
  end

  def end_class
"
#{class_indent}end
"
  end

  def class_indent
    @class_indent ||= indent * namespaces.length
  end

  def code_indent
    @code_indent ||= indent * (namespaces.length + 1)
  end

  def indent
    @indent ||= '  '
  end
end
CODE

environment %{config.generators do |generator|
  generator.test_framework :rspec,
                           fixtures: true,
                           controller_specs: true,
                           routing_specs: false,
                           request_specs: false
  generator.fixture_replacement :factory_bot, dir: 'spec/factories'
end}

file '.rspec.sample', <<-CODE
--format Fuubar documentation
--color
--require spec_helper
--require rails_helper
--order defined
--profile
CODE

file '.overcommit.yml', <<-CODE
PreCommit:
  RuboCop:
    description: 'Analyze with RuboCop'
    enabled: true
    required: false
    command: ['bundle', 'exec', 'rubocop'] # Invoke within Bundler context
    required_executable: 'rubocop'
    flags: ['--format=emacs', '--force-exclusion', '--display-cop-names']
    install_command: 'gem install rubocop'
    on_fail: 'warn'
    on_warn: 'pass'
PrePush:
  RSpec:
    enabled: true
    required: false
    description: 'Run RSpec test suite'
    required_executable: 'rspec'
  Brakeman:
    enabled: true
    required: false
    description: 'Run Brakeman'
    required_executable: 'brakeman'
  Fasterer:
    enabled: true
    required: false
    description: 'Run Fasterer'
    required_executable: 'fasterer'
  RailsBestPractices:
    enabled: true
    required: false
    description: 'Run Rails Best Practices'
    required_executable: 'rails_best_practices'
  Reek:
    enabled: true
    required: false
    description: 'Run Reek'
    required_executable: 'reek'
  BundleOutdated:
    enabled: true
    required: false
    description: 'List installed gems with newer versions available'
    required_executable: 'bundle'
    flags: ['outdated', '--strict', '--parseable']
    install_command: 'gem install bundler'
  BundleAudit:
    enabled: true
    required: false
    description: 'Run Bundle Audit'
    required_executable: 'bundle audit'
CODE

file '.reek.yml', <<-CODE
detectors:
  IrresponsibleModule:
    enabled: false
CODE

file '.rubocop.yml', <<-CODE
AllCops:
  Exclude:
    - db/**
    - db/migrate/**
    - bin/**
    - lib/generators/service_generator.rb

Metrics/LineLength:
  Max: 120

Metrics/BlockLength:
  Enabled: true
  Exclude:
    - config/**/*
    - spec/**/*

Documentation:
  Enabled: false
CODE

file '.fasterer.yml', <<-CODE
speedups:
  rescue_vs_respond_to: true
  module_eval: true
  shuffle_first_vs_sample: true
  for_loop_vs_each: true
  each_with_index_vs_while: false
  map_flatten_vs_flat_map: true
  reverse_each_vs_reverse_each: true
  select_first_vs_detect: true
  sort_vs_sort_by: true
  fetch_with_argument_vs_block: true
  keys_each_vs_each_key: true
  hash_merge_bang_vs_hash_brackets: true
  block_vs_symbol_to_proc: true
  proc_call_vs_yield: true
  gsub_vs_tr: true
  select_last_vs_reverse_detect: true
  getter_vs_attr_reader: true
  setter_vs_attr_writer: true

exclude_paths:
  - 'vendor/**/*.rb'
  - 'db/schema.rb'
CODE

file '.circleci/config.yml', <<-CODE

CODE

after_bundle do
  run 'echo ".env" >> .gitignore'
  run 'echo "config/database.yml" >> .gitignore'
  run 'echo ".rspec" >> .gitignore'
  run 'echo "coverage" >> .gitignore'
  run 'touch lib/tasks/.keep'
  run 'cp config/database.yml config/database.yml.sample'
  run 'touch .env'
  run 'cp .env .env.sample'
  run 'rails generate rspec:install'
  run 'cp .rspec.sample .rspec'
  run 'sed -i "1irequire \'simplecov\'\nSimpleCov.start\n\n" spec/spec_helper.rb'
  run 'sed -i "/^[[:blank:]]*#/d;s/#.*//" config/application.rb'
  run 'sed -i "/^[[:blank:]]*#/d;s/#.*//" config/environment.rb'
  run 'rubocop --safe-auto-correct'
  git :init
  git_user_name = ask('Your git user name')
  run "git config user.name #{git_user_name}"
  git_user_email = ask('Your git user email')
  run "git config user.email #{git_user_email}"
  git add: '.'
  git commit: "-a -m 'Initial commit'"
  git_repository_origin = ask('Your git repository origin HTTP or SSH address')
  run "git remote add origin #{git_repository_origin}"
  run 'git hf init'
  run 'overcommit -i'
end
