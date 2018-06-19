Tetromino::Item = Struct.new(*Tetromino::ITEM_ARGS) do
  include Comparable

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

  def <=> (other)
    other.volume <=> self.volume
  end

  def place(space:)
    permutations = []
    permutations << [depth, width, height]
    permutations << [width, depth, height]

    if invertible
      permutations << [depth, height, width]
      permutations << [width, height, depth]
      permutations << [height, width, depth]
      permutations << [height, depth, width]
    end

    permutations.each do |perm|
      next unless perm[0] <= space.dimensions[0] &&
                  perm[1] <= space.dimensions[1] &&
                  perm[2] <= space.dimensions[2]

      # Consider that all remaining space above is filled
      perm[2] = space.dimensions[2] unless stackable

      return Tetromino::Placement.new(perm, space.position, weight)
    end

    return nil
  end
end

