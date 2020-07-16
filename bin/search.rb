#!/usr/bin/ruby

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'snake-cube/direction'
require 'snake-cube/search'

SIMPLE_SNAKE = [1] * 7
SNAKE = [2, 1, 2, 1, 1, 3, 1, 2, 1, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 2, 3, 1, 1, 1, 3, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1]

search = SnakeCube::Search.new(SNAKE.reverse, 4, 7)
# search = SnakeCube::Search.new(SIMPLE_SNAKE, 2)
puts SnakeCube::Search::SOLVABLE_CHECK_BOUNDARY
puts search.search
