#!/usr/bin/ruby -Wall

# ================================================================
# This software is released under the terms of the GNU GPL.
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2011
# ================================================================

require 'Order.rb'
require 'test/unit'

class Order_unit_test < Test::Unit::TestCase

	def test_order
		assert_equal(15,  Order.mod_order(F2_poly_mod.new(0x2, 0x13)))
		assert_equal(3,   Order.mod_order(F2_poly_mod.new(0x6, 0x13)))
		assert_equal(10,  Order.mod_order(Int_mod.new(2, 11)))
		assert_equal(5,   Order.mod_order(Int_mod.new(9, 11)))
	end

	def test_max_order
		assert_equal(15,  Order.mod_max_order(F2_poly.new(0x13)))
		assert_equal(4,   Order.mod_max_order(F2_poly.new(0x11)))
		assert_equal(10,  Order.mod_max_order(11))
		assert_equal(6,   Order.mod_max_order(21))
	end

	def test_orbit
		assert_equal(
			[F2_poly_mod.new(1, 0x13)],
			Order.orbit(F2_poly_mod.new(1, 0x13)))
		assert_equal(
			[6,7,1].collect{|a| F2_poly_mod.new(a, 0x13)},
			Order.orbit(F2_poly_mod.new(6, 0x13)))
		assert_equal(
			[0x2,0x4,0x8,0x3,0x6,0xc,0xb,0x5,0xa,0x7,0xe,0xf,0xd,0x9,0x1].
				collect{|a|F2_poly_mod.new(a,0x13)},
			Order.orbit(F2_poly_mod.new(2, 0x13)))

		assert_equal(
			[Int_mod.new(1, 11)],
			Order.orbit(Int_mod.new(1, 11)))
		assert_equal(
			[10,16,13,4,19,1].collect{|a| Int_mod.new(a, 21)},
			Order.orbit(Int_mod.new(10, 21)))
		assert_equal(
			[2,4,8,5,10,9,7,3,6,1].collect{|a|Int_mod.new(a, 11)},
			Order.orbit(Int_mod.new(2, 11)))

	end

	def test_period
		assert_equal(15,  Order.F2_poly_period(0x13))
		assert_equal(15,  Order.F2_poly_period(0x19))
		assert_equal(5,   Order.F2_poly_period(0x1f))
	end

	def test_Int_mod_find_generator
		assert_equal(nil, Order.Int_mod_generator(8))
		assert_equal(2,   Order.Int_mod_generator(5))
		assert_equal(3,   Order.Int_mod_generator(7))
		assert_equal(2,   Order.Int_mod_generator(11))
		assert_equal(nil, Order.Int_mod_generator(12))
		assert_equal(3,   Order.Int_mod_generator(34))
	end

	def test_F2_poly_find_generator
		assert_equal(2,  Order.F2_poly_mod_generator(0x13).bits)
		assert_equal(2,  Order.F2_poly_mod_generator(0x19).bits)
		assert_equal(3,  Order.F2_poly_mod_generator(0x1f).bits)
	end

	def test_F2_poly_primitive
		assert_equal(false, Order.F2_poly_primitive?(0))
		assert_equal(true,  Order.F2_poly_primitive?(1))
		assert_equal(false, Order.F2_poly_primitive?(2))
		assert_equal(true,  Order.F2_poly_primitive?(3))
		assert_equal(false, Order.F2_poly_primitive?(4))
		assert_equal(true,  Order.F2_poly_primitive?(5))
		assert_equal(false, Order.F2_poly_primitive?(6))
		assert_equal(true,  Order.F2_poly_primitive?(7))

		assert_equal(true,  Order.F2_poly_primitive?(0x13))
		assert_equal(false, Order.F2_poly_primitive?(0x15))
	end

end
