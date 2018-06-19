module Tetromino
  BOX_ARGS = %i[dimensions max_weight].freeze
  ITEM_ARGS = %i[dimensions weight stackable invertible packed].freeze
  PACKER_ARGS = %i[box boxes_limit].freeze
  PACKING_ARGS = %i[placements weight spaces].freeze
  PLACEMENT_ARGS = %i[dimensions position weight].freeze
  SPACE_ARGS = %i[dimensions position].freeze
end
