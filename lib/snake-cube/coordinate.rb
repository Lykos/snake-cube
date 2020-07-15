module SnakeCube
  class Coordinate
    def self.all(size, dimension)
      coordinates = (0...size).to_a
      coordinates.product(*[coordinates] * (dimension - 1))
    end

    def initialize(coords)
      raise TypeError unless coords.all? { |c| c.is_a?(Integer) }
      raise TypeError unless coords.all? { |c| c >= 0 }
      @coords = coords
    end

    attr_reader :coords

    def dimension
      @coords.length
    end

    def +(direction)
      raise ArgumentError unless direction.dimension == dimension
      self.class.new(coords.zip(direction.dcoords).map(&:sum))
    end
  end
end
