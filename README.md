# Rogue-Objects

Rogue-Objects is a set of utilities to help developers write focused unit tests. It includes 
a Rogue-Object component which is a dynamic object that can be created with properties & functions
that can be accessed via dot notation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rogue'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rogue

## Usage

Scenario:
You need to test a DuckHunter which requires an object that looks like a duck and quacks like a duck
but you don't want to create an actual duck. Rogue-Objects give you an `obj` expression you can use
to create a lightweight object that looks like a duck and quacks like a duck. This is an object with
all the properties/methods of a duck. See the following:

```ruby
duck = obj(feathers:true, color:'black', name: 'Daffy',
           speak: proc{ "Quack!"},
           fly: proc {|location| location.y += 100})
```

Consider a DuckHunter which looks for this animal and calls methods and accesses properties via dot
notation.
```ruby
class DuckHunter
  def hunt
    if @duck.feathers && @duck.color == 'black'
      @duck.fly
      while @duck.speak == 'Quack!'
        shoot(@duck)
      end
    end
  end
end
```
This hunter can be supplied with our duck without the need to load the actual Duck class, formally create
a Duck class substitution class, or use too much noise code from mock frameworks.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rogue. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rogue/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rogue project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rogue/blob/master/CODE_OF_CONDUCT.md).
