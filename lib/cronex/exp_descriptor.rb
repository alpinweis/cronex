require 'unicode'

module Cronex

  CASINGS  = [:title, :sentence, :lower]
  SEGMENTS = [:seconds, :minutes, :hours, :dayofmonth, :month, :dayofweek, :year, :timeofday, :full]

  SPECIAL_CHARS = ['/', '-', ',', '*']

  CRONEX_OPTS = {
    casing: :sentence,
    verbose: false,
    zero_based_dow: true,
    use_24_hour_time_format: false,
    throw_exception_on_parse_error: true,
    strict_quartz: false,
    locale: nil,
    timezone: nil
  }

  class ExpressionDescriptor
    attr_accessor :expression, :expression_parts, :options, :parsed, :resources, :timezone

    def initialize(expression, options = {})
      @expression = expression
      @options = CRONEX_OPTS.merge(options)
      @expression_parts = []
      @parsed = false
      @resources = Cronex::Resource.new(@options[:locale])
      @timezone = @options[:timezone] || 'UTC'
    end

    def to_hash
      Hash[SEGMENTS.take(7).zip(expression_parts)]
    end

    def description(type = :full)
      desc = ''

      begin
        unless parsed
          parser = Parser.new(expression, options)
          @expression_parts = parser.parse
          @parsed = true
        end

        desc = case type
        when :full
          full_description(expression_parts)
        when :timeofday
          time_of_day_description(expression_parts)
        when :hours
          hours_description(expression_parts)
        when :minutes
          minutes_description(expression_parts)
        when :seconds
          seconds_description(expression_parts)
        when :dayofmonth
          day_of_month_description(expression_parts)
        when :month
          month_description(expression_parts)
        when :dayofweek
          day_of_week_description(expression_parts)
        when :year
          year_description(expression_parts)
        else
          seconds_description(expression_parts)
        end
      rescue StandardError => e
        if options[:throw_exception_on_parse_error]
          raise e
        else
          desc = e.message
          puts "Exception parsing expression: #{e}"
        end
      end

      desc
    end

    def seconds_description(expression_parts)
      desc = SecondsDescription.new(resources)
      desc.segment_description(expression_parts[0], resources.get('every_second'))
    end

    def minutes_description(expression_parts)
      desc = MinutesDescription.new(resources)
      desc.segment_description(expression_parts[1], resources.get('every_minute'))
    end

    def hours_description(expression_parts)
      desc = HoursDescription.new(resources)
      desc.segment_description(expression_parts[2], resources.get('every_hour'))
    end

    def year_description(expression_parts)
      desc = YearDescription.new(resources, options)
      desc.segment_description(expression_parts[6], ', ' + resources.get('every_year'))
    end

    def day_of_week_description(expression_parts)
      desc = DayOfWeekDescription.new(resources, options)
      desc.segment_description(expression_parts[5], ', ' + resources.get('every_day'))
    end

    def month_description(expression_parts)
      desc = MonthDescription.new(resources)
      desc.segment_description(expression_parts[4], '')
    end

    def day_of_month_description(expression_parts)
      exp = expression_parts[3].gsub('?', '*')
      if exp == 'L'
        description = ', ' + resources.get('on_the_last_day_of_the_month')
      elsif exp == 'LW' || exp == 'WL'
        description = ', ' + resources.get('on_the_last_weekday_of_the_month')
      else
        match = exp.match(/(\d{1,2}W)|(W\d{1,2})/)
        if match
          day_num = Cronex::Utils.integer(match[0].gsub('W', ''))
          day_str = day_num == 1 ? resources.get('first_weekday') : format(resources.get('weekday_nearest_day'), day_num)
          description = format(', ' + resources.get('on_the_of_the_month'), day_str)
        else
          desc = DayOfMonthDescription.new(resources)
          description = desc.segment_description(exp, ', ' + resources.get('every_day'))
        end
      end
      description
    end

    def time_of_day_description(expression_parts)
      sec_exp, min_exp, hour_exp = expression_parts
      description = ''
      if [sec_exp, min_exp, hour_exp].all? { |exp| !Cronex::Utils.include_any?(exp, SPECIAL_CHARS) }
        # specific time of day (i.e. 10 14)
        description += resources.get('at') + ' ' + Cronex::Utils.format_time(hour_exp, min_exp, sec_exp, timezone)
      elsif min_exp.include?('-') && !min_exp.include?('/') && !min_exp.include?(',') && !Cronex::Utils.include_any?(hour_exp, SPECIAL_CHARS)
        # Minute range in single hour (e.g. 0-10 11)
        min_parts = min_exp.split('-')
        description += format(
          resources.get('every_minute_between'),
          Cronex::Utils.format_time(hour_exp, min_parts[0], '', timezone),
          Cronex::Utils.format_time(hour_exp, min_parts[1], '', timezone))
      elsif hour_exp.include?(',') && !Cronex::Utils.include_any?(min_exp, SPECIAL_CHARS)
        # Hours list with single minute (e.g. 30 6,14,16)
        hour_parts = hour_exp.split(',')
        description += resources.get('at')
        h_parts = hour_parts.map { |part| ' ' + Cronex::Utils.format_time(part, min_exp, '', timezone) }
        description += h_parts[0...-1].join(',') + ' ' + resources.get('and') + h_parts.last
      else
        sec_desc = seconds_description(expression_parts)
        min_desc = minutes_description(expression_parts)
        hour_desc = hours_description(expression_parts)
        description += sec_desc
        description += ', ' if description.size > 0 && !min_desc.empty?
        description += min_desc
        description += ', ' if description.size > 0 && !hour_desc.empty?
        description += hour_desc
      end
      description
    end

    def full_description(expression_parts)
      time_segment = time_of_day_description(expression_parts)
      dom_desc = day_of_month_description(expression_parts)
      month_desc = month_description(expression_parts)
      dow_desc = day_of_week_description(expression_parts)
      year_desc = year_description(expression_parts)
      description = format('%s%s%s%s%s', time_segment, dom_desc, dow_desc, month_desc, year_desc)
      description = transform_verbosity(description, options[:verbose])
      description = transform_case(description, options[:casing])
      description
    end

    def transform_case(desc, case_type = :lower)
      case case_type
      when :sentence
        desc.sub(/\b[[:word:]]/u) { |s| Unicode.upcase(s) }
      when :title
        desc.gsub(/\b[[:word:]]/u) { |s| Unicode.upcase(s) }
      else
        Unicode.downcase(desc)
      end
    end

    def transform_verbosity(desc, verbose = false)
      return desc if verbose
      parts = %w(every_minute every_hour every_day)
      parts.each { |part| desc.gsub!(resources.get(part.gsub('_', '_1_')), resources.get(part)) }
      parts.each { |part| desc.gsub!(', ' + resources.get(part), '') }
      desc
    end
  end
end
