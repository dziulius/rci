module TablesHelper
  include FormattingHelper

  def table_for(klass, list, *columns, &block)
    options = columns.extract_options!

    concat(content_tag('table') do
      content = ''
      content << content_tag('tr') do
        columns.select {|column| column.to_sym }.collect do |column|
          content_tag 'th', klass.human_attribute_name(column.to_sym)
        end
      end

      content << list.collect do |item|
        content_row(item, row_values_for(item, columns, &block))
      end.join

      content << @content_for_table_bottom.to_s
      @content_for_table_bottom = ''
      content
    end)
  end

  def table_with_totals_for(klass, list, *columns, &block)
    options = columns.extract_options!
    content_for :table_bottom do
      item = ARMock.new(list)
      tds = row_values_for(item, columns, 1, t('common.total'), &block)
      content_row(item, tds, :first_header => true, :row => {:class => 'total-row'})
    end

    table_for(klass, list, *columns.push(options), &block)
  end

  def content_row(object, values, options = {})
    content_tag_for('tr', object, :row, options.delete(:row)) do
      ''.tap do |result|
        result << content_tag('th', values.shift) if options[:first_header]
        result << values.collect { |value| content_tag('td', value) }.join
      end
    end
  end

  def row_values_for(object, columns, start_with = 0, empty_value = nil)
    empty = [empty_value] * start_with
    if block_given?
      empty + yield(object)[start_with..-1]
    else
      empty + columns[start_with..-1].collect { |column| column_value_for(object, column) }
    end
  end

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
