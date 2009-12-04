module DatesHelper
  def compact_month_select(name, now, from, to, tag_options = {})
    date = from
    options = [].tap do |months|
      while date <= to
        months << [l(date, :format => :long_year_month), date.to_s(:short_year_month)]
        date >>= 1
      end if date and to
    end

    select_tag name, options_for_select(options, now.try(:to_s, :short_year_month)), tag_options
  end
end
