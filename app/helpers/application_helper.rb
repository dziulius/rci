# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(text)
    content_for(:title, text)
  end

  def field_list_item(object, field, method = nil)
    value = object.send(field)
    value = value.send(method) if method

    content_tag('li') do
      content_tag('span', "#{object.class.human_attribute_name(field)}", :class => 'header') + value.to_s
    end
  end
end
