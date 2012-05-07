require 'date'

def date_reminder(day, month, year, message, remind_time = nil)
  today = Date.today
  if remind_time
    remind_date = today + remind_time
    if remind_date.mday == day && remind_date.month == month && remind_date.year == year
      puts "#{message} in #{remind_time} day/s"
    end
  end
  puts message if today.mday == day && today.month == month && today.year == year
end

def year_reminder(day, month, message, remind_time = nil)
  today = Date.today
  if remind_time
    remind_date = today + remind_time
    if remind_date.mday == day && remind_date.month == month
      puts "#{message} in #{remind_time} day/s"
    end
  end
  puts message if today.mday == day && today.month == month
end

def month_reminder(day, message, remind_time = nil)
  today = Date.today
  puts message if today.month == month
end

def week_reminder(day_of_week, message, remind_time = nil)
  today = Date.today
  puts message if today.wday == day_of_week
end

year_reminder(18,8,"Test's birthday",1)
