require_relative 'coordinate'
require_relative 'direction'

module SnakeCube
  class CubeState
    def initialize(size, dimension=3)
      @size = size
      @dimension = dimension
      @state_array = [false] * (size ** dimension)
      @num_occupied = 0
    end

    attr_reader :num_occupied

    def coordinate_inside?(coordinate)
      raise TypeError unless coordinate.is_a?(Coordinate)
      raise ArgumentError unless coordinate.dimension == @dimension

      coordinate.coords.min >= 0 && coordinate.coords.max < @size
    end

    def coordinate_index(coordinate)
      raise ArgumentError unless coordinate_inside?(coordinate)

      coordinate.coords.inject(0) { |index, c| index * @size + c }
    end

    def coordinate_for_index(index)
      raise TypeError unless index.is_a?(Integer)
      raise ArgumentError unless index >= 0 && index < @size ** @dimension

      a = [0] * @dimension
      (@dimension - 1).downto(0) do |i|
        a[i] = index % @size
        index /= @size
         # Comment to make emacs formatting happy: /
      end
      Coordinate.new(a.reverse)
    end

    def neighbor_indices(index)
      coordinate = coordinate_for_index(index)
      Direction.all(@dimension)
        .map { |direction| coordinate + direction }
        .select { |coordinate| coordinate_inside?(coordinate) }
        .map { |coordinate| coordinate_index(coordinate) }
    end

    def occupied?(coordinate)
      @state_array[coordinate_index(coordinate)]
    end

    def occupy!(coordinate)
      raise ArgumentError if occupied?(coordinate)
      @num_occupied += 1
      @state_array[coordinate_index(coordinate)] = true
    end

    def free!(coordinate)
      raise ArgumentError unless occupied?(coordinate)
      @num_occupied -= 1
      @state_array[coordinate_index(coordinate)] = false
    end

    def full?
      @num_occupied == @size ** @dimension
    end

    # Does a moderately expensive check if there can still be a solution without backtracking
    # using some heuristics.
    def solvable?
      return true

      # TODO Make this work
      return true if full?

      state_array_copy = @state_array.dup
      start_index = state_array_copy.index(false)
      index_stack = [start_index]
      connected_found = 0
      until index_stack.empty?
        index = index_stack.pop
        next if state_array_copy[index]

        state_array_copy[index] = true
        connected_found += 1
        index_stack += neighbor_indices(index)
      end
      return false unless connected_found + @num_occupied == @size ** @dimension

      num_dead_ends = (0...@size ** @dimension).to_a.count do |index|
        !@state_array[index] && neighbor_indices(index).count { |neighbor_index| !@state_array[neighbor_index] } == 1
      end
      return num_dead_ends <= 1
    end
  end
end
