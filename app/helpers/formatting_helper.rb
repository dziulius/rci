module FormattingHelper
  require 'abstract_formatter'
  include Formatters::Helper

  formatter(:linked) do |subject, helper, column|
    helper.link_to(subject.send(column), subject)
  end

  formatter(:linked_to) do |subject, helper, column|
    subject = subject.send(column)
    helper.link_to subject, subject
  end

  formatter(:tail_link, :no_header => true) do |subject, helper, text, *url|
    html_options = url.extract_options!
    url += [subject]
    begin
      if html_options[:ajax]
        helper.link_to_remote text, html_options.merge(:url => url)
      else
        helper.link_to text, url, html_options
      end
    rescue NoMethodError
      nil
    end
  end

  formatter(:with_percent) do |subject, helper, column, total_column|
    number, total = subject.send(column), subject.send(total_column)
    "#{number} (#{helper.number_to_percentage(number.to_f / total * 100)})"
  end

  formatter(:random) do |subject, helper, column, range|
    rand(range.last - range.first) + range.first
  end
end
