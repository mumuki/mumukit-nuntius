# Mumukit::Nuntius

> Simple wrapper for rabbitmq

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mumukit-nuntius'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mumukit-nuntius

## Consuming a queue

```ruby
    Mumukit::Nuntius::Consumer.start queue_name do |delivery_info, properties, body|
      # do something here
    end

```

## Publishing data

```ruby
    Mumukit::Nuntius.notify! :recipes, name: 'Asado', steps: ['add salt to meat', 'more steps']
    Mumukit::Nuntius.notify_event!(:user_banned, {user: 'Nene Malo'}, sender: 'my_app')
```

## Establishing connection

Since version 6.x.x the connection must be explicitly established:

`Mumukit::Nuntius.establish_connection`

If the server that uses Nuntius has multiple puma workers configured, the best option is to do it `on_worker_boot`.       
If it runs in single mode, it should be done toplevel in `config.ru`, because that hook isn't called.

Also consumers establish connections on start out of the box  

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mumukit-nuntius.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

