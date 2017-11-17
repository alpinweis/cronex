module Cronex
  class DayOfWeekDescription < Description
    def single_item_description(expression)
      exp = expression
      if expression.include?('#')
        exp = expression.partition('#').first
      elsif expression.include?('L')
        exp = exp.gsub('L', '')
      end

      if Cronex::Utils.number?(exp)
        dow_num = Cronex::Utils.integer(exp)
        zero_based_dow = options[:zero_based_dow]
        invalid_dow = !zero_based_dow && dow_num <= 1
        if invalid_dow || (zero_based_dow && dow_num == 0)
          return resources.get(Cronex::Utils.day_of_week_name(0).downcase) # or 7 as in java DateTime().withDayOfWeek(7) for Sunday
        elsif !zero_based_dow
          dow_num -= 1
        end
        return resources.get(Cronex::Utils.day_of_week_name(dow_num).downcase)
      else
        return Date.parse(exp.capitalize).strftime('%A')
      end
    end

    def interval_description_format(expression)
      format(', ' + resources.get('interval_description_format'), expression)
    end

    def between_description_format(expression)
      ', ' + resources.get('between_weekday_description_format')
    end

    def description_format(expression)
      if expression.include?('#')
        dow_num = expression.split('#').last
        days = Hash[%w(1 2 3 4 5).zip(%w(first second third fourth fifth))]
        dow_desc = days[dow_num]
        dow_desc = dow_desc ? resources.get(dow_desc) : ''
        ', ' + resources.get('on_the_day_of_the_month').gsub(/{{.*}}/, dow_desc)
      elsif expression.include?('L')
        ', ' + resources.get('on_the_last_of_the_month')
      else
        ', ' + resources.get('only_on')
      end
    end

    def starting_description_format(expression)
      resources.get('starting') + ' ' + resources.get('on_x')
    end
  end
end
