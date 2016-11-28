module Cronex
  class MonthDescription < Description
    def single_item_description(expression)
      resources.get(DateTime.new(Time.now.year, Cronex::Utils.integer(expression), 1).strftime('%B').downcase)
    end

    def interval_description_format(expression)
      format(', ' + resources.get('every_x') + ' ' + plural(expression, resources.get('month'), resources.get('months')), expression)
    end

    def between_description_format(expression)
      ', ' + resources.get('between_description_format')
    end

    def description_format(expression)
      ', ' + resources.get('only_in')
    end

    def starting_description_format(expression)
      resources.get('starting') + ' ' + resources.get('in_x')
    end
  end
end
