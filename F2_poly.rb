#!/usr/bin/ruby -Wall

# ================================================================
# This software is released under the terms of the GNU GPL.
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2004
# Ported to Ruby 2011-02-10
# ================================================================

require 'Bit_arith.rb'

class F2_poly
	# ------------------------------------------------------------
	def initialize(arg)
		if String === arg
			@bits = Integer("0x" + arg)
		elsif F2_poly === arg
			@bits = arg.bits
		else # Nominally expecting integer or quacks-like-integer.
			@bits = arg
		end
	end

	# Allow reading and writing of bits.
	attr_accessor :bits

	# ------------------------------------------------------------
	@@format = '%x'
	def F2_poly.set_hex_output
		@@format = "%x"
	end
	def F2_poly.set_binary_output
		@@format = "%b"
	end

	def to_s()
		@@format % @bits
	end
	def inspect()
		@@format % @bits
	end

	# ----------------------------------------------------------------
	def ==(other)
		@bits == other.bits
	end

	def zero?
		return @bits == 0
	end
	def nonzero?
		return @bits != 0
	end
	def one?
		return @bits == 1
	end

	def degree
		F2_poly.bit_degree(@bits)
	end

	# Getter for bit j
	def [](j)
		if ((@bits >> j) & 1) == 1
			return 1
		else
			return 0
		end
	end

	# Setter for bit j
	def []=(j, v)
		if (v & 1) == 1
			@bits |= 1 << j
		else
			@bits &= ~(1 << j)
		end
	end

	# ------------------------------------------------------------
	def +(other)
		F2_poly.new(@bits ^ other.bits)
	end
	def -(other)
		F2_poly.new(@bits ^ other.bits)
	end
	def -@
		F2_poly.new(@bits)
	end

	def *(other)
		F2_poly.new(F2_poly.bit_mul(@bits, other.bits))
	end

	def /(other)
		quot_bits, rem_bits = F2_poly.iquot_and_rem(@bits, other.bits)
		F2_poly.new(quot_bits)
	end

	def %(other)
		quot_bits, rem_bits = F2_poly.iquot_and_rem(@bits, other.bits)
		F2_poly.new(rem_bits)
	end

	def **(e)
		if @bits == 0
			if e == 0
				raise "F2_poly:  0**0 undefined."
			elsif e < 0
				raise "F2_poly **:  division by zero.."
			else
				return F2_poly.new(0)
			end
		end

		# The only element that can be reciprocated is 1.
		# Why bother?
		if e < 0
			raise "F2_poly **:  negative exponents disallowed."
		end

		rv = F2_poly.new(1)
		xp = F2_poly.new(@bits)
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
	# For sorting, which makes factorization output unique.
	def <=>(other)
		@bits <=> other.bits
	end
	def <(other)
		@bits < other.bits
	end
	def <=(other)
		@bits <= other.bits
	end
	def >(other)
		@bits > other.bits
	end
	def >=(other)
		@bits >= other.bits
	end

	# ------------------------------------------------------------
	# These are class methods, where arguments and return values are integers.
	# They help cut down on unnecessary object creation (and thus garbage
	# collection), in particular during gcd and ext_gcd.

	def F2_poly.bit_degree(bits)

		d = Bit_arith.msb_pos(bits)
		if d == -1
			return 0
		else
			return d
		end

		#d = 0
		#if bits == 0 # I define the zero polynomial to have zero degree.
		#	return 0
		#end
		#while (bits >>= 1) > 0
		#	d += 1
		#end
		#return d

	end

	def F2_poly.bit_mul(this, that)
		prod = 0
		this_deg = F2_poly.bit_degree(this)
		that_deg = F2_poly.bit_degree(that)
		prod_deg = this_deg + that_deg

		a = this
		b = that
		c = 0
		ashift = a

		for j in 0..that_deg
			if ((b >> j) & 1) == 1
				c ^= ashift
			end
			ashift <<= 1
		end
		return c
	end

	# Returns quotient, remainder
	def F2_poly.iquot_and_rem(this, that)
		if that == 0
			raise "F2_poly iquot_and_rem: division by zero."
		end
		divisor_l1_pos = F2_poly.bit_degree(that)

		if this == 0
			return 0, 0
		end
		dividend_l1_pos = F2_poly.bit_degree(this)

		l1_diff = dividend_l1_pos - divisor_l1_pos
		if (l1_diff < 0) # Dividend has lower degree than divisor.
			return 0, this
		end

		shift_divisor = that << l1_diff
		quot = 0
		rem  = this

		check_pos = dividend_l1_pos
		quot_pos = l1_diff
		while check_pos >= divisor_l1_pos
			if ((rem >> check_pos) & 1) == 1
				rem ^= shift_divisor
				quot |= 1 << quot_pos
			end
			shift_divisor >>= 1
			check_pos -= 1
			quot_pos  -= 1
		end
		return quot, rem
	end

	# ----------------------------------------------------------------
	def gcd(other)
		if @bits == 0
			return F2_poly.new(other.bits)
		end
		if other.bits == 0
			return F2_poly.new(@bits)
		end

		c = @bits
		d = other.bits
		q = 0
		r = 0

		while true
			q, r = F2_poly.iquot_and_rem(c, d)
			if r == 0
				break
			end
			c = d
			d = r
		end
		return F2_poly.new(d)
	end

	def lcm(other)
		return self * other / self.gcd(other)
	end

	# Blankinship's algorithm.
	# Returns the gcd, s, and t, where the latter are such that
	# self * s + other * t = gcd.

	def ext_gcd(other)
		if @bits == 0
			return F2_poly.new(other.bits), F2_poly.new(0), F2_poly.new(1)
		end
		if other.bits == 0
			return F2_poly.new(@bits), F2_poly.new(1), F2_poly.new(0)
		end

		sprime = 1
		t      = 1
		s      = 0
		tprime = 0
		c      = @bits
		d      = other.bits

		while true
			q, r = F2_poly.iquot_and_rem(c, d)
			if r == 0
				break
			end
			c = d
			d = r
			sprime, s = s, sprime ^ F2_poly.bit_mul(q, s)
			tprime, t = t, tprime ^ F2_poly.bit_mul(q, t)
		end
		return F2_poly.new(d), F2_poly.new(s), F2_poly.new(t)
	end

	# ----------------------------------------------------------------
	# Used by the Berlekamp factorization algorithm.

	def deriv
		mask = 0x55555555
		while (mask < bits)
			mask <<= 32
			mask |= 0x55555555
		end

		bits = @bits >> 1
		bits &= mask
		F2_poly.new(bits)
	end

	# ----------------------------------------------------------------
	# Relies on the fact that f(x^p) = f^p(x) over Fp[x]:
	#
	# in  = a4 x^4 + a2 x^2 + a0
	# out = a4 x^2 + a2 x   + a0

	# Returns [true, the square root] or [false, nil].

	def square_root
		deg = self.degree
		sqroot_bits = 0
		inbit = 1
		outbit = 1

		si = 0 # source index
		while si <= deg
			if (@bits & inbit) != 0
				sqroot_bits |= outbit
			end
			inbit <<= 1
			if (@bits & inbit) != 0
				return false, nil
			end
			inbit  <<= 1
			outbit <<= 1
			si += 2
		end
		return [true, F2_poly.new(sqroot_bits)]
	end

	# ----------------------------------------------------------------
	def F2_poly.random(degree)
		msb = 1 << degree
		F2_poly.new(msb | rand(msb))
	end

end
