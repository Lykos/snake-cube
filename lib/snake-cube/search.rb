require_relative 'search_state'

module SnakeCube
  class Search
    def initialize(snake, size, reporting_level=-1, dimension=3)
      raise TypeError unless size.is_a?(Integer)
      raise TypeError unless reporting_level.is_a?(Integer)
      raise TypeError unless snake.all? { |s| s.is_a?(Integer) }
      raise ArgumentError unless size > 0
      raise ArgumentError unless snake.all? { |s| s >= 1 && s <= size }
      raise ArgumentError, "Snake sums up to #{snake.sum} but should be #{size ** dimension - 1}." unless snake.sum == size ** dimension - 1
      @snake = snake
      @size = size
      @reporting_level = reporting_level
      @dimension = dimension
      @search_state = SearchState.new(size, dimension)
      @steps_tried = 0
    end

    def solvable_check_worth_it?(snake_index)
      snake_index + 6 < @snake.length
    end

    def search_internal(steps, snake_index)
      steps.each do |s|
        if snake_index < @reporting_level
          puts "#{' ' * snake_index}#{@steps_tried} steps tried; Trying #{s} next"
        end
        return nil if solvable_check_worth_it?(snake_index) && !@search_state.solvable?
        @search_state.push_step!(s)
        @steps_tried += 1
        if snake_index == @snake.length
          unless @search_state.solved?
            raise "Found a solution #{@search_state.solution}, but it isn't really solved. #{@search_state.num_occupied} squares are occupied."
          end
          return "Found solution in #{@steps_tried} steps:\n#{@search_state.solution}"
        end
        result = search_internal(@search_state.next_steps(@snake[snake_index]), snake_index + 1)
        return result if result
        @search_state.pop_step!        
      end
      nil
    end

    def search
      search_internal(@search_state.initial_steps, 0)
    end
  end
end
