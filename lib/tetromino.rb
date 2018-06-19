require "tetromino/args"
require "tetromino/box"
require "tetromino/exceptions"
require "tetromino/item"
require "tetromino/packer"
require "tetromino/packing"
require "tetromino/placement"
require "tetromino/space"
require "tetromino/version"

module Tetromino
  extend Forwardable
  def_delegator :@box, :add_item, :pack!

  def self.packer(dimensions: [0, 0, 0],  max_weight: nil, boxes_limit: 1)
    box = Tetromino::Box.new(dimensions, max_weight)
    Tetromino::Packer.new(box, boxes_limit)
  end
end
