class Scamp
  module Campfire
    class Channel
      attr_reader :adapter, :message

      def initialize adapter, msg
        @adapter = adapter
        @message = msg
      end

      def say msg
        message.room.speak msg
      end

      def reply msg
        message.room.speak "#{message.user.name}: #{msg}"
      end

      def paste text
        message.room.paste text
      end

      def play sound
        message.room.play sound.to_s
      end

      %w(crickets drama greatjob live nyan pushit rimshot secret tada tmyk trombone vuvuzela yeah).each do |sound|
        define_method sound do
          play sound
        end
      end
    end
  end
end
