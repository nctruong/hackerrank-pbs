#!/bin/ruby
require 'byebug'
require 'json'
require 'stringio'

inputs = File.read('sample.input').split("\n")
states = []
@row = inputs[0][0].to_i
@col = inputs[0][2].to_i
@n = inputs[0][4].to_i
inputs[1..6].each do |line|
  states << line.split('')
end

def explode!(states, row, col, current_second)
  states[row][col] = '.'
  states[row - 1][col] = '.' if (row - 1) >= 0 && states[row - 1][col] != current_second
  states[row + 1][col] = '.' if (row + 1) < @row && states[row + 1][col] != current_second
  states[row][col - 1] = '.' if (col - 1) >= 0 && states[row][col - 1] != current_second
  states[row][col + 1] = '.' if (col + 1) < @col && states[row][col + 1] != current_second
  states
rescue
  p "#{row} - #{col}"
end

def set_time(states, row, col, current_second)
  states[row][col] = current_second + 3
  states
end

def time2explode?(states, row, col, current_second)
  states[row][col] == current_second
end

def isBomb?(states, row, col)
  states[row][col] != '.'
end

def transform(states)
  [*0..@row - 1].each_index do |row|
    [*0..@col - 1].each_index do |col|
      states[row][col] = 'O' if isBomb?(states, row, col)
    end
  end
  states.collect { |row| row.join }
end

def plantBomb(states, current_second)
  [*0..@row - 1].each_index do |row|
    [*0..@col - 1].each_index do |col|
      states[row][col] = current_second + 3 unless isBomb?(states, row, col)
    end
  end
  states
end

def time2plantBom?(current_second)
  current_second%2 == 0 && current_second != 0
end

def print_states(states)
  states.each { |row| print "#{row}\n" }
end

def solve(states)
  # init time to explode
  [*0..@row - 1].each_index do |row|
    [*0..@col - 1].each_index do |col|
      # byebug
      if states[row][col] == 'O'
        states[row][col] = 3
      end
    end
  end
  # byebug
  # Your solution here
  [*1..@n].each do |current_second|
    [*0..@row - 1].each_index do |row|
      [*0..@col - 1].each_index do |col|
        # bombs explode
        if isBomb?(states, row, col)
          states = explode!(states, row, col, current_second) if time2explode?(states, row, col, current_second)
        end
        # planting bombs
        states = plantBomb(states, current_second) if time2plantBom?(current_second)
      end
    end
    # byebug
  end
  transform(states)
end

states = solve(states)
print_states(states)