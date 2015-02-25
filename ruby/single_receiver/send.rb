#!/usr/bin/env ruby
# encoding: utf-8

require 'active_model_serializers'


class Foo < ActiveModel::Serializer
  attr_reader :foo, :bar
  attributes :foo, :bar
  def initialize(foo, bar)
    @foo = foo
    @bar = bar
  end
end

require "bunny"

conn = Bunny.new
conn.start

channel = conn.create_channel

s = Foo.new([1,2,3], 42)

queue = channel.queue("hello")
channel.default_exchange.publish(s.to_json, :routing_key => queue.name)
puts " [x] Sent #{s.to_json}"
