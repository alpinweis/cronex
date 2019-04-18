module Cronex
  class HoursDescription < Description
    def single_item_description(expression, timezone = 'UTC')
      Cronex::Utils.format_time(expression, '0', '', timezone)
    end

    def interval_description_format(expression)
      format(resources.get('every_x') + ' ' + plural(expression, resources.get('hour'), resources.get('hours')), expression)
    end

    def between_description_format(expression)
      resources.get('between_x_and_y')
    end

    def description_format(expression)
      resources.get('at_x')
    end

    def starting_description_format(expression)
      resources.get('starting') + ' ' + description_format(expression)
    end
  end
end
