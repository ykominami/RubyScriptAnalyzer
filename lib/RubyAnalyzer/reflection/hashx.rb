require 'forwardable'

module RubyAnalyzer
  class Hashx
		extend Forwardable

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

		def add(key, item)
			@hs[key] = item
		end
	end
end