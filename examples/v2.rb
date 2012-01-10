require "rubygems"
require "bundler/setup"

require 'scamp'
require 'scamp-campfire-adapter'

Scamp.new do |bot|
  bot.adapter :campfire, Scamp::Campfire::Adapter, :subdomain => 'snipmate', 
                                                   :api_key => '5d1fe8e51d7fdf760fa9ae4edfba91211d671b37',
                                                   :rooms => [456202]

  bot.match /^ping/ do |channel, msg|
    channel.reply "pong"
  end

  bot.match /^come to the pub (?<name>\w+)/ do |channel, msg|
    channel.say "ROGER DODGER!"
    channel.reply "ON MY WAY! #{msg.name}"
    channel.paste <<-STR
      bot.match /^come to the pub (?<name>\w+)/ do |channel, msg|
        channel.say "ROGER DODGER!"
        channel.reply "ON MY WAY! #{msg.name}"
        channel.nyan
      end
    STR
    channel.play :ohyeah
    channel.nyan
  end
end
