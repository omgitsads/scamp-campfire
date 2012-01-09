require "tinder"

require "scamp/adapter"
require "scamp/message"

require "scamp-campfire-adapter/version"

class Scamp
  module Campfire
    class Adapter
      include Scamp::Adapter

      def connect!
        rooms.each do |room|
          room.listen do |message|
            msg = Scamp::Message.new self, :body => message[:body],
                                           :room => room,
                                           :user => message[:user],
                                           :type => message[:type]
            push msg
          end
        end
      end

      private
        def rooms
          @opts[:rooms].map do |room|
            if room.is_a? String
              connection.find_room_by_name room
            else
              connection.find_room_by_id room
            end
          end
        end

        def connection
          @connection ||= Tinder::Campfire.new @opts[:subdomain], :token => @opts[:api_key]
        end
    end
  end
end
