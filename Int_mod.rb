#!/usr/bin/ruby

# ================================================================
# John Kerl
# kerl.john.r@gmail.com
# 2011-02-07
# First Ruby module! :)
# ================================================================
# Please see LICENSE.txt in the same directory as this file.
# Copyright (c) 2004
# ================================================================

require 'Int_arith.rb'

class Int_mod
	# ----------------------------------------------------------------
	def initialize(residue, modulus)
		if String === residue
			@residue = Integer(residue)
		else
			@residue = residue
		end
		if String === modulus
			@modulus = Integer(modulus)
		else
			@modulus = modulus
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

	# ----------------------------------------------------------------
	def +(other)
		Int_mod.new((@residue + other.residue) % @modulus, @modulus)
	end

	def -(other)
		Int_mod.new((@residue - other.residue) % @modulus, @modulus)
	end

	def -@
		Int_mod.new((-@residue) % @modulus, @modulus)
	end

	def *(other)
		Int_mod.new((@residue * other.residue) % @modulus, @modulus)
	end

	def recip
		Int_mod.new(Int_arith.intmodrecip(@residue, @modulus), @modulus)
	end

	def /(other)
		self * other.recip
	end

	def **(e)
		if @residue == 0
			if e == 0
				raise "Int_mod:  0**0 undefined."
			elsif e < 0
				raise "Int_mod **:  division by zero.."
			else
				return Int_mod.new(0, @modulus)
			end
		end

		rv = Int_mod.new(1, @modulus)
		xp = Int_mod.new(@residue, @modulus)
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

	def Int_mod.random(m)
		rand(m)
	end

	# ----------------------------------------------------------------
	def Int_mod.elements_for_modulus(m)
		(0..(m-1)).collect{|a| Int_mod.new(a, m)}
	end
	def Int_mod.units_for_modulus(m)
		units = []
		(0..(m-1)).each do |a|
			if Int_arith.gcd(a, m) == 1
				units.push Int_mod.new(a, m)
			end
		end
		units
	end
end
