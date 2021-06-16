module Ebtchef

  class DateCalculation
    def self.days_to_most_recent_wednesday(day = Time.now)
      case day.wday
        when 2
          days_to_wednesday = 6
        when 1
          days_to_wednesday = 5
        when 0
          days_to_wednesday = 4
        else
          days_to_wednesday = day.wday - 3
      end
    end
    
    def self.days_to_next_wednesday(day = Time.now)
      7 - days_to_most_recent_wednesday(day)
    end
  end
  
end