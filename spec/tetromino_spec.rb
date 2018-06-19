RSpec.describe Tetromino do
  it "has a version number" do
    expect(Tetromino::VERSION).not_to be nil
  end

  it "requires items to pack" do
    tetromino = Tetromino.packer(dimensions: [40, 30, 20])
    expect { tetromino.pack! }.to raise_error(Tetromino::Exceptions::NothingToPack)
  end

  context "when items are BOTH stackable AND invertible" do
    it "can pack some items in a box" do
      tetromino = Tetromino.packer(dimensions: [40, 30, 20])
      tetromino.add_item!(dimensions: [40, 30, 10])
      tetromino.add_item!(dimensions: [10, 40, 30])
      tetromino.pack!
      expect(tetromino.packed_successfully?).to be_truthy
    end

    it "can pack some items in several boxes" do
      tetromino = Tetromino.packer(dimensions: [40, 30, 20], boxes_limit: 2)
      tetromino.add_item!(dimensions: [40, 30, 20])
      tetromino.add_item!(dimensions: [30, 20, 40])
      tetromino.pack!
      expect(tetromino.packed_successfully?).to be_truthy
      expect(tetromino.results.count).to eq(2)
    end

    it "can't pack too many items in a box" do
      tetromino = Tetromino.packer(dimensions: [40, 30, 20])
      tetromino.add_item!(dimensions: [40, 20, 30])
      tetromino.add_item!(dimensions: [40, 30, 20])
      expect { tetromino.pack! }.to raise_error(Tetromino::Exceptions::CannotFitInBoxes)
    end

    describe "with limit on weight capacity" do
      it "can pack some items in a box" do
        tetromino = Tetromino.packer(dimensions: [40, 30, 20], max_weight: 5)
        tetromino.add_item!(dimensions: [40, 15, 20], weight: 2)
        tetromino.add_item!(dimensions: [40, 15, 20], weight: 3)
        tetromino.pack!
        expect(tetromino.packed_successfully?).to be_truthy
      end

      it "can't pack too heavy items in a box" do
        tetromino = Tetromino.packer(dimensions: [40, 30, 20], max_weight: 5)
        tetromino.add_item!(dimensions: [40, 15, 20], weight: 3)
        tetromino.add_item!(dimensions: [40, 15, 20], weight: 3)
        expect { tetromino.pack! }.to raise_error(Tetromino::Exceptions::CannotFitInBoxes)
      end

      it "can't pack if an item is heavier than the box capacity" do
        tetromino = Tetromino.packer(dimensions: [40, 30, 20], max_weight: 5)
        tetromino.add_item!(dimensions: [20, 30, 20], weight: 6)
        expect { tetromino.pack! }.to raise_error(Tetromino::Exceptions::TooHeavyItem)
      end
    end
  end

  context "when items are NOT stackable" do
    it "can pack some items in a box" do
      tetromino = Tetromino.packer(dimensions: [40, 30, 20])
      tetromino.add_item!(dimensions: [40, 15, 20], stackable: false)
      tetromino.add_item!(dimensions: [40, 15, 20], stackable: false)
      tetromino.pack!
      expect(tetromino.packed_successfully?).to be_truthy
    end

    it "can pack some items in several boxes" do
      tetromino = Tetromino.packer(dimensions: [40, 30, 20], boxes_limit: 2)
      tetromino.add_item!(dimensions: [40, 30, 10], stackable: false)
      tetromino.add_item!(dimensions: [40, 30, 10], stackable: false)
      tetromino.pack!
      expect(tetromino.packed_successfully?).to be_truthy
    end

    it "can't pack too many items in a box" do
      tetromino = Tetromino.packer(dimensions: [40, 30, 20])
      tetromino.add_item!(dimensions: [40, 30, 10], stackable: false)
      tetromino.add_item!(dimensions: [40, 30, 10], stackable: false)
      expect { tetromino.pack! }.to raise_error(Tetromino::Exceptions::CannotFitInBoxes)
    end
  end

  context "when items are NOT invertible" do
    it "can pack some items in a box" do
      tetromino = Tetromino.packer(dimensions: [40, 30, 20])
      tetromino.add_item!(dimensions: [40, 15, 20], invertible: false)
      tetromino.add_item!(dimensions: [40, 15, 20], invertible: false)
      tetromino.pack!
      expect(tetromino.packed_successfully?).to be_truthy
    end

    it "can pack some items in several boxes" do
      tetromino = Tetromino.packer(dimensions: [40, 30, 20], boxes_limit: 2)
      tetromino.add_item!(dimensions: [40, 30, 10], invertible: false)
      tetromino.add_item!(dimensions: [30, 40, 10], invertible: false)
      tetromino.pack!
      expect(tetromino.packed_successfully?).to be_truthy
    end

    it "can't pack items in a box" do
      tetromino = Tetromino.packer(dimensions: [40, 30, 20])
      tetromino.add_item!(dimensions: [40, 30, 10], invertible: false)
      tetromino.add_item!(dimensions: [40, 10, 30], invertible: false)
      expect { tetromino.pack! }.to raise_error(Tetromino::Exceptions::CannotFitInBoxes)
    end
  end

  context "when items are BOTH NOT stackable AND invertible" do
    it "can pack some items in a box" do
      tetromino = Tetromino.packer(dimensions: [40, 30, 20])
      tetromino.add_item!(dimensions: [40, 15, 20], stackable: false, invertible: false)
      tetromino.add_item!(dimensions: [15, 40, 20], stackable: false, invertible: false)
      tetromino.pack!
      expect(tetromino.packed_successfully?).to be_truthy
    end

    it "can pack some items in several boxes" do
      tetromino = Tetromino.packer(dimensions: [40, 30, 20], boxes_limit: 2)
      tetromino.add_item!(dimensions: [40, 30, 10], stackable: false, invertible: false)
      tetromino.add_item!(dimensions: [30, 40, 10], stackable: false, invertible: false)
      tetromino.pack!
      expect(tetromino.packed_successfully?).to be_truthy
    end

    it "can't pack too many items in a box" do
      tetromino = Tetromino.packer(dimensions: [40, 30, 20])
      tetromino.add_item!(dimensions: [40, 30, 10], stackable: false, invertible: false)
      tetromino.add_item!(dimensions: [30, 40, 10], stackable: false, invertible: false)
      expect { tetromino.pack! }.to raise_error(Tetromino::Exceptions::CannotFitInBoxes)
    end
  end
end
