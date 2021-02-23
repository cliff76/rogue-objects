# frozen_string_literal: true

require_relative "rogue/version"
require 'ostruct'

module Rogue
  class Error < StandardError; end
  #Special class that allows dot notation access to member values
  # eg. myobj = CustomStruct.new
  # eg. myobj.with_properties(id: 1, title: 'First Screen', click_action: 'click_to_web')
  # with this you can do:
  # myobj.title and get 'First Screen'
  class RogueObject < OpenStruct
    def with_properties( args = Hash.new )
      @methods = {}
      args.each do |name,initial_value|
        if initial_value.is_a?(Proc)
          @methods[name] = initial_value
        else
          new_ostruct_member name
          send "#{name}=" , initial_value
        end
      end
      self
    end
    def method_missing(m, *args, &block)
      raise ArgumentError.new "Method :#{m} not defined with arguments #{args}" unless @methods.include?(m)
      @methods[m].call(*args) if @methods.include?(m)
    end
  end

  # A special auxillary method that lets you create instances of CustomStruct with properties
  # directly with a one liner
  # eg. myobj = obj(id: 1, title: 'First Screen', click_action: 'click_to_web')
  # with this you can do:
  # myobj.title and get 'First Screen'
  def obj(properties = Hash.new)
    RogueObject.new.with_properties(properties)
  end

end
