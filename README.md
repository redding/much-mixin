# MuchPlugin

An API to ensure mixin included logic (the "plugin") only runs once.

## Usage

```ruby
requre 'much-plugin'

module MyPluginMixin
  include MuchPlugin

  plugin_included do

    # ... do some stuff ...
    # - will be class eval'd in the scope of the receiver of `MyPluginMixin`
    # - will only be executed once per receiver, no matter how many times
    #   `MyPluginMixin` is included in that receiver

  end

end
```

Mix `MuchPlugin` in on other mixins that act as "plugins" to other components.  Define included hooks using `plugin_included` that will be class eval'd in the scope of the receiver.

This allows you to define multiple hooks separately and ensures each hook will only be executed once - even if your plugin is mixed in multiple times on the same receiver.

## Installation

Add this line to your application's Gemfile:

    gem 'much-plugin'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install much-plugin

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
