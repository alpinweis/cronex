module Cronex
  class MinutesDescription < Description
    def single_item_description(expression)
      Cronex::Utils.format_minutes(expression)
    end

    def interval_description_format(expression)
      format(resources.get('every_x') + ' ' + min_plural(expression), expression)
    end

    def between_description_format(expression)
      resources.get('minutes_through_past_the_hour')
    end

    def description_format(expression)
      expression == '0' ? '' : [resources.get('at_x'), min_plural(expression), resources.get('past_the_hour')].join(' ')
    end

    def starting_description_format(expression)
      resources.get('starting') + ' ' + description_format(expression)
    end

    def min_plural(expression)
      plural(expression, resources.get('minute'), resources.get('minutes'))
    end
  end
end
