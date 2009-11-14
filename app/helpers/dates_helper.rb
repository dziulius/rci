module DatesHelper
  def compact_month_select(name, now, from, to)
    date = from
    options = [].tap do |months|
      while date <= to
        months << [date.strftime("%Y-%B"), date.strftime("%Y/%m")]
        date >>= 1
      end if date and to
    end

    select_tag name, options_for_select(options, now.try(:strftime, "%Y/%m"))
  end
end