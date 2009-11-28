module Formatters
  class AbstractFormatter
    attr_reader :helper, :column, :args
    
    def initialize(helper, column, *args)
      @column = column
      @helper = helper
      @args = args
    end

    def to_sym
      @column
    end
  end

  module Helper
    module ClassMethods
      def formatter(name, &block)
        class_name = name.to_s.classify + 'Formatter'
        Formatters.const_set(class_name, Class.new(AbstractFormatter) do
          define_method(:to_s) do |subject|
            block.call(subject, self.helper, self.column, *self.args).to_s
          end
        end)

        define_method(name) do |*args|
          Formatters.const_get(class_name).new(self, *args)
        end
      end
    end

    def self.included(object)
      object.extend(ClassMethods)
    end
  end
end
