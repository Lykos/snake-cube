require_relative 'direction'

module SnakeCube
  class Coordinate
    def self.all(size, dimension)
      coordinates = (0...size).to_a
      coordinates.product(*[coordinates] * (dimension - 1)).map { |coordinate| new(coordinate) }
    end

    def initialize(coords)
      raise TypeError unless coords.all? { |c| c.is_a?(Integer) }

      @coords = coords
    end

    attr_reader :coords

    def dimension
      @coords.length
    end

    def +(direction)
      raise TypeError unless direction.is_a?(Direction)
      raise ArgumentError unless direction.dimension == dimension

      self.class.new(coords.zip(direction.dcoords).map(&:sum))
    end

    def to_s
      "(#{@coords.join(', ')})"
    end
  end
end
