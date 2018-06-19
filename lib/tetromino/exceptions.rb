module Tetromino
  module Exceptions
    class Error < StandardError; end

    class TooHeavyItem < Error
      def message
       'Item is too big to fit in the box'
      end
    end

    class CannotFitInBoxes < Error
      def message
       'Maximum boxes quantity exceeded'
      end
    end

    class NothingToPack < Error
      def message
       'There are no items to pack'
      end
    end
  end
end
