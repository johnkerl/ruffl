#!/usr/bin/ruby -Wall

# ================================================================
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2004
# Ported to Ruby 2011-02-10
# ================================================================

require 'F2_poly.rb'
require 'F2_poly_factor.rb'
require 'Int_factor.rb'

class F2_poly_mod
	# ----------------------------------------------------------------
	def initialize(residue, modulus)
		if F2_poly === residue
			@residue = residue
		else
			@residue = F2_poly.new(residue)
		end
		if F2_poly === modulus
			@modulus = modulus
		else
			@modulus = F2_poly.new(modulus)
		end

		@residue = @residue % @modulus
	end

	attr_accessor :residue
	attr_reader   :modulus

	# ----------------------------------------------------------------
	def to_s()
		@residue.to_s
	end
	def inspect()
		@residue.inspect + "@" + @modulus.inspect
	end

	# ----------------------------------------------------------------
	def ==(other)
		@residue == other.residue and @modulus == other.modulus
	end

	def zero?
		return @residue.zero?
	end
	def one?
		return @residue.one?
	end

	# ----------------------------------------------------------------
	def +(other)
		F2_poly_mod.new((@residue + other.residue) % @modulus, @modulus)
	end
	def -(other)
		F2_poly_mod.new((@residue - other.residue) % @modulus, @modulus)
	end
	def -@
		F2_poly_mod.new((-@residue) % @modulus, @modulus)
	end
	def *(other)
		F2_poly_mod.new((@residue * other.residue) % @modulus, @modulus)
	end

	# See the section "Second reciprocation method" (3.10) in my
	# document "Computation in finite fields".
	# Let r = residue and m = modulus.  We want 1/r mod m.
	# Using extended GCD, we find g, s, and t such that
	#   g = s *r + t * m
	# If g != 1, then r is not invertible.  If g == 1, then
	#   1 = s * r (mod m)
	# and so the reciprocal is s.
	def recip
		g, s, t = @residue.ext_gcd(@modulus)
		if !g.one?
			raise "F2_poly_mod.recip: division by zero."
		end
		return F2_poly_mod.new(s, @modulus)
	end

	def /(other)
		self * other.recip
	end

	def **(e)
		if @residue.zero?
			if e == 0
				raise "Int_mod:  0**0 undefined."
			elsif e < 0
				raise "Int_mod **:  division by zero.."
			else
				return F2_poly_mod.new(0, @modulus)
			end
		end

		rv = F2_poly_mod.new(1, @modulus)
		xp = F2_poly_mod.new(@residue, @modulus)
		if e < 0
			xp = xp.recip
			e = -e
		end

		# Repeated squaring
		while (e != 0)
			if (e & 1) == 1
				rv *= xp;
			end
			e = e >> 1;
			xp *= xp;
		end
		return rv
	end

	# ----------------------------------------------------------------
	def F2_poly_mod.elements_for_modulus(m)
		if not F2_poly === m
			m = F2_poly.new(m)
		end
		max_bits = (1 << m.degree) - 1
		(0..max_bits).collect{|a| F2_poly_mod.new(F2_poly.new(a), m)}
	end
	def F2_poly_mod.units_for_modulus(m) # m should be F2_poly
		if not F2_poly === m
			m = F2_poly.new(m)
		end
		max_bits = (1 << m.degree) - 1
		units = []
		(0..max_bits).each do |j|
			a = F2_poly.new(j)
			if m.gcd(a).one?
				units.push F2_poly_mod.new(a, m)
			end
		end
		units
	end

end
