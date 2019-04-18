require 'tzinfo'

module Cronex
  module Utils
    extend self

    def present?(str)
      !str.to_s.strip.empty?
    end

    def include_any?(str, chars)
      chars.any? { |char| str.include?(char) }
    end

    def number?(str)
      integer(str) rescue nil
    end

    def integer(str)
      # strip leading zeros in numbers to prevent '08', '09'
      # from being treated as invalid octals
      Integer(str.sub(/^0*(\d+)/, '\1'))
    end

    def day_of_week_name(number)
      Date::DAYNAMES[number.to_i % 7]
    end

    def format_minutes(minute_expression)
      if minute_expression.include?(',')
        minute_expression.split(',').map { |m| format('%02d', integer(m)) }.join(',')
      else
        format('%02d', integer(minute_expression))
      end
    end

    def format_time(hour_expression, minute_expression, second_expression = '', timezone = 'UTC')
      hour = integer(hour_expression)
      minute = integer(minute_expression)
      second = second_expression.to_s.empty? ? 0 : integer(second_expression)
      tz = TZInfo::Timezone.get(timezone)
      time = tz.utc_to_local(Date.today.to_time + hour * 60 * 60 + minute * 60 + second)
      format = present?(second_expression) ? '%l:%M:%S %p' : '%l:%M %p'
      time.strftime(format).lstrip
    end
  end
end
