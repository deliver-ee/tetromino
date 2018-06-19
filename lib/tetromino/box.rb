Tetromino::Box = Struct.new(*Tetromino::BOX_ARGS) do
  attr_reader :items

  def depth
    dimensions[0]
  end

  def width
    dimensions[1]
  end

  def height
    dimensions[2]
  end

  def volume
    dimensions.inject(:*)
  end

  def has_weight_limit?
    not max_weight.nil?
  end

  def append!(item:)
    @items = [] if @items.nil?
    @items << item if item.is_a?(Tetromino::Item)
    item
  end
end
