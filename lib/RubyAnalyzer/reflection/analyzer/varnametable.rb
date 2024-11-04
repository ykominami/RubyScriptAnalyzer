require 'forwardable'

module RubyAnalyzer
  class Varnametable
    extend Forwardable
    def_delegators(:@table, :reduce, :each)
  #    def_delegator(:@table, :reduce, :reduce)
  #    def_delegator(:@table, :each, :each)

		class Tableitem
			def initialize(name)
				@src = name
				@dest = nil
			end
		end

		class Tableitemx < Tableitem
			def initialize(name)
				@prefix=""
				if name.is_a?(Symbol)
					@symbol = true
					@src_sym = name
					@src = name.to_s
					if @src =~ /^:@(.*)/
						prefix=":@"
						@src = $1
					elsif @src =~ /^:(.*)/
						prefix=":"
						@src = $1
					else
						 # do nothing
					end
				else
					@symbol = false
					@src = name
					@src_sym = name.to_sym
				end
				# @src = name
				# @dest = nil
				@dest = nil
				@dest_sym = nil
			end

			def make_dest(middle, postfix)
				@dest = %Q!#{@prefix}#{middle}#{@src}#{postfix}!
				@dest_sym = @dest.to_sym
			end

			def src
				@src_sym
			end

			def dest
				@dest_sym
			end
		end

		def initialize
			@table = []
			@index = -1
			enable
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

		def add(name)
			itemx = Tableitemx.new(name)
			itemx.make_dest(nil, "_adjust")
			@table << itemx
		end

		def each
			@index += 1
			@table[@index]
		end
	end
end