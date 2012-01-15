require 'spec_helper'

describe Scamp::Campfire::Message do
  let(:adapter) { Scamp::Campfire::Adapter.new stub }
  let(:room) { stub(:id => 1234, :name => "Room") }
  let(:user) { stub(:id => 1234, :name => "User") }
  let(:body) { "Hello" }
  let(:message) { Scamp::Campfire::Message.new(adapter, :body => body, :room => room, :user => user) }

  describe ".matches?" do
    describe "with string trigger" do
      it "matches with valid trigger" do
        message.matches?("Hello").should be_true
      end

      it "does not match with invalid trigger" do
        message.matches?("Goodbye").should be_false
      end
    end

    describe "with regex trigger" do
      it "matches with valid trigger" do
        message.matches?(/^Hello/).should be_true
      end

      it "does not match with invalid trigger" do
        message.matches?(/^Goodbye/).should be_false
      end
    end

    describe "required prefix" do
      describe "with no prefix" do
        it "matches" do
          message.matches?(/^Hello/).should be_true
        end
      end

      describe "with string prefix" do
        let(:adapter) { Scamp::Campfire::Adapter.new stub, :required_prefix => "User: " }

        context "with valid message" do
          let(:body) { "User: Hello" }

          it "matches" do
            message.matches?(/^Hello/).should be_true
          end
        end

        context "with invalid message" do
          let(:body) { "Another User: Hello" }

          it "does not match" do
            message.matches?(/^Hello/).should be_false
          end
        end
      end

      describe "with regex prefix" do
        let(:adapter) { Scamp::Campfire::Adapter.new stub, :required_prefix => /^User: / }

        context "with valid prefix" do
          let(:body) { "User: Hello" }

          it "matches" do
            message.matches?(/^Hello/).should be_true
          end
        end

        context "with invalid prefix" do
          let(:body) { "Another User: Hello" }

          it "does not match" do
            message.matches?(/^Hello/).should be_false
          end
        end
      end
    end
  end

  describe ".valid?" do
    describe "ignore messages from self" do
      let(:adapter) { Scamp::Campfire::Adapter.new stub, :ignore_self => true }

      context "message from self" do
        before do
          adapter.stub(:user).and_return(stub(:id => 1234, :name => "User"))
        end

        it "is not valid" do
          message.valid?().should be_false
        end
      end

      context "message from another user" do
        before do
          adapter.stub(:user).and_return(stub(:id => 5678, :name => "Another User"))
        end

        it "is valid" do
          message.valid?().should be_true
        end
      end
    end


    describe "matching rooms" do
      describe "on no room condition" do
        it "is valid" do
          message.valid?().should be_true
        end
      end

      describe "on room id" do
        context "with valid room" do
          it "is valid with a fixnum" do
            message.valid?(:room => 1234).should be_true
          end

          it "is valid with an array" do
            message.valid?(:room => [1234]).should be_true
          end

          it "is valid with an array of multiple rooms" do
            message.valid?(:room => [1234, 5678]).should be_true
          end
        end

        context "with invalid room" do
          it "is invalid with a fixnum" do
            message.valid?(:room => 5678).should be_false
          end

          it "is invalid with an array of fixnums" do
            message.valid?(:room => [5678, 9012]).should be_false
          end
        end
      end

      describe "on room name" do
        context "with valid room" do
          it "is valid with a string" do
            message.valid?(:room => "Room").should be_true
          end

          it "is valid with a symbol" do
            message.valid?(:room => :room).should be_true
          end

          it "is valid with a string array" do
            message.valid?(:room => ["Room"]).should be_true
          end

          it "is valid with a string array of multiple rooms" do
            message.valid?(:room => ["Room", "Another"]).should be_true
          end
        end

        context "with invalid room" do
          it "is invalid with a string" do
            message.valid?(:room => "Another").should be_false
          end

          it "is invalid with an array of strings" do
            message.valid?(:room => ["Another", "One More"]).should be_false
          end
        end
      end
    end

    describe "matching users" do
      context "on no user condition" do
        it "is valid" do
          message.should be_valid
        end
      end

      context "on user id" do
        context "with valid user" do
          it "is valid with a fixnum" do
            message.valid?(:user => 1234).should be_true
          end

          it "is valid with a fixnum array" do
            message.valid?(:user => [1234]).should be_true
          end

          it "is valid with a fixnum array of multiple users" do
            message.valid?(:user => [1234, 5678]).should be_true
          end
        end

        context "with invalid user" do
          it "is invalid with fixnum" do
            message.valid?(:user => 5678).should be_false
          end

          it "is invalid with a fixnum array" do
            message.valid?(:user => [5678]).should be_false
          end

          it "is invalid with a fixnum array of multiple users" do
            message.valid?(:user => [5678, 9012]).should be_false
          end
        end
      end

      context "on user user name" do
        context "with valid user" do
          it "is valid with string" do
            message.valid?(:user => "User").should be_true
          end

          it "is valid with a string array" do
            message.valid?(:user => ["User"]).should be_true
          end

          it "is valid with a string array of multiple users" do
            message.valid?(:user => ["User", "Two"]).should be_true
          end
        end

        context "with invalid user" do
          it "is invalid with string" do
            message.valid?(:user => "Two").should be_false
          end

          it "is invalid with a string array" do
            message.valid?(:user => ["Two"]).should be_false
          end

          it "is invalid with a string array of multiple users" do
            message.valid?(:user => ["Two", "Three"]).should be_false
          end
        end
      end
    end
  end
end
