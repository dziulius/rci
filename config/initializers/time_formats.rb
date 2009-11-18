formats = {:short_year_month => "%Y/%m", :long_year_month => "%Y %B"}
Time::DATE_FORMATS.merge!(formats)
Date::DATE_FORMATS.merge!(formats)