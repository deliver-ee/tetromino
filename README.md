[![Gem Version](https://badge.fury.io/rb/tetromino.svg)](https://badge.fury.io/rb/tetromino)

# Tetromino

## Introduction

First fit heuristic algorithm for 4D bin packing problem solver (4dbpp).
An implementation of the "4D" bin packing problem i.e. given a list of items,
how many boxes do you need to fit them all in taking into account physical
dimensions and weights.

This project is a complete rewrite of [box_packer](https://github.com/mushishi78/box_packer)

It also provide 2 additional "real life" features:
* Coerce items that can't be stacked.
* Coerce items that are not invertible.

...Especially if you need to pack (big) fragile items.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tetromino'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tetromino

## Usage

```ruby
tetromino = Tetromino.packer(dimensions: [40, 30, 20]) # Define the size of your box
tetromino.add_item!(dimensions: [40, 30, 10]) # Fill it up with item
tetromino.add_item!(dimensions: [10, 40, 30]) # ...Moarrr item!
tetromino.pack! # Pack your stuff
tetromino.packed_successfully? # => true
```
### Dimensions

Dimensions **should always** be declared in the following order:
`[depth, width, height]`

### Detailed results

You can also get the results of the algorithm.

```ruby
results = tetromino.results
=> [#<struct Tetromino::Packing
    placements=
    [
      #<struct Tetromino::Placement
        dimensions=[40, 30, 10],
        position=[0, 0, 0],
        weight=0>,
      #<struct Tetromino::Placement
        dimensions=[40, 30, 10],
        position=[0, 0, 10],
        weight=0>
    ],
    weight=0.0,
    spaces=
    [
      #<struct Tetromino::Space
        dimensions=[0, 30, 20],
        position=[40, 0, 0]>,
      #<struct Tetromino::Space
        dimensions=[40, 0, 20],
        position=[0, 30, 0]>,
      #<struct Tetromino::Space
        dimensions=[0, 30, 10],
        position=[40, 0, 10]>,
      #<struct Tetromino::Space
        dimensions=[40, 0, 10],
        position=[0, 30, 10]>,
      #<struct Tetromino::Space
        dimensions=[40, 30, 0],
        position=[0, 0, 20]>
    ]>
  ]
```

### Placements

Placements represent how your items have been organized into your box(es) (dimensions & positions).

```ruby
results.placements
```

### Spaces

These are the empty spaces remaining in your box(es).

```ruby
results.spaces
```

### Weight

This is the total weight of the packed items.

```ruby
results.weight
```

## Advanced usages

### Weight coercion

You can define a weight limit constraint on your box(es).

```ruby
begin
tetromino = Tetromino.packer(dimensions: [40, 30, 20], max_weight: 4)
tetromino.add_item!(dimensions: [40, 15, 20], weight: 2)
tetromino.add_item!(dimensions: [40, 15, 20], weight: 3)
tetromino.pack!
tetromino.packed_successfully? # => false
rescue Tetromino::Exceptions::Error => error
  puts error.message # => Maximum boxes quantity exceeded
end
```

### Multiple boxes

You can try to pack your items in multiple boxes.

```ruby
tetromino = Tetromino.packer(dimensions: [40, 30, 20], boxes_limit: 2)
tetromino.add_item!(dimensions: [40, 30, 20])
tetromino.add_item!(dimensions: [30, 20, 40])
tetromino.pack!
tetromino.packed_successfully? # => true
```

### Not stackable items

You can define if your items can't be stacked.

```ruby
begin
  tetromino = Tetromino.packer(dimensions: [40, 30, 20])
  tetromino.add_item!(dimensions: [40, 30, 10], stackable: false)
  tetromino.add_item!(dimensions: [40, 30, 10], stackable: false)
  tetromino.pack!
  tetromino.packed_successfully? # => false
rescue Tetromino::Exceptions::Error => error
  puts error.message # => Maximum boxes quantity exceeded
end
```

### Not invertible items

You can define if your items can't be leaned.
(impossible to permute height with depth or width)

```ruby
begin
  tetromino = Tetromino.packer(dimensions: [40, 30, 20])
  tetromino.add_item!(dimensions: [40, 30, 10], invertible: false)
  tetromino.add_item!(dimensions: [40, 10, 30], invertible: false)
  tetromino.pack!
  tetromino.packed_successfully? # => false
rescue Tetromino::Exceptions::Error => error
  puts error.message # => Maximum boxes quantity exceeded
end
```

### Parameters combinations

You can combine all the parameters at once:

```ruby
tetromino = Tetromino.packer(dimensions: [40, 30, 20], boxes_limit: 2, max_weight: 5)
tetromino.add_item!(dimensions: [40, 30, 10], invertible: false, stackable: false, weight: 2)
tetromino.add_item!(dimensions: [30, 40, 10], invertible: false, stackable: false, weight: 3)
tetromino.pack!
tetromino.packed_successfully? # => true
```

## Errors handling

Tetromino will always raise an error if it is unable to pack your items with
the given constraints.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/deliver-ee/tetromino.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
