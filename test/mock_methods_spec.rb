require 'minitest/spec'
require 'minitest/autorun'
require 'rogue/support/mock_methods'
include ::Rogue::Support::MockMethods

describe ::Rogue::Support::MockMethods do
  before do
    # Given a new @mock
    @mock = ::Minitest::Mock.new
  end
  it 'should return expected value from @mock chained call' do
    # when we set an expected chain call with a return value
    expect_chained_call(@mock, 'foo.bar.baz', true)
    # then the ret_val set on the expected chain call should be returned
    # as we make the chain call
    assert @mock.foo.bar.baz
  end

  it 'should fail if expected chained call is not made on the @mock' do
    # when we set an expected chain call with a true ret_val
    expect_chained_call(@mock, 'foo.bar.baz', true)
    lambda {
      # and we verify the @mock without calling any methods
      @mock.verify
      # then we...
    }.must_raise(MockExpectationError)
  end

  it 'should fail if only some of the expected chained calls are made on the @mock' do
    # when we set an expected chain call
    expect_chained_call(@mock, 'foo.bar.baz', true)
    lambda {
      # and we only call some of the methods
      @mock.foo.bar
      # and we verify the @mock
      @mock.verify
      # then we...
    }.must_raise(MockExpectationError)
  end

  it 'returns the ret_value when args are expected passed' do
    # when we set an expected chain call with arguments and a true ret_val
    expect_chained_call(@mock, 'foo.bar.baz', true, [1, 2, 3])
    # then the ret_val set on the expected chain call should be returned
    # as we make the chain call
    assert @mock.foo.bar.baz(1, 2, 3)
    @mock.verify
  end

  it 'returns the ret_value when symbol args are expected passed' do
    # when we set an expected chain call with symbol arguments and a true ret_val
    expect_chained_call(@mock, 'foo.bar.baz', true, [:one, :two, :three])
    # then the ret_val set on the expected chain call should be returned
    # as we make the chain call
    assert @mock.foo.bar.baz(:one, :two, :three)
    @mock.verify
  end

  it 'will run the given block to verify the final method call in the chain' do
    expect_chained_call(@mock, 'foo.bar.baz', true, nil) do |one, two, three, four|
      one.must_equal 'one'
      two.must_equal 'two'
      three.must_equal 3
      four.must_equal :four
    end
    @mock.foo.bar.baz('one', 'two', 3, :four)
    @mock.verify
  end
end

describe MockContext do
  it 'will create a Mocking Context to run code inside when you call with_new_mock' do
    result = with_new_mock { |new_mock| new_mock.some_method('some value') }
    assert_instance_of MockContext, result, 'should return @mocking context'
    result.verify_the_mock { |the_mock| the_mock.expect(:some_method, nil, ['some value']) }
  end

  it 'will verify the @mock at the end of the MockContext' do
    begin
      with_new_mock { |new_mock| new_mock }
        .verify_the_mock { |the_mock| the_mock.expect(:some_method, nil) }
    rescue MockExpectationError => e
      assert_equal('expected some_method() => nil', e.to_s)
    end

    with_new_mock { |new_mock| new_mock.some_method('some value') }
      .verify_the_mock { |the_mock| the_mock.expect(:some_method, nil, ['some value']) }
  end
end
