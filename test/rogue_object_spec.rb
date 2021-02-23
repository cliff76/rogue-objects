require 'minitest/autorun'
require "rogue"
include ::Rogue
describe 'RogueObject' do
  before do
    @rogue_object = RogueObject.new
  end

  it 'can be set with arbitrary properties' do
    @rogue_object.with_properties(first_name:'Clifton', last_name: 'Craig')
  end

  it 'can retrieve arbitrary properties with dot notation' do
    @rogue_object.with_properties(first_name:'Clifton', last_name: 'Craig')
    @rogue_object.first_name.must_equal 'Clifton'
    @rogue_object.last_name.must_equal 'Craig'
  end

  it 'can create RogueObjects using obj() function' do
    a_rogue_object = obj(first_name:'Clifton', last_name: 'Craig')
    a_rogue_object.must_be_instance_of RogueObject
  end

  it 'can assign and call procs via arbitrary keys' do
    # Given a rogue object with a Ruby proc mapped to a key
    a_rogue_object = obj(say_my_name_is: proc {|name| "my name is #{name}"})
    # When we call the proc via the key
    result = a_rogue_object.say_my_name_is('Cliff')
    # Then the result is the returned value from the proc
    result.must_equal "my name is Cliff"
  end

  it 'should throw an ArgumentError when you call a method not mapped to any key' do
    a_rogue_object = obj(first_name:'Clifton', last_name: 'Craig')
    begin
      a_rogue_object.some_non_existant_method('uh oh...')
    rescue Exception => e
      e.must_be_instance_of ArgumentError
    end
  end
end
