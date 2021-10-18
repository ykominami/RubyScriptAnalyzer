class Tuple
	def initialize(left, right)
		@left = left
		@right = right
	end

	def l
		@left
	end

	def r
		@right
	end

	def to_s
		%Q!#{@left} #{@right}!
	end

	def name
		@right.name
	end
end