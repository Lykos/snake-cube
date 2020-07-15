require_relative 'coordinate'

module SnakeCube
  class CubeState
    def initialize(size, dimension=3)
      @size = size
      @dimension = dimension
      @state_array = [false] * (size ** dimension)
      @occupied = 1
    end

    def coordinate_inside?(coordinate)
      raise TypeError unless coordinate.is_a?(Coordinate)
      raise ArgumentError unless coordinate.dimension == @dimension

      coordinate.coords.min >= 0 && coordinate.coords.max < @size
    end

    def coordinate_index(coordinate)
      raise ArgumentError unless coordinate_inside?(coordinate)

      coordinate.coords.inject(0) { |index, c| index * @size + c }
    end

    def occupied?(coordinate)
      @state_array[coordinate_index(coordinate)]
    end

    def occupy!(coordinate)
      raise ArgumentError if occupied?(coordinate)
      @occupied += 1
      @state_array[coordinate_index(coordinate)] = true
    end

    def free!(coordinate)
      raise ArgumentError unless occupied?(coordinate)
      @occupied -= 1
      @state_array[coordinate_index(coordinate)] = false
    end

    def full?
      @occupied == @size ** @dimension
    end
  end
end
