## Date format strings ##
PM_DEFAULT_DATE_FORMAT = "%a %b %d %Y"
PM_DEFAULT_TIME_FORMAT = "%I:%M %p"


# Convenience methods to output date strings
# in certain preferred formats
class Time
  
  # Returns MySQL-formatted date string
  # e.g., 2006-06-30
  def to_mysql_date
    strftime("%Y-%m-%d")
  end
  
  def end_of_day
    (self + 24.hours).beginning_of_day - 1.second
  end
  
  # Returns MySQL-formatted datetime string
  # e.g., 2006-06-30 13:00:01
  def to_mysql_datetime
    strftime("%Y-%m-%d %H:%M:%S")
  end
  
  # Returns english date with short month and weekday
  # e.g., Mon Jun 26 2006
  def to_human_date
    strftime(PM_DEFAULT_DATE_FORMAT)
  end
  
  # Returns 12-hour time with meridian
  # e.g., 1:00 PM
  def to_human_time
    strftime(PM_DEFAULT_TIME_FORMAT)
  end
  
  # Returns both of the above
  # e.g., Mon Jun 26 2006 1:00 PM
  def to_human_datetime
    "#{to_human_date} #{to_human_time}"
  end
  
  def end_of_quarter
    (self.beginning_of_quarter + 4.months).beginning_of_quarter - 1.second
  end
  
  def quarter
    case self.month
      when 1,2,3
        1
      when 4,5,6
        2
      when 7,8,9
        3
      when 10,11,12
        4
    end
  end
  
end