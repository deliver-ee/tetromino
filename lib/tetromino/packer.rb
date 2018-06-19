Tetromino::Packer = Struct.new(*Tetromino::PACKER_ARGS) do
  attr_reader :results

  def add_item!(dimensions: [], weight: 0, stackable: true, invertible: true)
    item = Tetromino::Item.new(dimensions, weight, stackable, invertible, false)
    self.box.append!(item: item)
  end

  def items
    box.items
  end

  def pack!
    raise Tetromino::Exceptions::NothingToPack if items.nil? || items.empty?
    @results = []

    items.sort!.each do |item|
      if box.has_weight_limit? && (item.weight.to_f > box.max_weight.to_f)
        raise Tetromino::Exceptions::TooHeavyItem
      end

      @results.each do |packing|
        next if box.has_weight_limit? && \
                (packing.weight.to_f + item.weight.to_f > box.max_weight.to_f)

        packing.spaces.each do |space|
          next unless placement = item.place(space: space)

          packing.placements += [placement]
          packing.weight += item.weight.to_f
          packing.spaces -= [space]
          packing.spaces += space.break_up(placement: placement)
          item.packed = true
          break
        end

        break if item.packed
      end
      next if item.packed

      space = Tetromino::Space.new(box.dimensions, [0, 0, 0])

      placement = item.place(space: space)
      item.packed = true unless placement.nil?

      packing = Tetromino::Packing.new(
        [placement],
        item.weight.to_f,
        space.break_up(placement: placement)
      )

      @results += [packing]
    end

    raise Tetromino::Exceptions::CannotFitInBoxes unless packed_successfully?

    @results
  end

  def packed_successfully?
    items.all?(&:packed) && (results.count <= boxes_limit)
  end
end
