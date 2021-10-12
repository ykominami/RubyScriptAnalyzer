#require 'enumerable'

module RubyAnalyzer
  class Listex
    include Enumerable

    def initialize
      @index_hash = {}
      @hash_by_index = {}
      @count = 0
    end

    def each(&block)
      if block
        0.upto(@count - 1) do |x|
          block.call( @hash_by_index[x] ) 
        end
      end
    end

    def at( index )
      @hash_by_index[index]
    end
    
    def index( value )
      @index_hash[ value ]
    end

    def add( value )
      index = @index_hash[value]
      unless index
        @index_hash[value] = @count
        @hash_by_index[@count] = value
        index = @count
        @count += 1
      end
      index
    end

    def size
      @index_hash.size
    end
  end
end # module RubyAnalyzer
