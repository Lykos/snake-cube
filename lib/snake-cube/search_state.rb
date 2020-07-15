require_relative 'cube_state'
require_relative 'direction'
require_relative 'coordinate'

module SnakeCube
  class SearchState
    class SearchStep
    end

    class InitialStep < SearchStep
      def initialize(initial_coordinate)
        raise TypeError unless initial_coordinate.is_a?(Coordinate)

        @initial_coordinate = initial_coordinate
      end

      def end_coordinate
        @initial_coordinate
      end

      def direction
        nil
      end

      def apply!(cube_state)
        cube_state.occupy!(@initial_coordinate)
      end

      def unapply!(cube_state)
        cube_state.free!(@initial_coordinate)
      end

      def to_s
        @initial_coordinate.to_s
      end
    end

    class MoveStep < SearchStep
      def initialize(previous_coordinate, direction, length)
        raise TypeError unless previous_coordinate.is_a?(Coordinate)
        raise TypeError unless direction.is_a?(Direction)
        raise TypeError unless length.is_a?(Integer)
        raise ArgumentError unless length > 0

        @previous_coordinate = previous_coordinate
        @direction = direction
        @length = length
      end

      attr_reader :direction

      def end_coordinate
        @previous_coordinate + @direction * @length
      end

      def apply!(cube_state)
        (1..@length).each do |factor|
          cube_state.occupy!(@previous_coordinate + @direction * factor)
        end
      end

      def unapply!(cube_state)
        (1..@length).each do |factor|
          cube_state.free!(@previous_coordinate + @direction * factor)
        end
      end

      def to_s
        "-> #{@direction * @length}"
      end
    end

    def initialize(size, dimension=3)
      @size = size
      @dimension = dimension
      @cube_state = CubeState.new(size, dimension)
      @step_stack = []
      @direction_stack = []
    end

    def initial_steps
      Coordinate.all(@size, @dimension).map { |coordinate| InitialStep.new(coordinate) }
    end

    def next_steps(length)
      raise if @step_stack.empty?
      directions = 
        @step_stack.last.direction ? @step_stack.last.direction.orthogonals : Direction.all(@dimension)
      last_coordinate = @step_stack.last.end_coordinate
      valid_directions = directions.select do |direction|
        @cube_state.coordinate_inside?(last_coordinate + direction * length) && (1..length).all? do |factor|
          !@cube_state.occupied?(last_coordinate + direction * factor)
        end
      end
      valid_directions.map do |direction|
        MoveStep.new(@step_stack.last.end_coordinate, direction, length)
      end
    end

    def push_step!(step)
      raise TypeError unless step.is_a?(SearchStep)

      step.apply!(@cube_state)
      @step_stack.push(step)
    end

    def pop_step!
      @step_stack.pop.unapply!(@cube_state)
    end

    def solved?
      @cube_state.full?
    end

    def solution
      {
        initial_coordinate: step_stack.first.end_coordinate,
        steps: step_stack.map(&:direction)
      }
    end
  end
end
