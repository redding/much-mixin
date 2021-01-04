# frozen_string_literal: true

require "assert"
require "much-plugin"

module MuchPlugin
  class UnitTests < Assert::Context
    desc "MuchPlugin"
    setup do
      @block1 = proc{ 1 }
      @block2 = proc{ 2 }

      @plugin = Module.new{ include MuchPlugin }
    end
    subject{ @plugin }

    should have_imeths :much_plugin_included_detector, :much_plugin_included_blocks
    should have_imeths :plugin_included, :after_plugin_included

    should "know its included detector" do
      mixin = subject.much_plugin_included_detector
      assert_instance_of Module, mixin
      assert_same mixin, subject.much_plugin_included_detector
      exp = subject::MuchPluginIncludedDetector
      assert_same exp, subject.much_plugin_included_detector
    end

    should "have no plugin included blocks by default" do
      assert_empty subject.much_plugin_included_blocks
      assert_empty subject.much_plugin_after_included_blocks
    end

    should "append blocks" do
      subject.plugin_included(&@block1)
      subject.plugin_included(&@block2)

      assert_equal @block1, subject.much_plugin_included_blocks.first
      assert_equal @block2, subject.much_plugin_included_blocks.last
    end
  end

  class MixedInTests < UnitTests
    desc "when mixed in"
    setup do
      @receiver = Class.new do
        def self.inc_block1;   @block1_count ||= 0; @block1_count += 1; end
        def self.block1_count; @block1_count ||= 0; end
        def self.inc_block2;   @block2_count ||= 0; @block2_count += 1; end
        def self.block2_count; @block2_count ||= 0; end

        def self.do_something_count; @do_something_count ||= 0; end
      end
    end

    should "call the plugin included blocks" do
      assert_equal 0, @receiver.block1_count
      assert_equal 0, @receiver.block2_count
      assert_equal 0, @receiver.do_something_count

      @receiver.send(:include, TestPlugin)

      assert_equal 1, @receiver.block1_count
      assert_equal 1, @receiver.block2_count
      assert_equal 1, @receiver.do_something_count
    end

    should "call blocks only once no matter even if previously mixed in" do
      @receiver.send(:include, TestPlugin)

      assert_equal 1, @receiver.block1_count
      assert_equal 1, @receiver.block2_count
      assert_equal 1, @receiver.do_something_count

      @receiver.send(:include, TestPlugin)

      assert_equal 1, @receiver.block1_count
      assert_equal 1, @receiver.block2_count
      assert_equal 1, @receiver.do_something_count
    end

    should "call blocks only once even if mixed in by a 3rd party" do
      third_party = Module.new do
        def self.included(receiver)
          receiver.send(:include, TestPlugin)
        end
      end
      @receiver.send(:include, third_party)

      assert_equal 1, @receiver.block1_count
      assert_equal 1, @receiver.block2_count
      assert_equal 1, @receiver.do_something_count

      @receiver.send(:include, TestPlugin)

      assert_equal 1, @receiver.block1_count
      assert_equal 1, @receiver.block2_count
      assert_equal 1, @receiver.do_something_count

      @receiver.send(:include, third_party)

      assert_equal 1, @receiver.block1_count
      assert_equal 1, @receiver.block2_count
      assert_equal 1, @receiver.do_something_count
    end

    TestPlugin =
      Module.new do
        include MuchPlugin

        plugin_included{ inc_block1 }
        after_plugin_included{
          inc_block2
          do_something
        }

        plugin_class_methods do
          def do_something
            @do_something_count ||= 0
            @do_something_count += 1
          end
        end
      end
  end
end
