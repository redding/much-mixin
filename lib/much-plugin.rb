require "much-plugin/version"

module MuchPlugin

  def self.included(receiver)
    receiver.class_eval do
      extend ClassMethods

      # install an included hook that first checks if this plugin has
      # already been installed on the reciever.  If it has not been,
      # class eval each callback on the receiver.

      def self.included(plugin_receiver)
        return if self.much_plugin_receivers.include?(plugin_receiver)

        self.much_plugin_receivers.push(plugin_receiver)
        self.much_plugin_included_hooks.each do |hook|
          plugin_receiver.class_eval(&hook)
        end
      end

    end
  end

  module ClassMethods

    def much_plugin_receivers;      @much_plugin_receivers      ||= []; end
    def much_plugin_included_hooks; @much_plugin_included_hooks ||= []; end

    def plugin_included(&hook)
      self.much_plugin_included_hooks << hook
    end

  end

end
