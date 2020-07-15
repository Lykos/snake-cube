module SnakeCube
  class Direction
    def self.all_for_indices(indices)
      indices.collect_concat do |i|
        [-1, 1].map do |d|
          [0] * i + [d] + [0] * (dimension - i - 1)
        end
      end
    end

    def self.all(dimension)
      all_for_indices((0...dimension).to_a)
    end

    def initialize(dcoords)
      raise TypeError unless dcoords.all? { |d| d.is_a?(Integer) }
      raise ArgumentError unless dcoords.map(&:abs).sort[0...coords.length - 1].all? { |d| d == 0 }
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
      self.class.all_for_indices((0...dimension).to_a - [diff_index])
    end
  end
end
