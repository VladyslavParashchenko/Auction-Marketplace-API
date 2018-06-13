module Helpers
  class Sequence
    def initialize
      @number = 0
    end
    def number
      @number += 1
      @number
    end
  end
end