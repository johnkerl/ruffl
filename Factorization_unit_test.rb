#!/usr/bin/ruby -Wall

# ================================================================
# This software is released under the terms of the GNU GPL.
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2011
# ================================================================

require 'Factorization.rb'
require 'test/unit'

class Factorization_unit_test < Test::Unit::TestCase

	def test_insert

		finfo = Factorization.new()
		assert_equal("", finfo.to_s)

		finfo = Factorization.new()
		finfo.insert_trivial_factor(0)
		assert_equal("0", finfo.to_s)

		finfo = Factorization.new()
		finfo.insert_trivial_factor(-1)
		assert_equal("-1", finfo.to_s)

		finfo = Factorization.new()
		finfo.insert_trivial_factor(-1)
		finfo.insert_trivial_factor(-1)
		assert_equal("1", finfo.to_s)

		finfo = Factorization.new()
		finfo.insert_trivial_factor(-1)
		finfo.insert_trivial_factor(-1)
		finfo.insert_trivial_factor(-1)
		assert_equal("-1", finfo.to_s)

		finfo = Factorization.new()
		finfo.insert_factor(2)
		finfo.insert_factor(3)
		finfo.insert_factor(5, 2)
		assert_equal("2 3 5^2", finfo.to_s)

		finfo = Factorization.new()
		finfo.insert_factor(3)
		finfo.insert_factor(5)
		finfo.insert_factor(7)
		finfo.insert_factor(2)
		assert_equal("2 3 5 7", finfo.to_s)

		finfo = Factorization.new()
		finfo.insert_factor(2)
		finfo.insert_factor(3)
		finfo.insert_factor(7)
		finfo.insert_factor(5)
		assert_equal("2 3 5 7", finfo.to_s)

		finfo = Factorization.new()
		finfo.insert_factor(2)
		finfo.insert_factor(3)
		finfo.insert_factor(5, 2)
		finfo.insert_factor(2)
		finfo.insert_factor(3)
		finfo.insert_factor(2)
		assert_equal("2^3 3^2 5^2", finfo.to_s)

	end

	def test_num_factors

		finfo = Factorization.new()
		assert_equal(0, finfo.num_factors)

		finfo = Factorization.new()
		finfo.insert_factor(2)
		assert_equal(1, finfo.num_factors)

		finfo = Factorization.new()
		finfo.insert_factor(2)
		finfo.insert_factor(3)
		assert_equal(2, finfo.num_factors)

		finfo = Factorization.new()
		finfo.insert_factor(2)
		finfo.insert_factor(2)
		assert_equal(2, finfo.num_factors)

		finfo = Factorization.new()
		finfo.insert_factor(2)
		finfo.insert_factor(2)
		finfo.insert_factor(3)
		assert_equal(3, finfo.num_factors)

	end

	def test_merge
		finfo1 = Factorization.new()
		finfo2 = Factorization.new()
		finfo1.merge(finfo2)
		assert_equal("", finfo1.to_s)

		finfo1 = Factorization.new()
		finfo2 = Factorization.new()
		finfo1.insert_factor(2, 3)
		finfo1.merge(finfo2)
		assert_equal("2^3", finfo1.to_s)

		finfo1 = Factorization.new()
		finfo2 = Factorization.new()
		finfo2.insert_factor(2, 3)
		finfo1.merge(finfo2)
		assert_equal("2^3", finfo1.to_s)

		finfo1 = Factorization.new()
		finfo2 = Factorization.new()
		finfo1.insert_factor(2, 3)
		finfo1.insert_factor(3, 1)
		finfo1.insert_factor(5, 3)
		finfo2.insert_factor(7, 3)
		finfo2.insert_factor(5, 1)
		finfo1.merge(finfo2)
		assert_equal("2^3 3 5^4 7^3", finfo1.to_s)

	end

	def test_exp_all
		finfo = Factorization.new()
		finfo.exp_all(1)
		assert_equal("", finfo.to_s)

		finfo = Factorization.new()
		finfo.exp_all(2)
		assert_equal("", finfo.to_s)

		finfo = Factorization.new()
		finfo.exp_all(3)
		assert_equal("", finfo.to_s)

		finfo = Factorization.new()
		finfo.insert_factor(2)
		finfo.exp_all(3)
		assert_equal("2^3", finfo.to_s)

		finfo = Factorization.new()
		finfo.insert_factor(2,4)
		finfo.exp_all(3)
		assert_equal("2^12", finfo.to_s)

		finfo = Factorization.new()
		finfo.insert_factor(2)
		finfo.insert_factor(5, 3)
		finfo.exp_all(4)
		assert_equal("2^4 5^12", finfo.to_s)

	end

	def test_divisors
		finfo = Factorization.new()
		finfo.insert_factor(2, 3)
		finfo.insert_factor(3, 2)
		assert_equal(12, finfo.num_divisors)
		assert_equal([1,2,3,4,6,8,9,12,18,24,36,72], finfo.all_divisors)

	end

	def test_unfactor

		finfo = Factorization.new()
		assert_raise(RuntimeError) {finfo.unfactor}

		finfo = Factorization.new()
		finfo.insert_trivial_factor(0)
		assert_equal(0, finfo.unfactor)

		finfo = Factorization.new()
		finfo.insert_trivial_factor(-1)
		assert_equal(-1, finfo.unfactor)

		finfo = Factorization.new()
		finfo.insert_factor(2, 3)
		finfo.insert_factor(3, 2)
		assert_equal(72, finfo.unfactor)

		finfo = Factorization.new()
		finfo.insert_factor(2, 3)
		finfo.insert_factor(3, 2)
		finfo.insert_trivial_factor(-1)
		assert_equal(-72, finfo.unfactor)

		finfo = Factorization.new()
		finfo.insert_factor(2, 3)
		finfo.insert_factor(3, 2)
		finfo.insert_trivial_factor(-1)
		finfo.insert_trivial_factor(-1)
		assert_equal(72, finfo.unfactor)

	end

	def test_maximal_proper_divisors

		finfo = Factorization.new()
		assert_raise(RuntimeError) {finfo.maximal_proper_divisors}

		finfo = Factorization.new()
		finfo.insert_trivial_factor(0)
		assert_equal([], finfo.maximal_proper_divisors)

		finfo = Factorization.new()
		finfo.insert_trivial_factor(-1)
		assert_equal([], finfo.maximal_proper_divisors)

		finfo = Factorization.new()
		finfo.insert_factor(2, 3)
		finfo.insert_factor(3, 2)
		assert_equal([24, 36], finfo.maximal_proper_divisors)

		finfo = Factorization.new()
		finfo.insert_factor(2, 3)
		finfo.insert_factor(3, 2)
		finfo.insert_trivial_factor(-1)
		assert_equal([24, 36], finfo.maximal_proper_divisors)

		finfo = Factorization.new()
		finfo.insert_factor(2, 3)
		finfo.insert_factor(3, 2)
		finfo.insert_trivial_factor(-1)
		finfo.insert_trivial_factor(-1)
		assert_equal([24, 36], finfo.maximal_proper_divisors)

	end

end
