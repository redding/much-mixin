# frozen_string_literal: true

require "assert"
require "much-plugin"

module MuchPlugin
  class SystemTests < Assert::Context
    desc "MuchPlugin"
    setup do
      @my_class = MyClass.new
    end
    subject{ @my_class }

    should "class eval the plugin included block on MyClass" do
      assert_equal "another", subject.another
    end

    should "add the plugin class methods to MyClass" do
      assert_equal "a-class-method", MyClass.a_class_method
    end

    should "add the plugin instance methods to MyClass" do
      assert_equal "an-instance-method", subject.an_instance_method
    end

    module AnotherMixin
      def another
        "another"
      end
    end

    module MyPlugin
      include MuchPlugin

      plugin_included do
        include AnotherMixin
      end

      plugin_class_methods do
        def a_class_method
          "a-class-method"
        end
      end

      plugin_instance_methods do
        def an_instance_method
          "an-instance-method"
        end
      end
    end

    class MyClass
      include MyPlugin
    end
  end
end
