module TablesHelper
  include FormattingHelper

  def table_for(klass, list, *columns, &block)
    options = columns.extract_options!
    if with_form = options.delete(:with_form)
      with_form = [] if with_form == true
      with_form = [*with_form]
    end

    concat(content_tag('table') do
      content = ''
      content << content_tag('tr') do
        columns.select {|column| column.to_sym }.collect do |column|
          content_tag 'th', klass.human_attribute_name(column.to_sym)
        end
      end

      content << list.collect do |item|
        row = content_row(row_values_for(item, columns, &block))
        with_form ? semantic_form_for(with_form + [item]) { concat(row) } : row
      end.join

      content << @content_for_table_bottom.to_s
      @content_for_table_bottom = ''
      content
    end)
  end

  def table_with_totals_for(klass, list, *columns, &block)
    content_for :table_bottom do
      tds = row_values_for(ARMock.new(list), columns, 1, t('common.total'), &block)
      content_row(tds, :first_header => true)
    end

    table_for(klass, list, *columns, &block)
  end

  protected

  def row_values_for(object, columns, start_with = 0, empty_value = nil)
    empty = [empty_value] * start_with
    if block_given?
      empty + yield(object)[start_with..-1]
    else
      empty + columns[start_with..-1].collect { |column| column_value_for(object, column) }
    end
  end

  def content_row(values, options = {})
    content_tag('tr') do
      ''.tap do |result|
        result << content_tag('th', values.shift) if options[:first_header]
        result << values.collect { |value| content_tag('td', value) }.join
      end
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
