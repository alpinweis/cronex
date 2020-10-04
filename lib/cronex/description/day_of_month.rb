module Cronex
  class DayOfMonthDescription < Description
    def single_item_description(expression)
      expression == 'L' ? resources.get('last_day') : expression
    end

    def interval_description_format(expression)
      ', ' + resources.get('every_x') + ' ' + plural(expression, resources.get('day'), resources.get('days'))
    end

    def between_description_format(expression)
      ', ' + resources.get('between_days_of_the_month')
    end

    def description_format(expression)
      ', ' + resources.get('on_day_of_the_month')
    end

    def starting_description_format(expression)
      resources.get('starting') + ' ' + resources.get('on_day_of_the_month')
    end
  end
end
