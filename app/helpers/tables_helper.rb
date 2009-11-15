module TablesHelper
  def table_for(klass, list, *columns)
    concat(content_tag('table', :cell_spacing => 0, :border => 1) do
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
        content_tag('th', t('common.total')) + columns[1..-1].collect {|column| content_tag 'td', list.sum {|item| item.send(column) } }.join
      end
    end

    table_for(klass, list, *columns, &block)
  end
end