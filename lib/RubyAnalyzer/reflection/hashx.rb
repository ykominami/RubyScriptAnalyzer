require 'forwardable'

module RubyAnalyzer
  class Hashx
		extend Forwardable

#    def_delegators(:@hs, :add, :size, :include?, :each)
    def_delegators(:@hs, :store, :size, :each, :[], :[]=)

		def initialize
			@hs = {}
			enable
		end

		def clear
			@hs.clear
		end

		def disable
			@able = false
		end

		def enable
			@able = true
		end

		def enable?
			@able
		end
=begin
		def size
			@hs.size
		end
=end
	def add(key, item)
		@hs[key] = item
	end

	def add0(item)
			if item.class == Tuple
				key = item.l
			elsif item.class == Item
				key = item.name
			elsif item.class == Itemdiff
				key = item.name
			else
				key = item
			end
			@hs[key] = item if enable?
		end

		def include?(obj)
			@hs.keys.include?(obj)
		end

		def sort_t!(&block)
			if @hs.values.first.class == Tuple
				list = @hs.values.sort(&block)
			else
				list = @hs.keys.map{|x| Tuple.new(x,nil)}.sort(&block)
			end
			array2self!(list)
		end

		def sort!(&block)
#			list = @hs.keys.sort(&block)
			list = @hs.values.sort(&block)
			array2self!(list)
		end

		def sort_t(&block)
			if @hs.values.first.class == Tuple
				@hs.values.sort(&block)
			else
				@hs.keys.map{|x| Tuple.new(x,nil)}.sort(&block)
			end
		end

		def sort(&block)
#			@hs.keys.sort(&block)
			@hs.values.sort(&block)
		end

		def array2self!(list)
			clear
			list.map{|x| add(x)}
			self
		end

		def map(&block)
			@hs.values.map(&block)
		end

		def map!(&block)
			list = @hs.values.map(&block)
			array2hashx!(list)
		end

		def map_t(&block)
			p "rubyanalyzer2 map_t"
			v = @hs.values.first
			if v.class == Tuple
				@hs.values.map(&block)
			else
				@hs.map{|x| Tuple.new(x[0], x[1]) }.map(&block)
			end
		end

		def map_t!(&block)
			p "rubyanalyzer2 map_t!"
			v = @hs.values.first
			if v.class == Tuple
				list = @hs.values.map(&block)
			else
				list = @hs.map{|x| Tuple.new(x[0], x[1]) }.map(&block)
			end
			array2self!(list)
		end
	end
end