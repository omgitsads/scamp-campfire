require 'scamp/message'

class Scamp
  module Campfire
    class Message < Scamp::Message
      def valid?(conditions={})
        room_match?(conditions[:room]) && user_match?(conditions[:user])
      end

      private
        def room_match?(condition)
          return true if condition.nil?

          if condition.is_a? Array
            return (condition.include?(room.id) || condition.include?(room.name))
          elsif condition.is_a? Fixnum
            return room.id == condition
          else
            return room.name.downcase == condition.to_s.downcase
          end
        end

        def user_match?(condition)
          return true if condition.nil?

          if condition.is_a? Array
            return (condition.include?(user.id) || condition.include?(user.name))
          elsif condition.is_a? Fixnum
            return user.id == condition
          else
            return user.name.downcase == condition.to_s.downcase
          end
        end
    end
  end
end
