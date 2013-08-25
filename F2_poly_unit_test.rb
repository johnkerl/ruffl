#!/usr/bin/ruby -Wall

# ================================================================
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2011
# ================================================================

require 'F2_poly.rb'
require 'test/unit'

class F2_poly_unit_test < Test::Unit::TestCase

	def test_to_s
		assert_equal("0",  F2_poly.new(0).to_s)
		assert_equal("1",  F2_poly.new(1).to_s)
		assert_equal("1f", F2_poly.new(0x1f).to_s)
		assert_equal("1f", F2_poly.new(31).to_s)
		F2_poly.set_binary_output
		assert_equal("11111", F2_poly.new(0x1f).to_s)
		assert_equal("11111", F2_poly.new(31).to_s)
		F2_poly.set_hex_output
		assert_equal("1f", F2_poly.new(0x1f).to_s)
		assert_equal("1f", F2_poly.new(31).to_s)
	end

	def test_double_equals
		assert_equal(F2_poly.new(0x13), F2_poly.new(0x13))
		assert_not_equal(F2_poly.new(0x13), F2_poly.new(0x14))

		assert_equal(true,  F2_poly.new(0).zero?)
		assert_equal(false, F2_poly.new(1).zero?)
		assert_equal(false, F2_poly.new(2).zero?)

		assert_equal(false, F2_poly.new(0).one?)
		assert_equal(true,  F2_poly.new(1).one?)
		assert_equal(false, F2_poly.new(2).one?)
	end

	def test_degree
		assert_equal     F2_poly.new(0).degree, F2_poly.new(0).degree
		assert_equal     F2_poly.new(0).degree, F2_poly.new(1).degree
		assert_not_equal F2_poly.new(0).degree, F2_poly.new(2).degree
		assert_not_equal F2_poly.new(0).degree, F2_poly.new(3).degree

		assert_equal     F2_poly.new(1).degree, F2_poly.new(0).degree
		assert_equal     F2_poly.new(1).degree, F2_poly.new(1).degree
		assert_not_equal F2_poly.new(1).degree, F2_poly.new(2).degree
		assert_not_equal F2_poly.new(1).degree, F2_poly.new(3).degree

		assert_not_equal F2_poly.new(2).degree, F2_poly.new(0).degree
		assert_not_equal F2_poly.new(2).degree, F2_poly.new(1).degree
		assert_equal     F2_poly.new(2).degree, F2_poly.new(2).degree
		assert_equal     F2_poly.new(2).degree, F2_poly.new(3).degree

		assert_not_equal F2_poly.new(3).degree, F2_poly.new(0).degree
		assert_not_equal F2_poly.new(3).degree, F2_poly.new(1).degree
		assert_equal     F2_poly.new(3).degree, F2_poly.new(2).degree
		assert_equal     F2_poly.new(3).degree, F2_poly.new(3).degree

		assert_equal(4, F2_poly.new(0x13).degree)
		assert_equal(8, F2_poly.new(0x11b).degree)
		assert_equal(63, F2_poly.new(0xdeadbeedcafefeed).degree)
	end

	def test_bit_set_get
		a = F2_poly.new(0); assert_equal(0, a.bits)
		a[0] = 1; assert_equal(0x01, a.bits)
		a[1] = 1; assert_equal(0x03, a.bits)
		a[2] = 1; assert_equal(0x07, a.bits)
		a[7] = 1; assert_equal(0x87, a.bits)
		a[0] = 0; assert_equal(0x86, a.bits)
		a[1] = 0; assert_equal(0x84, a.bits)
		a[2] = 0; assert_equal(0x80, a.bits)
		a[7] = 0; assert_equal(0x00, a.bits)
		a.bits = 0xfa
		assert_equal(0, a[0])
		assert_equal(1, a[1])
		assert_equal(0, a[2])
		assert_equal(1, a[3])
		assert_equal(1, a[4])
		assert_equal(1, a[5])
		assert_equal(1, a[6])
		assert_equal(1, a[7])
		assert_equal(0, a[8])
		assert_equal(0, a[88])
	end

	def test_plus
		assert_equal(F2_poly.new(0), F2_poly.new(0) + F2_poly.new(0))
		assert_equal(F2_poly.new(1), F2_poly.new(0) + F2_poly.new(1))
		assert_equal(F2_poly.new(2), F2_poly.new(0) + F2_poly.new(2))
		assert_equal(F2_poly.new(3), F2_poly.new(0) + F2_poly.new(3))

		assert_equal(F2_poly.new(1), F2_poly.new(1) + F2_poly.new(0))
		assert_equal(F2_poly.new(0), F2_poly.new(1) + F2_poly.new(1))
		assert_equal(F2_poly.new(3), F2_poly.new(1) + F2_poly.new(2))
		assert_equal(F2_poly.new(2), F2_poly.new(1) + F2_poly.new(3))

		assert_equal(F2_poly.new(2), F2_poly.new(2) + F2_poly.new(0))
		assert_equal(F2_poly.new(3), F2_poly.new(2) + F2_poly.new(1))
		assert_equal(F2_poly.new(0), F2_poly.new(2) + F2_poly.new(2))
		assert_equal(F2_poly.new(1), F2_poly.new(2) + F2_poly.new(3))

		assert_equal(F2_poly.new(3), F2_poly.new(3) + F2_poly.new(0))
		assert_equal(F2_poly.new(2), F2_poly.new(3) + F2_poly.new(1))
		assert_equal(F2_poly.new(1), F2_poly.new(3) + F2_poly.new(2))
		assert_equal(F2_poly.new(0), F2_poly.new(3) + F2_poly.new(3))
		assert_equal(F2_poly.new(0xbe3143), F2_poly.new(0xdead) + F2_poly.new(0xbeefee))
	end

	def test_minus
		assert_equal(F2_poly.new(0), F2_poly.new(0) + F2_poly.new(0))
		assert_equal(F2_poly.new(1), F2_poly.new(0) + F2_poly.new(1))
		assert_equal(F2_poly.new(2), F2_poly.new(0) + F2_poly.new(2))
		assert_equal(F2_poly.new(3), F2_poly.new(0) + F2_poly.new(3))

		assert_equal(F2_poly.new(1), F2_poly.new(1) + F2_poly.new(0))
		assert_equal(F2_poly.new(0), F2_poly.new(1) + F2_poly.new(1))
		assert_equal(F2_poly.new(3), F2_poly.new(1) + F2_poly.new(2))
		assert_equal(F2_poly.new(2), F2_poly.new(1) + F2_poly.new(3))

		assert_equal(F2_poly.new(2), F2_poly.new(2) + F2_poly.new(0))
		assert_equal(F2_poly.new(3), F2_poly.new(2) + F2_poly.new(1))
		assert_equal(F2_poly.new(0), F2_poly.new(2) + F2_poly.new(2))
		assert_equal(F2_poly.new(1), F2_poly.new(2) + F2_poly.new(3))

		assert_equal(F2_poly.new(3), F2_poly.new(3) + F2_poly.new(0))
		assert_equal(F2_poly.new(2), F2_poly.new(3) + F2_poly.new(1))
		assert_equal(F2_poly.new(1), F2_poly.new(3) + F2_poly.new(2))
		assert_equal(F2_poly.new(0), F2_poly.new(3) + F2_poly.new(3))
		assert_equal(F2_poly.new(0xbe3143), F2_poly.new(0xdead) + F2_poly.new(0xbeefee))
	end

	def test_unary_minus
		assert_equal(F2_poly.new(0), -F2_poly.new(0))
		assert_equal(F2_poly.new(7), -F2_poly.new(7))
		assert_equal(F2_poly.new(0xdeadbeedcafefeed), -F2_poly.new(0xdeadbeedcafefeed))
	end

	def test_mul
		assert_equal(F2_poly.new(0), F2_poly.new(0) * F2_poly.new(0))
		assert_equal(F2_poly.new(0), F2_poly.new(0) * F2_poly.new(0xfe45))
		assert_equal(F2_poly.new(0), F2_poly.new(0xfe45) * F2_poly.new(0))

		assert_equal(F2_poly.new(6), F2_poly.new(2) * F2_poly.new(3))
		assert_equal(F2_poly.new(0x5fff3cac4db5e98b),
			F2_poly.new(0xdeadbeef) * F2_poly.new(0xcafefeed))
	end

	def test_quot_and_rem
		assert_equal(F2_poly.new(0), F2_poly.new(0) / F2_poly.new(2))
		assert_equal(F2_poly.new(0), F2_poly.new(0) % F2_poly.new(2))

		assert_equal(F2_poly.new(0), F2_poly.new(0) / F2_poly.new(0xfe45))
		assert_equal(F2_poly.new(0), F2_poly.new(0) % F2_poly.new(0xfe45))

		assert_equal(F2_poly.new(0), F2_poly.new(3) / F2_poly.new(0xfe45))
		assert_equal(F2_poly.new(3), F2_poly.new(3) % F2_poly.new(0xfe45))

		assert_equal(F2_poly.new(2), F2_poly.new(6) / F2_poly.new(3))
		assert_equal(F2_poly.new(0), F2_poly.new(6) % F2_poly.new(3))

		assert_equal(F2_poly.new(3), F2_poly.new(6) / F2_poly.new(2))
		assert_equal(F2_poly.new(0), F2_poly.new(6) % F2_poly.new(2))

		assert_equal(F2_poly.new(0x12), F2_poly.new(0xff) / F2_poly.new(0xe))
		assert_equal(F2_poly.new(0x03), F2_poly.new(0xff) % F2_poly.new(0xe))

		assert_equal(F2_poly.new(0x1324e), F2_poly.new(0xdeadbeef) / F2_poly.new(0xcafe))
		assert_equal(F2_poly.new(0x349b),  F2_poly.new(0xdeadbeef) % F2_poly.new(0xcafe))

	end

	def test_gcd
		assert_equal(F2_poly.new(0), F2_poly.new(0).gcd(F2_poly.new(0)))
		assert_equal(F2_poly.new(3), F2_poly.new(0).gcd(F2_poly.new(3)))
		assert_equal(F2_poly.new(3), F2_poly.new(3).gcd(F2_poly.new(0)))

		assert_equal(F2_poly.new(3), F2_poly.new(6).gcd(F2_poly.new(3)))
		assert_equal(F2_poly.new(3), F2_poly.new(3).gcd(F2_poly.new(6)))

		assert_equal(F2_poly.new(5), F2_poly.new(0xdeadbeef).gcd(F2_poly.new(0xcafefeed)))
	end

	def test_lcm
		assert_equal(F2_poly.new(0x5fa), F2_poly.new(0xff).lcm(F2_poly.new(0xee)))
	end

	def test_ext_gcd
		dead = F2_poly.new(0xdead)
		beef = F2_poly.new(0xbeef)
		deaf = F2_poly.new(0xdeaf)
		beee = F2_poly.new(0xbeee)

		ag, as, at = dead.ext_gcd(beef)
		eg, es, et = F2_poly.new(1), F2_poly.new(0x1bcf), F2_poly.new(0x131e)
		assert_equal([ag, as, at], [eg, es, et])

		ag, as, at = deaf.ext_gcd(beee)
		eg, es, et = F2_poly.new(3), F2_poly.new(0x2cb1), F2_poly.new(0x3592)
		assert_equal([ag, as, at], [eg, es, et])
	end

	def test_deriv
		assert_equal(F2_poly.new(0), F2_poly.new(0).deriv)
		assert_equal(F2_poly.new(0), F2_poly.new(1).deriv)

		assert_equal(F2_poly.new(1), F2_poly.new(2).deriv)
		assert_equal(F2_poly.new(1), F2_poly.new(3).deriv)

		assert_equal(F2_poly.new(0), F2_poly.new(4).deriv)
		assert_equal(F2_poly.new(0), F2_poly.new(5).deriv)
		assert_equal(F2_poly.new(1), F2_poly.new(6).deriv)
		assert_equal(F2_poly.new(1), F2_poly.new(7).deriv)

		assert_equal(F2_poly.new(0x005), F2_poly.new(0x00f).deriv)
		assert_equal(F2_poly.new(0x005), F2_poly.new(0x01f).deriv)
		assert_equal(F2_poly.new(0x015), F2_poly.new(0x03f).deriv)
		assert_equal(F2_poly.new(0x015), F2_poly.new(0x07f).deriv)
		assert_equal(F2_poly.new(0x055), F2_poly.new(0x0ff).deriv)
		assert_equal(F2_poly.new(0x055), F2_poly.new(0x1ff).deriv)
		assert_equal(F2_poly.new(0x155), F2_poly.new(0x3ff).deriv)
		assert_equal(F2_poly.new(0x155), F2_poly.new(0x7ff).deriv)
		assert_equal(F2_poly.new(0x555), F2_poly.new(0xfff).deriv)

		assert_equal(F2_poly.new(0x000), F2_poly.new(0x010).deriv)
		assert_equal(F2_poly.new(0x010), F2_poly.new(0x020).deriv)
		assert_equal(F2_poly.new(0x000), F2_poly.new(0x040).deriv)
		assert_equal(F2_poly.new(0x040), F2_poly.new(0x080).deriv)
		assert_equal(F2_poly.new(0x000), F2_poly.new(0x100).deriv)
		assert_equal(F2_poly.new(0x100), F2_poly.new(0x200).deriv)
		assert_equal(F2_poly.new(0x000), F2_poly.new(0x400).deriv)
		assert_equal(F2_poly.new(0x400), F2_poly.new(0x800).deriv)

		assert_equal(F2_poly.new(0x0000), F2_poly.new(0x5555).deriv)
		assert_equal(F2_poly.new(0x5555), F2_poly.new(0xaaaa).deriv)
		assert_equal(F2_poly.new(0x5555), F2_poly.new(0xffff).deriv)
	end

	def test_exp
		assert_raise(RuntimeError) { F2_poly.new(0) ** 0}
		assert_raise(RuntimeError) { F2_poly.new(0) ** -1}
		assert_equal(F2_poly.new(0), F2_poly.new(0) ** 1)
		assert_equal(F2_poly.new(0), F2_poly.new(0) ** 2)

		assert_raise(RuntimeError) { F2_poly.new(0) ** -1}
		assert_raise(RuntimeError) { F2_poly.new(1) ** -1}
		assert_raise(RuntimeError) { F2_poly.new(2) ** -1}

		assert_equal(F2_poly.new(1), F2_poly.new(1) ** 2)
		assert_equal(F2_poly.new(0x10), F2_poly.new(2) ** 4)
		assert_equal(F2_poly.new(0x2dd836f172897638cd0e11a4ae0e11895be0fbff63), \
			F2_poly.new(0xbeef) ** 11) end

	def test_square_root
		assert_equal([true, F2_poly.new(0x0)], F2_poly.new(0x0).square_root)
		assert_equal([true, F2_poly.new(0x1)], F2_poly.new(0x1).square_root)
		assert_equal([true, F2_poly.new(0x3)], F2_poly.new(0x5).square_root)
		assert_equal([true, F2_poly.new(0x7)], F2_poly.new(0x15).square_root)
		assert_equal([false, nil], F2_poly.new(0x2).square_root)
	end

	def test_cmp
		a = F2_poly.new(7)
		b = F2_poly.new(8)
		assert_equal(-1, a <=> b)
		assert_equal( 0, a <=> a)
		assert_equal( 1, b <=> a)
		assert_equal(true, a < b)
		assert_equal(true, a <= b)
		assert_equal(false, a > b)
		assert_equal(false, a >= b)
		assert_equal(true, a == a)
		assert_equal(false, a == b)
	end
end
