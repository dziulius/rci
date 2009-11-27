module TablesHelper
  def table_for(klass, list, *columns)
    concat(content_tag('table') do
      content_tag('tr') do
        columns.collect do |column|
          content_tag 'th', klass.human_attribute_name(column)
        end
      end + list.collect do |item|
        content_tag('tr') do
          tds = block_given? ? yield(item) : columns.collect {|column| item.send(column) }
          tds.collect {|value| content_tag 'td', value }
        end
      end.join + @content_for_table_bottom.to_s
    end)
  end

  def table_with_totals_for(klass, list, *columns, &block)
    content_for :table_bottom do
      content_tag 'tr' do
        values = if block_given?
          yield(ARMock.new list)
        else
          [nil, *columns[1..-1].collect {|column| list.sum(&column) }]
        end
        values[0] = t('common.total')

        content_tag('th', values.shift) + values.collect do |value|
          content_tag('td', value)
        end.join
      end
    end

    table_for(klass, list, *columns, &block)
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
