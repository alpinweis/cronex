module Cronex

  DAYS   = Date::ABBR_DAYNAMES.map(&:upcase)
  MONTHS = Date::ABBR_MONTHNAMES[1..-1].map(&:upcase)

  DAY_NUM   = Hash[DAYS.zip(0..(DAYS.size - 1))]
  MONTH_NUM = Hash[MONTHS.zip(1..MONTHS.size)]

  # abbr dayname => long dayname
  DAY_DAY = Hash[DAYS.zip(Date::DAYNAMES.map(&:upcase))]

  class Parser
    attr_accessor :expression, :options

    def initialize(expression, options = {})
      @expression = expression
      @options = options
    end

    def parse(exp = expression)
      parsed_parts = Array.new(7, '')

      fail ExpressionError, 'Error: Expression null or empty' unless Cronex::Utils.present?(exp)
      parts = sanitize(exp).split(' ')
      len = parts.size

      if len < 5
        fail ExpressionError, "Error: Expression only has #{len} parts. At least 5 parts are required"
      elsif len == 5
        fail ExpressionError, "Error: Expression only has 5 parts. For 'strict_quartz' option, at least 6 parts are required" if options[:strict_quartz]
        # 5 part CRON so shift array past seconds element
        parsed_parts.insert(1, *parts)
      elsif len == 6
        # if last element ends with 4 digits, a year element has been supplied and no seconds element
        if parts.last.match(/\d{4}$/)
          parsed_parts.insert(1, *parts)
        else
          parsed_parts.insert(0, *parts)
        end
      elsif len == 7
        parsed_parts = parts
      else
        fail ExpressionError, "Error: Expression has too many parts (#{len}). Expression must not have more than 7 parts"
      end

      parsed_parts = parsed_parts.take(7) # ; p parsed_parts
      normalize(parsed_parts, options)
    end

    def sanitize(exp = expression)
      # remove extra spaces
      exp = exp.strip.gsub(/\s+/, ' ').upcase
      # convert non-standard day names (e.g. THURS, TUES) to 3-letter names
      DAY_DAY.each do |day, longname|
        matched = exp.scan(/\W*(#{day}\w*)/).flatten.uniq
        matched.each { |m| exp.gsub!(m, day) if longname.include?(m) }
      end
      exp
    end

    def normalize(expression_parts, options = {})
      parts = expression_parts.dup

      # convert ? to * only for DOM and DOW
      parts[3].gsub!('?', '*')
      parts[5].gsub!('?', '*')

      # Convert 0/, 1/ to */
      parts[0].gsub!('0/', '*/') if parts[0].start_with?('0/') # seconds
      parts[1].gsub!('0/', '*/') if parts[1].start_with?('0/') # minutes
      parts[2].gsub!('0/', '*/') if parts[2].start_with?('0/') # hours
      parts[3].gsub!('1/', '*/') if parts[3].start_with?('1/') # day of month
      parts[4].gsub!('1/', '*/') if parts[4].start_with?('1/') # month
      parts[5].gsub!('1/', '*/') if parts[5].start_with?('1/') # day of week

      # convert */1 to *
      parts = parts.map { |part| part == '*/1' ? '*' : part }

      # convert SUN-SAT format to 0-6 format
      DAY_NUM.each { |day, i| i += 1 if !options[:zero_based_dow]; parts[5].gsub!(day, i.to_s) }

      # convert JAN-DEC format to 1-12 format
      MONTH_NUM.each { |month, i| parts[4].gsub!(month, i.to_s) }

      # convert 0 second to (empty)
      parts[0] = '' if parts[0] == '0'

      # convert 0 DOW to 7 so that 0 for Sunday in zeroBasedDayOfWeek is valid
      parts[5] = '7' if (!options || options[:zero_based_dow]) && parts[5] == '0' # ; p parts
      parts
    end
  end
end
