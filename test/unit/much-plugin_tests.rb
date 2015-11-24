require 'assert'
require 'much-plugin'

module MuchPlugin

  class UnitTests < Assert::Context
    desc "MuchPlugin"
    setup do
      @hook1 = proc{ 1 }
      @hook2 = proc{ 2 }

      @plugin = Module.new{ include MuchPlugin }
    end
    subject{ @plugin }

    should have_imeths :much_plugin_included_hooks, :much_plugin_receivers
    should have_imeths :plugin_included

    should "have no plugin included hooks by default" do
      assert_empty subject.much_plugin_included_hooks
    end

    should "have no plugin receivers by default" do
      assert_empty subject.much_plugin_receivers
    end

    should "append hooks" do
      subject.plugin_included(&@hook1)
      subject.plugin_included(&@hook2)

      assert_equal @hook1, subject.much_plugin_included_hooks.first
      assert_equal @hook2, subject.much_plugin_included_hooks.last
    end

  end

  class MixedInTests < UnitTests
    desc "when mixed in"
    setup do
      @receiver = Class.new do
        def self.inc_hook1;   @hook1_count ||= 0; @hook1_count += 1; end
        def self.hook1_count; @hook1_count ||= 0; end
        def self.inc_hook2;   @hook2_count ||= 0; @hook2_count += 1; end
        def self.hook2_count; @hook2_count ||= 0; end
      end
    end

    should "call the plugin included hooks" do
      assert_equal 0, @receiver.hook1_count
      assert_equal 0, @receiver.hook2_count

      @receiver.send(:include, TestPlugin)

      assert_equal 1, @receiver.hook1_count
      assert_equal 1, @receiver.hook2_count
    end

    should "call hooks only once no matter even if previously mixed in" do
      @receiver.send(:include, TestPlugin)

      assert_equal 1, @receiver.hook1_count
      assert_equal 1, @receiver.hook2_count

      @receiver.send(:include, TestPlugin)

      assert_equal 1, @receiver.hook1_count
      assert_equal 1, @receiver.hook2_count
    end

    should "call hooks only once even if mixed in by a 3rd party" do
      third_party = Module.new do
        def self.included(receiver)
          receiver.send(:include, TestPlugin)
        end
      end
      @receiver.send(:include, third_party)

      assert_equal 1, @receiver.hook1_count
      assert_equal 1, @receiver.hook2_count

      @receiver.send(:include, TestPlugin)

      assert_equal 1, @receiver.hook1_count
      assert_equal 1, @receiver.hook2_count

      @receiver.send(:include, third_party)

      assert_equal 1, @receiver.hook1_count
      assert_equal 1, @receiver.hook2_count
    end

    TestPlugin = Module.new do
      include MuchPlugin

      plugin_included{ inc_hook1 }
      plugin_included{ inc_hook2 }
    end

  end

end
