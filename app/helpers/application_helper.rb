# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(text)
    content_for(:title, text)
  end

  def field_list_item(object, *fields)
    value = fields.inject(object) {|val, field| val.try(field) }

    content_tag('li') do
      content_tag('span', "#{object.class.human_attribute_name(fields[-2] || fields[-1])}", :class => 'header') + value.to_s
    end if value
  end

  def tabs
    content_tag('div', :id => 'tabs') {
      content_tag('ul') do
        @tabs.collect do |tab|
          content_tag('li', link_to(t(tab, :scope => 'tabs'), :tab => tab, :format => 'js'))
        end
      end
    } + javascript_tag("tabs('%s')" % t('tabs.loading'))
  end
end
