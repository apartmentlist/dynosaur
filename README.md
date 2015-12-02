# Dynosaur

Run a rake task in a separate process (locally or on Heroku)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dynosaur'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dynosaur

## Usage

```ruby
Dynosaur::Client::HerokuClient.configure do |config|
  config.app_name = '<Heroku app name>'
  config.api_key = '<Heroku API key>'
end

dyno = Dynosaur::Process::Heroku.new(task: 'session:destroy', args: [2500])
dyno.start
# => run.9876

local_process = Dynosaur::Process::Local.new(task: 'session:destroy', args: [2500])
local_process.start
# => 48345
```

You can also check to see if a similar rake task is already running before starting
the task (e.g. if you want at most one instance of that task running concurrently)

```ruby
dyno = Dynosaur::Process::Heroku.new(task: 'session:destroy', args: [2500])
dyno.start unless dyno.running?
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dynosaur/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
