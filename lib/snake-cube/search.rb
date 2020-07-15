require_relative 'search_state'

module SnakeCube
  class Search
    def initialize(snake, size, dimension=3)
      raise TypeError unless size.is_a?(Integer)
      raise TypeError unless snake.all? { |s| s.is_a?(Integer) }
      raise ArgumentError unless size > 0
      raise ArgumentError unless snake.all? { |s| s >= 1 && s <= size }
      raise ArgumentError, "Snake sums up to #{snake.sum} but should be #{size ** dimension - 1}." unless snake.sum == size ** dimension - 1
      @snake = snake
      @size = size
      @dimension = dimension
      @search_state = SearchState.new(size, dimension)
    end

    def search_internal(steps, snake_index)
      steps.each do |s|
        @search_state.push_step!(s)
        if snake_index + 1 == @snake.length
          raise unless @search_state.solved?
          return @search_state.solution
        end
        result = search_internal(@search_state.next_steps(@snake[snake_index]), snake_index + 1)
        return result if result
        @search_state.pop_step!        
      end
    end

    def search
      search_internal(@search_state.initial_steps, 0)
    end
  end
end
