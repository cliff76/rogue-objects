require 'minitest/autorun'

module Rogue
  module Support
    module MockMethods
      # Chained method calls in the form of mock.first.second.third
      # can be made on a mock with this auxillary method
      def expect_chained_call(mock, chain_call, ret_val, args = [])
        calls = chain_call.split('.')
        calls[0, calls.length - 1].each do |each|
          mock.expect(each.to_sym, mock)
        end
        mock.expect(calls.last, ret_val, args) unless block_given?
        if block_given?
          mock.expect(calls.last, ret_val) do |*var_args|
            yield var_args
          end
        end
      end

      # A Mock context allows us to code the mock expectations AFTER the tested method
      class MockContext
        def initialize(block)
          @block = block
          @mock = ::Minitest::Mock.new
        end

        def verify_the_mock(&verify_block)
          verify_block&.call(@mock)
          @block.call(@mock)
          @mock.verify
        end
      end
      def with_new_mock(&block)
        MockContext.new(block)
      end
    end
  end
end
