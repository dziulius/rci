# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(text)
    content_for(:title, text)
  end

  def field_list_item(object, field)
    content_tag('li') do
      content_tag('span', "#{object.class.human_attribute_name(field)}", :class => 'header') + object.send(field).to_s
    end
  end
end
