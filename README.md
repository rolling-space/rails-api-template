# RAT - Rails API Template

An opinionated template for `rails new api_name --api`

## Prerequisites

All that has to be done before using the template

1. Ruby with Ruby on Rails gem installed
2. MySQL or PostgreSQL + user with READ / WRITE permissions
3. Redis (if you want to use it)
4. Git & remote git repository (if you want to use it)
5. Internet connection

## Usage

To initialize your new Rails API with the template, run

```
rails new api_name --api -m https://raw.githubusercontent.com/wscourge/rails-api-template/master/template.rb
```

## Installation wizzard

The template is based on an awesome [tty-prompt](https://github.com/piotrmurach/tty-prompt/) gem
which enhances CLI input options vastly.

If the gem isn't on your machine, it will be installed given the permission to do so.

After installing the gem, all the template files will be downloaded to the temporarily
created directory for further installation process. It might take a while.

Next, you will be asked questions about your preferred confguration:

1. Database - MySQL or PostgreSQL
   - username
   - password
   - host
2. Redis
   - URL
   - DB number
   - port
   - Sentinel _(optional)_
     - URL
     - DB
     - port
     - slaves host names
   - Sidekiq _(optional)_
     - namespace
3. Git _(optional)_
   - credentials _(optional)_
     - username
     - email
   - branching model
     - hubflow
     - gitflow
     - none
4. Installation type
   - Default
   - Custom
     - Production gems
     - Development gems
     - Test gems
     - Continous Integration

## Insights

All stuff included in the freshly new Rails API

### All environments

```
  ⬢ DRY Validation
  ⬢ Fast JSON API (Netflix)
  ⬢ HTTParty
  ⬢ RSWAG
  ⬢ ActionCable
  ⬢ ActionMailer
  ⬢ ActiveJob
  ⬢ ActiveStorage
```

### Development

```
  ⬢ Better Errors
  ⬢ Brakeman
  ⬢ Bundler Audit
  ⬢ Fasterer (Fastruby)
  ⬢ Nested Generators
  ⬢ binding.pry
  ⬢ Rails Best Practices
  ⬢ RuboCop
  ⬡ Spring # not selected by default!
```

### Test

```
  ⬢ Database Cleaner
  ⬢ Coveralls
  ⬢ Factory Bot
  ⬢ FFaker
  ⬢ Rails Controller Testing
  ⬢ RSpec
  ⬢ SimpleCov
  ⬢ Shoulda Matchers
  ⬢ TimeCop
```

### CircleCI

CircleCI configuration is autogenerated in standard `.circleci/config`, and it
checks:

- brakeman
- bundler-audit
- fasterer
- rails_best_practices
- rspec
- rubocop
