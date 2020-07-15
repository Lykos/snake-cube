module SnakeCube
  class Direction
    def self.all_for_indices(indices, dimension)
      raise TypeError unless indices.all? { |i| i.is_a?(Integer) }
      raise TypeError unless dimension.is_a?(Integer)
      raise ArgumenTerror unless dimension > 0
      raise TypeError unless indices.all? { |i| i >= 0 && i < dimension }

      indices.collect_concat do |i|
        [-1, 1].map do |d|
          new([0] * i + [d] + [0] * (dimension - i - 1))
        end
      end
    end

    def self.all(dimension)
      all_for_indices((0...dimension).to_a, dimension)
    end

    def initialize(dcoords)
      raise TypeError unless dcoords.all? { |d| d.is_a?(Integer) }
      raise ArgumentError unless dcoords.map(&:abs).sort[0...dcoords.length - 1].all? { |d| d == 0 }
      @dcoords = dcoords
    end

    attr_reader :dcoords

    def dimension
      @dcoords.length
    end

    def *(factor)
      self.class.new(@dcoords.map { |d| d * factor })
    end

    def diff_index
      @dcoords.index { |d| d != 0 }
    end

    def orthogonals
      self.class.all_for_indices((0...dimension).to_a - [diff_index], dimension)
    end

    def to_s
      "(#{@dcoords.join(', ')})"
    end
  end
end
