require_relative 'cube_state'
require_relative 'direction'
require_relative 'coordinate'

module SnakeCube
  class SearchState
    class SearchStep
    end

    class InitialStep < SearchStep
      def initialize(initial_coordinate)
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
    end

    class MoveStep < SearchStep
      def initialize(previous_coordinate, direction, length)
        @previous_coordinate = previous_coordinate
        @direction = direction
        @length = length
      end

      attr_reader :direction

      def end_coordinate
        @previous_coordinate + @direction * length
      end

      def apply!(cube_state)
        (1..length).each do |factor|
          cube_state.occupy!(@last_coordinate + direction * factor)
        end
      end

      def unapply!(cube_state)
        (1..length).each do |factor|
          cube_state.free!(@last_coordinate + direction * factor)
        end
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
      valid_directions = directions.select do |direction|
        @cube_state.coordinate_inside?(@last_coordinate + direction * length) && (1..length).all? do |factor|
          !@cube_state.occupied?(@last_coordinate + direction * factor)
        end
      end
      valid_directions.map do |direction|
        MoveStep.new(@step_stack.last.end_coordinate, d, length)
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
