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

    def format_time(hour_expression, minute_expression, second_expression = '')
      hour = integer(hour_expression)
      period = hour >= 12 ? 'PM' : 'AM'
      hour -= 12 if hour > 12
      minute = integer(minute_expression)
      minute = format('%02d', minute)
      second = ''
      if present?(second_expression)
        second = integer(second_expression)
        second = ':' + format('%02d', second)
      end
      format('%s:%s%s %s', hour, minute, second, period)
    end
  end
end
