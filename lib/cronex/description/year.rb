module Cronex
  class YearDescription < Description
    def single_item_description(expression)
      DateTime.new(Cronex::Utils.integer(expression)).strftime('%Y')
    end

    def interval_description_format(expression)
      format(', ' + resources.get('every_x') + ' ' + plural(expression, resources.get('year'), resources.get('years')), expression)
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
