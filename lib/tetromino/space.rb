Tetromino::Space = Struct.new(*Tetromino::SPACE_ARGS) do
  def break_up(placement:)
    return [] if placement.nil?
    [
      Tetromino::Space.new(
        [
          dimensions[0] - placement.dimensions[0],
          dimensions[1],
          dimensions[2]
        ],
        [
          position[0] + placement.dimensions[0],
          position[1],
          position[2]
        ]
      ),
      Tetromino::Space.new(
        [
          placement.dimensions[0],
          dimensions[1] - placement.dimensions[1],
          dimensions[2]
        ],
        [
          position[0],
          position[1] + placement.dimensions[1],
          position[2]
        ]
      ),
      Tetromino::Space.new(
        [
          placement.dimensions[0],
          placement.dimensions[1],
          dimensions[2] - placement.dimensions[2]
        ],
        [
          position[0],
          position[1],
          position[2] + placement.dimensions[2]
        ]
      )
    ]
  end
end
