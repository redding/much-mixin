require "much-plugin/version"

module MuchPlugin
  def self.included(receiver)
    receiver.class_eval{ extend ClassMethods }
  end

  module ClassMethods
    # install an included block that first checks if this plugin's receiver mixin
    # has already been included.  If it has not been, include the receiver mixin
    # and run all of the `plugin_included` blocks
    def included(plugin_receiver)
      return if plugin_receiver.include?(self.much_plugin_included_detector)
      plugin_receiver.send(:include, self.much_plugin_included_detector)

      self.much_plugin_included_blocks.each do |block|
        plugin_receiver.class_eval(&block)
      end

      self.much_plugin_class_method_blocks.each do |block|
        self.much_plugin_class_methods_module.class_eval(&block)
      end
      plugin_receiver.send(:extend, self.much_plugin_class_methods_module)

      self.much_plugin_instance_method_blocks.each do |block|
        self.much_plugin_instance_methods_module.class_eval(&block)
      end
      plugin_receiver.send(:include, self.much_plugin_instance_methods_module)

      self.much_plugin_after_included_blocks.each do |block|
        plugin_receiver.class_eval(&block)
      end
    end

    # the included detector is an empty module that is only used to detect if
    # the plugin has been included or not, it doesn't add any behavior or
    # methods to the object receiving the plugin; we use `const_set` to name the
    # module so if its seen in the ancestors it doesn't look like some random
    # module and it can be tracked back to much-plugin
    def much_plugin_included_detector
      @much_plugin_included_detector ||= Module.new.tap do |m|
        self.const_set("MuchPluginIncludedDetector", m)
      end
    end

    def much_plugin_class_methods_module
      @much_plugin_class_methods_module ||= Module.new.tap do |m|
        self.const_set("MuchPluginClassMethods", m)
      end
    end

    def much_plugin_instance_methods_module
      @much_plugin_instance_methods_module ||= Module.new.tap do |m|
        self.const_set("MuchPluginInstanceMethods", m)
      end
    end

    def much_plugin_included_blocks
      @much_plugin_included_blocks ||= []
    end

    def much_plugin_after_included_blocks
      @much_plugin_after_included_blocks ||= []
    end

    def much_plugin_class_method_blocks
      @much_plugin_class_method_blocks ||= []
    end

    def much_plugin_instance_method_blocks
      @much_plugin_instance_method_blocks ||= []
    end

    def plugin_included(&block)
      self.much_plugin_included_blocks << block
    end

    def after_plugin_included(&block)
      self.much_plugin_after_included_blocks << block
    end

    def plugin_class_methods(&block)
      self.much_plugin_class_method_blocks << block
    end

    def plugin_instance_methods(&block)
      self.much_plugin_instance_method_blocks << block
    end
  end
end
