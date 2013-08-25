# ================================================================
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2004
# Ported to Ruby 2011-02-10
# ================================================================

class Factorization

	# ----------------------------------------------------------------
	def initialize
		@factors_and_multiplicities = []
		@trivial_factor = nil # E.g. -1, 0, 1.
	end

	attr_reader :trivial_factor
	attr_reader :factors_and_multiplicities

	def num_distinct_factors # Don't count trivial factors.
		@factors_and_multiplicities.length
	end
	def num_factors # Don't count trivial factors.
		@factors_and_multiplicities.inject(0) {|rv, fnm| rv += fnm[1]}
	end
	def get(i)
		@factors_and_multiplicities[i]
	end
	def get_factor(i)
		@factors_and_multiplicities[i][0]
	end
	def get_multiplicity(i)
		@factors_and_multiplicities[i][1]
	end

	# ----------------------------------------------------------------
	def to_s
		s = ""
		num_printed = 0
		if !@trivial_factor.nil?
			s << @trivial_factor.to_s
			num_printed += 1
		end
		for factor, multiplicity in @factors_and_multiplicities
			if num_printed > 0
				s << " "
			end
			s << factor.to_s
			if multiplicity != 1
				s << "^" << multiplicity.to_s
			end
			num_printed+= 1
		end
		s
	end

	# ----------------------------------------------------------------
	def insert_trivial_factor(new_factor)
		if !new_factor.nil?
			if !@trivial_factor.nil?
				@trivial_factor *= new_factor
			else
				@trivial_factor = new_factor
			end
		end
	end

	# Inserts in sorted order.  This makes it easier to unit-test the
	# factorization algorithm.
	def insert_factor(new_factor, new_multiplicity=1)
		m = @factors_and_multiplicities.length
		for i in 0..(m-1)
			factor, multiplicity = @factors_and_multiplicities[i]
			if new_factor == factor
				@factors_and_multiplicities[i][1] += new_multiplicity
				return
			elsif new_factor < factor
				@factors_and_multiplicities.insert(i, \
					[new_factor, new_multiplicity])
				return
			end
		end
		# Append to the end (or, new first element in the previously empty
		# list).
		@factors_and_multiplicities.push([new_factor, new_multiplicity])
	end

	def merge(other)
		self.insert_trivial_factor(other.trivial_factor)
		other.factors_and_multiplicities.each do |fnm|
			f, m = fnm
			self.insert_factor(f, m)
		end
	end

	def exp_all(e)
		if !@trivial_factor.nil?
			@trivial_factor **= e
		end
		@factors_and_multiplicities.each {|fnm| fnm[1] *= e}
	end

	# ----------------------------------------------------------------
	# Given the prime factorization p1^m1 ... pk^mk of n, how to enumerate all
	# factors of n?
	#
	# Example 72 = 2^3 * 3^2.  Exponent on 2 is one of 0, 1, 2, 3.
	# Exponent on 3 is one of 0, 1, 2.  Number of possibilities:  product
	# over i of (mi + 1).  Factors are:
	#
	#	2^0 3^0    1
	#	2^0 3^1    3
	#	2^0 3^2    9
	#	2^1 3^0    2
	#	2^1 3^1    6
	#	2^1 3^2   18
	#	2^2 3^0    4
	#	2^2 3^1   12
	#	2^2 3^2   36
	#	2^3 3^0    8
	#	2^3 3^1   24
	#	2^3 3^2   72

	def num_divisors
		ndf = self.num_distinct_factors
		if ndf <= 0
			if @trivial_factor.nil?
				raise "Factorization.num_divisors:  " \
					"No factors have been inserted.\n"
			end
		end
		rv = 1
		for i in (0..(ndf-1))
			rv *= @factors_and_multiplicities[i][1] + 1
		end
		return rv
	end

	# ----------------------------------------------------------------
	# See comments to num_divisors.  k is treated as a multibase
	# representation over the bases mi+1.  (This may overflow a 32-bit
	# integer when factoring something large -- but if something really
	# has more than a billion factors, it is impractical to loop over all
	# its factors anyway.)

	def kth_divisor(k)
		ndf = self.num_distinct_factors
		if ndf <= 0
			if !@trivial_factor.nil?
				return @trivial_factor / @trivial_factor # abstract one
			else
				raise << "Factorization.kth_divisor:  "
					"No factors have been inserted.\n"
			end
		end

		x = @factors_and_multiplicities[0][0]
		rv = x / x # abstract one
		for i in (0..(ndf-1))
			base = @factors_and_multiplicities[i][1] + 1
			power = k % base
			k     = k / base
			rv *= @factors_and_multiplicities[i][0] ** power
		end
		return rv
	end

	# ----------------------------------------------------------------
	# Returns an array of divisors.   The output is sorted from smallest to
	# largest.
	def all_divisors
		ndf = self.num_distinct_factors
		if ndf <= 0
			if @trivial_factor.nil?
				raise "Factorization.all_divisors:  " \
					"No factors have been inserted.\n"
			end
		end
		nd = self.num_divisors
		rv = [0] * nd
		for k in (0..(nd-1))
			rv[k] = self.kth_divisor(k)
		end
		rv.sort!
		return rv
	end

	# ----------------------------------------------------------------
	# The output is sorted from smallest to largest.
	def maximal_proper_divisors
		ndf = self.num_distinct_factors
		if ndf <= 0
			if @trivial_factor.nil?
				raise "Factorization.maximal_proper_divisors:  " \
					"No factors have been inserted.\n"
			else
				return []
			end
		end

		save_trivial_factor = @trivial_factor
		@trivial_factor = nil
		n = self.unfactor

		rv = [0] * ndf
		for k in (0..(ndf-1))
			rv[k] = n / @factors_and_multiplicities[k][0]
		end
		rv.sort!

		@trivial_factor = save_trivial_factor

		return rv
	end

	# ----------------------------------------------------------------
	def unfactor
		ndf = self.num_distinct_factors
		if ndf <= 0
			if @trivial_factor.nil?
				raise "Factorization.maximal_proper_divisors:  " \
					"No factors have been inserted.\n"
			else
				return @trivial_factor
			end
		end

		x = @factors_and_multiplicities[0][0]
		rv = x/x

		if !@trivial_factor.nil?
			rv *= @trivial_factor
		end

		for p,e in @factors_and_multiplicities
			rv *= p**e
		end
		return rv
	end

end
