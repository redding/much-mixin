require 'much-plugin'
require 'benchmark'

module Methods; end

module MyMixin
  def self.included(receiver)
    receiver.class_eval{ include Methods }
  end
end

module MyPlugin
  include MuchPlugin

  plugin_included do
    include Methods
  end
end

Benchmark.bmbm do |x|
  x.report("MyMixin") do
    10_000.times{ Class.new{ include MyMixin } }
  end
  x.report("MyPlugin") do
    10_000.times{ Class.new{ include MyPlugin } }
  end
end
