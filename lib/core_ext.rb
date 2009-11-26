class Date
  def work_days_between(date)
    startd, endd = [self, date].minmax

    # difference in days
    diff = (endd - startd).to_i

    # weeks between days
    weeks = diff / 7
    weeks += 1 if endd.wday < startd.wday
    # remove weekends between days
    diff -= weeks * 2

    # add current day to sum if it's saturday
    diff += 1 if endd.wday != 6
    # remove first day if it's sunday
    diff -= 1 if startd.wday == 0
    
    diff
  end
end
