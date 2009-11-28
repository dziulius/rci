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
      def formatter(name, options = {}, &block)
        class_name = name.to_s.classify + 'Formatter'
        klass = Formatters.constants.include?(class_name) ? Formatters.const_get(class_name) : Class.new(AbstractFormatter)
        klass.class_eval do
          define_method(:to_s) do |subject|
            block.call(subject, self.helper, self.column, *self.args).to_s
          end

          define_method(:to_sym) { nil } if options[:no_header]
        end

        define_method(name) do |*args|
          klass.new(self, *args)
        end
      end
    end

    def self.included(object)
      object.extend(ClassMethods)
    end
  end
end
