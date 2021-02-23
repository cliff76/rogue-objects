# Rogue-Objects

Rogue-Objects is a set of utilities to help developers write focused unit tests. It includes 
a Rogue-Object component which is a dynamic object that can be created with properties & functions
that can be accessed via dot notation. It also includes various helper functions to to make MiniTest
mock objects slightly simpler.

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

### Rogue-Object use
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

### Minitest Mocking use
Mini test mocks allow you to create objects that expect calls. However your code can get noisy when the object
you're testing makes several chained method calls. Consider the following irresponsible teacher that only 
teaches the first student in class:

```ruby
class IrresponsibleTeacher
  def teach
    @students.first.find_first_lesson.learn(self)
  end
end
```
If we wanted to use mocks we would have to mock the students object and get it to return a mock student.
We would have to tell this mocked student to return a mocked first lesson then tell that mocked lesson 
to expect a call to its learn method. 
```ruby
irresponsible_teacher = IrresponsibleTeacher.new
mock_students = ::Minitest::Mock.new
mock_first_student = ::Minitest::Mock.new
mock_lesson = ::Minitest::Mock.new
mock_students.expect(:first,mock_first_student)
mock_first_student.expect(:find_first_lesson,mock_lesson)
mock_lesson.expect(:learn,nil,[irresponsible_teacher])
```
This code can be simplified by using the `::Rogue::Support::MockMethods.expect_chained_call` method over
the mock. 
```ruby
include ::Rogue::Support::MockMethods
irresponsible_teacher = IrresponsibleTeacher.new
mock_students = ::Minitest::Mock.new
expect_chained_call(mock_students, 'first.find_first_lesson.learn', nil, irresponsible_teacher)
```

In each step of this chained method call our mock will return itself with an expectation to receive the 
next call in the chain.

Mocking in Minitest (as well as other mock object frameworks) reverses the Given/When/Then pattern
in your code. That is, you have to set your assertions/expectations up front (the then part), followed
by the action you want to test. This can make code slightly harder to follow because the thing you want
to test can get lost beneath the mock setup. Consider the following scenario.
We have an order processor which should get the cost and ship our delicate item to San Fransisco.

```ruby
mock_order = ::Minitest::Mock.new
mock_order.expect(:total_cost,29.99)
mock_order.expect(:special_instructions,"handle with care")
mock_order.expect(:ship, nil, "San Fransisco")
@order_processor.process(mock_order)
mock_order.verify
```
Here we are starting with the given, then setting the expectations, and finally taking our action
Following Given/When/Then you woud want to code the expectations after you take the action
of processing the order. With `::Rogue::Support::MockMethods.expect_chained_call` we can reverse
the order of code conceptually but still maintain the order of operations semantically. This is 
supported via a bit of syntax sugar as follows:

```ruby
with_new_mock { |mock_order| @order_processor.process(mock_order) }
  .verify_the_mock do |mock_order|
    mock_order.expect(:total_cost,29.99)
    mock_order.expect(:special_instructions,"handle with care")
    mock_order.expect(:ship, nil, "San Fransisco")
end
```

In the above example we make use of blocks to group the sections and order them
conceptually while the semantic order of execution is preserved. Internally the 
Rogue-Objects API will create a mock object and execute the `verify_the_mock` 
block with this new mock first. This allows all expectations to be set initially.
Control is then delegated to the `with_new_mock` block with this same internal 
mock. The mock is automatically verified after the `with_new_mock` block completes.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rogue. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rogue/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rogue project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rogue/blob/master/CODE_OF_CONDUCT.md).
