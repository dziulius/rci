module TablesHelper
  include FormattingHelper

  def table_for(klass, list, *columns)
    concat(content_tag('table') do
      content = ''
      content << content_tag('tr') do
        columns.select {|column| column.to_sym }.collect do |column|
          content_tag 'th', klass.human_attribute_name(column.to_sym)
        end
      end

      content << list.collect do |item|
        content_tag('tr') do
          tds = if block_given?
            yield(item)
          else
            columns.collect { |column| column_value_for(item, column) }
          end
          tds.collect {|value| content_tag 'td', value }
        end
      end.join

      content << @content_for_table_bottom.to_s
      @content_for_table_bottom = ''
      content
    end)
  end

  def table_with_totals_for(klass, list, *columns, &block)
    content_for :table_bottom do
      content_tag 'tr' do
        object = ARMock.new list
        values = if block_given?
          yield(object)
        else
          [nil, *columns[1..-1].collect { |column| column_value_for(object, column) }]
        end
        values[0] = t('common.total')

        content_tag('th', values.shift) + values.collect do |value|
          content_tag('td', value)
        end.join
      end
    end

    table_for(klass, list, *columns, &block)
  end

  protected

  def column_value_for(object, column)
    column.is_a?(Symbol) ? object.send(column) : column.to_s(object)
  end

  class ARMock
    undef_method :id

    def initialize(list)
      @list = list
    end

    def method_missing(column)
      @list.sum {|item| item.send(column) }
    end
  end
end
