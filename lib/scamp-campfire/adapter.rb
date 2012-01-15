class Scamp
  module Campfire
    class Adapter < Scamp::Adapter
      def connect!
        rooms.each do |room|
          room.listen do |message|
            msg = Scamp::Campfire::Message.new self, :body => message[:body],
                                                     :room => room,
                                                     :user => message[:user],
                                                     :type => message[:type]

            channel = Scamp::Campfire::Channel.new self, msg

            push [channel, msg]
          end
        end
      end

      def required_prefix
        @opts[:required_prefix]
      end

      def ignore_self?
        @opts[:ignore_self] || false
      end

      def user
        connection.me
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
