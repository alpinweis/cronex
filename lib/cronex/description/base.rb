module Cronex
  class Description

    attr_accessor :resources, :options

    def initialize(resources, options = {})
      @resources = resources
      @options = options || {}
    end

    def special_chars
      ['/', '-', ',']
    end

    def segment_description(expression, all_values_description)
      if expression.empty? || (expression == '0' && self.class != Cronex::HoursDescription)
        desc = ''
      elsif expression == '*'
        desc = all_values_description
      elsif !Cronex::Utils.include_any?(expression, special_chars)
        desc = format(description_format(expression), single_item_description(expression))
      elsif expression.include?('/')
        segments = expression.split('/')
        desc = format(interval_description_format(segments[1]), single_item_description(segments[1]))
        # interval contains 'between' piece (e.g. 2-59/3)
        if segments[0].include?('-')
          between_segment_of_interval = segments[0]
          between_segments = between_segment_of_interval.split('-')
          between = format(
            between_description_format(between_segment_of_interval),
            single_item_description(between_segments[0]),
            single_item_description(between_segments[1]).gsub(':00', ':59'))
          desc += ', ' if !between.start_with?(', ')
          desc += between
        elsif !Cronex::Utils.include_any?(segments[0], special_chars + ['*'])
          desc += ', ' + format(starting_description_format(segments[0]), single_item_description(segments[0]))
        end
      elsif expression.include?('-')
        segments = expression.split('-')
        desc = format(
          between_description_format(expression),
          single_item_description(segments[0]),
          single_item_description(segments[1]).gsub(':00', ':59'))
      elsif expression.include?(',')
        segments = expression.split(',')
        segments = segments.map { |s| single_item_description(s) }
        desc_content = segments[0...-1].join(', ') + ' ' + resources.get('and') + ' ' + segments.last
        desc = format(description_format(expression), desc_content)
      end

      desc
    end

    def plural(expression, singular, plural)
      number = Cronex::Utils.number?(expression)
      return plural if number && number > 1
      return plural if expression.include?(',')
      singular
    end
  end
end
