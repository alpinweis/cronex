module Cronex
  class SecondsDescription < Description
    def single_item_description(expression)
      expression
    end

    def interval_description_format(expression)
      format(resources.get('every_x_seconds'), expression)
    end

    def between_description_format(expression)
      resources.get('seconds_through_past_the_minute')
    end

    def description_format(expression)
      resources.get('at_x_seconds_past_the_minute')
    end

    def starting_description_format(expression)
      resources.get('starting') + ' ' + description_format(expression)
    end
  end
end
