#!/usr/bin/ruby -Wall

# ================================================================
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2011
# ================================================================

require 'F2_poly_mod.rb'
require 'test/unit'

class F2_poly_mod_unit_test < Test::Unit::TestCase

	def test_to_s
		assert_equal("0",  F2_poly_mod.new(0, 3).to_s)
		assert_equal("0",  F2_poly_mod.new(3, 3).to_s)
		assert_equal("0",  F2_poly_mod.new("c", 3).to_s)

		assert_equal("1",  F2_poly_mod.new(0x1c, 3).to_s)
		assert_equal("1",  F2_poly_mod.new("1c", 3).to_s)
		assert_equal("deadbeef",  F2_poly_mod.new("deadbeef", "1000000af").to_s)
		assert_equal("deadbeef",  F2_poly_mod.new(0xdeadbeef, "1000000af").to_s)
	end

	def test_double_equals
		assert_equal(F2_poly_mod.new(3, 0x13), F2_poly_mod.new(3, 0x13))
		assert_equal(F2_poly_mod.new(3, 0x13), F2_poly_mod.new(0xef2, 0x13))
		assert_not_equal(F2_poly_mod.new(3, 0x13), F2_poly_mod.new(4, 0x13))
	end

	def test_zero
		assert_equal(true, F2_poly_mod.new(0, 0x13).zero?)
		assert_not_equal(true, F2_poly_mod.new(1, 0x13).zero?)
		assert_equal(true, F2_poly_mod.new(0x130, 0x13).zero?)
	end

	def test_one
		assert_equal(true, F2_poly_mod.new(1, 0x13).one?)
		assert_not_equal(true, F2_poly_mod.new(0, 0x13).one?)
		assert_equal(true, F2_poly_mod.new(0x131, 0x13).one?)
	end

	def test_plus
		r = F2_poly.new(0x13)
		assert_equal(F2_poly_mod.new(0, r), F2_poly_mod.new(3, r) + F2_poly_mod.new(3, r))
		assert_equal(F2_poly_mod.new(7, r), F2_poly_mod.new(3, r) + F2_poly_mod.new(4, r))
	end

	def test_minus
		r = F2_poly.new(0x13)
		assert_equal(F2_poly_mod.new(0, r), F2_poly_mod.new(3, r) + F2_poly_mod.new(3, r))
		assert_equal(F2_poly_mod.new(7, r), F2_poly_mod.new(3, r) + F2_poly_mod.new(4, r))
	end

	def test_unary_minus
		r = F2_poly.new(0x13)
		assert_equal(F2_poly_mod.new(0, r), -F2_poly_mod.new(0, r))
		assert_equal(F2_poly_mod.new(7, r), -F2_poly_mod.new(7, r))
	end

	def test_mul
		r = F2_poly.new(0x13)
		assert_equal(F2_poly_mod.new(0, r), F2_poly_mod.new(0, r) * F2_poly_mod.new(0, r))
		assert_equal(F2_poly_mod.new(0, r), F2_poly_mod.new(0, r) * F2_poly_mod.new(7, r))
		assert_equal(F2_poly_mod.new(0, r), F2_poly_mod.new(6, r) * F2_poly_mod.new(0, r))

		assert_equal(F2_poly_mod.new(6, r), F2_poly_mod.new(2, r) * F2_poly_mod.new(3, r))

		assert_equal(F2_poly_mod.new(1, r), F2_poly_mod.new(6, r) * F2_poly_mod.new(7, r))
		assert_equal(F2_poly_mod.new(1, r), F2_poly_mod.new(7, r) * F2_poly_mod.new(6, r))

		r = F2_poly.new(0x1000000af) # Irreducible
		a = F2_poly.new(0xdeadbeef)
		b = F2_poly.new(0xcafefeed)
		assert_equal(F2_poly_mod.new(0x2dc86e82, r), F2_poly_mod.new(a, r) * F2_poly_mod.new(b, r))

		r = F2_poly.new(0x1000000ae) # Reducible
		a = F2_poly.new(0xdeadbeef)
		b = F2_poly.new(0xcafefeed)
		assert_equal(F2_poly_mod.new(0x72375209, r), F2_poly_mod.new(a, r) * F2_poly_mod.new(b, r))
	end

	def test_unary_recip
		r = F2_poly.new(0x13)
		assert_equal(F2_poly_mod.new(1, r), F2_poly_mod.new(1, r).recip)
		assert_equal(F2_poly_mod.new(6, r), F2_poly_mod.new(7, r).recip)
		assert_equal(F2_poly_mod.new(7, r), F2_poly_mod.new(6, r).recip)

		r = F2_poly.new(0x1000000af) # Irreducible
		a = F2_poly.new(0xdeadbeef)
		b = F2_poly.new(0xcafefeed)
		assert_equal(F2_poly_mod.new(0x60f48a73, r), F2_poly_mod.new(a, r).recip)
		assert_equal(F2_poly_mod.new(0xc7bc3485, r), F2_poly_mod.new(b, r).recip)
	end

	def test_div
		r = F2_poly.new(0x13)
		assert_equal(F2_poly_mod.new(0, r), F2_poly_mod.new(0, r) / F2_poly_mod.new(1, r))
		assert_equal(F2_poly_mod.new(0, r), F2_poly_mod.new(0, r) / F2_poly_mod.new(7, r))

		assert_equal(F2_poly_mod.new(2, r), F2_poly_mod.new(6, r) / F2_poly_mod.new(3, r))
		assert_equal(F2_poly_mod.new(3, r), F2_poly_mod.new(6, r) / F2_poly_mod.new(2, r))
		assert_equal(F2_poly_mod.new(0xf, r), F2_poly_mod.new(2, r) / F2_poly_mod.new(3, r))

		assert_equal(F2_poly_mod.new(7, r), F2_poly_mod.new(1, r) / F2_poly_mod.new(6, r))

		r = F2_poly.new(0x1000000af) # Irreducible
		a = F2_poly.new(0xdeadbeef)
		b = F2_poly.new(0xcafefeed)
		assert_equal(F2_poly_mod.new(0xe35132a3, r), F2_poly_mod.new(a, r) / F2_poly_mod.new(b, r))
	end

	def test_exp
		r = F2_poly.new(0x13)
		assert_raise(RuntimeError) {F2_poly_mod.new(0, r) **  0}
		assert_raise(RuntimeError) {F2_poly_mod.new(0, r) ** -1}
		assert_equal(F2_poly_mod.new(0, r), F2_poly_mod.new(0, r) ** 1)
		assert_equal(F2_poly_mod.new(0, r), F2_poly_mod.new(0, r) ** 2)

		assert_raise(RuntimeError) {F2_poly_mod.new(2, 8) ** -1}

		assert_equal(F2_poly_mod.new(1, 8), F2_poly_mod.new(2, 8) ** 0)
		assert_equal(F2_poly_mod.new(2, 8), F2_poly_mod.new(2, 8) ** 1)
		assert_equal(F2_poly_mod.new(4, 8), F2_poly_mod.new(2, 8) ** 2)
		assert_equal(F2_poly_mod.new(0, 8), F2_poly_mod.new(2, 8) ** 3)
		assert_equal(F2_poly_mod.new(0, 8), F2_poly_mod.new(2, 8) ** 4)

		a = F2_poly_mod.new(2, 0x13)
		exp_and_rvs = [
			[-20,  0x7],
			[-19,  0xe],
			[-18,  0xf],
			[-17,  0xd],
			[-16,  0x9],
			[-15,  0x1],
			[-14,  0x2],
			[-13,  0x4],
			[-12,  0x8],
			[-11,  0x3],
			[-10,  0x6],
			[-9,   0xc],
			[-8,   0xb],
			[-7,   0x5],
			[-6,   0xa],
			[-5,   0x7],
			[-4,   0xe],
			[-3,   0xf],
			[-2,   0xd],
			[-1,   0x9],
			[0,    0x1],
			[1,    0x2],
			[2,    0x4],
			[3,    0x8],
			[4,    0x3],
			[5,    0x6],
			[6,    0xc],
			[7,    0xb],
			[8,    0x5],
			[9,    0xa],
			[10,   0x7],
			[11,   0xe],
			[12,   0xf],
			[13,   0xd],
			[14,   0x9],
			[15,   0x1],
			[16,   0x2],
			[17,   0x4],
			[18,   0x8],
			[19,   0x3],
			[20,   0x6]]
		exp_and_rvs.each {|exp, rv| assert_equal(F2_poly_mod.new(rv, r), a **exp)}
	end

	def test_element_listers
		assert_equal("01234567",
			F2_poly_mod.elements_for_modulus(0xb).to_s)
		assert_equal("1bd",
			F2_poly_mod.units_for_modulus(0x12).to_s)
	end
end
