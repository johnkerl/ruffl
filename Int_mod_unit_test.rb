#!/usr/bin/ruby -Wall

# ================================================================
# This software is released under the terms of the GNU GPL.
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2011
# ================================================================

require 'Int_mod.rb'
require 'test/unit'

class Int_mod_unit_test < Test::Unit::TestCase

	def test_to_s
		assert_equal("0", Int_mod.new(0, 5).to_s)
		assert_equal("0", Int_mod.new(50, 5).to_s)
		assert_equal("1", Int_mod.new(-4, 5).to_s)
		assert_equal("3", Int_mod.new("3", 5).to_s)
		assert_equal("3", Int_mod.new("8", 5).to_s)
	end

	def test_plus
		assert_equal(Int_mod.new(2,5), Int_mod.new(3,5) + Int_mod.new(4,5))
		assert_equal(Int_mod.new(0,5), Int_mod.new(9,5) + Int_mod.new(16,5))
	end

	def test_minus
		assert_equal(Int_mod.new(4,5), Int_mod.new(3,5) - Int_mod.new(4,5))
		assert_equal(Int_mod.new(3,5), Int_mod.new(9,5) - Int_mod.new(16,5))
	end

	def test_mul
		assert_equal(Int_mod.new(1,11), Int_mod.new(3,11) * Int_mod.new(4,11))
		assert_equal(Int_mod.new(2,11), Int_mod.new(6,11) * Int_mod.new(4,11))
		assert_equal(Int_mod.new(1,8),  Int_mod.new(5,8) * Int_mod.new(5,8))
	end

	def test_recip
		assert_equal(Int_mod.new( 1,11), Int_mod.new( 1,11).recip)
		assert_equal(Int_mod.new( 6,11), Int_mod.new( 2,11).recip)
		assert_equal(Int_mod.new( 4,11), Int_mod.new( 3,11).recip)
		assert_equal(Int_mod.new( 3,11), Int_mod.new( 4,11).recip)
		assert_equal(Int_mod.new( 9,11), Int_mod.new( 5,11).recip)
		assert_equal(Int_mod.new( 2,11), Int_mod.new( 6,11).recip)
		assert_equal(Int_mod.new( 8,11), Int_mod.new( 7,11).recip)
		assert_equal(Int_mod.new( 7,11), Int_mod.new( 8,11).recip)
		assert_equal(Int_mod.new( 5,11), Int_mod.new( 9,11).recip)
		assert_equal(Int_mod.new(10,11), Int_mod.new(10,11).recip)

		assert_equal(Int_mod.new( 1,8), Int_mod.new( 1,8).recip)
		assert_equal(Int_mod.new( 3,8), Int_mod.new( 3,8).recip)
		assert_equal(Int_mod.new( 5,8), Int_mod.new( 5,8).recip)
		assert_equal(Int_mod.new( 7,8), Int_mod.new( 7,8).recip)

	end

	def test_div
		assert_equal(Int_mod.new(9,11), Int_mod.new(3,11) / Int_mod.new(4,11))
		assert_equal(Int_mod.new(7,11), Int_mod.new(6,11) / Int_mod.new(4,11))
		assert_equal(Int_mod.new(1,8),  Int_mod.new(5,8) * Int_mod.new(5,8))
	end

	def test_exp
		assert_raise(RuntimeError) {Int_mod.new(0,11) ** 0}
		assert_raise(RuntimeError) {Int_mod.new(0,11) ** -1}
		assert_raise(RuntimeError) {Int_mod.new(2,12) ** -1}

		a = Int_mod.new(2, 11)
		exp_and_rvs = [
			[-10,  1],
			[ -9,  2],
			[ -8,  4],
			[ -7,  8],
			[ -6,  5],
			[ -5, 10],
			[ -4,  9],
			[ -3,  7],
			[ -2,  3],
			[ -1,  6],
			[  0,  1],
			[  1,  2],
			[  2,  4],
			[  3,  8],
			[  4,  5],
			[  5, 10],
			[  6,  9],
			[  7,  7],
			[  8,  3],
			[  9,  6]]
		exp_and_rvs.each {|exp, rv| assert_equal(Int_mod.new(rv, 11), a **exp)}
	end

	def test_element_listers
		assert_equal("0123", Int_mod.elements_for_modulus(4).to_s)
		assert_equal("13", Int_mod.units_for_modulus(4).to_s)
	end

end
