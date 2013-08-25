#!/usr/bin/ruby -Wall

# ================================================================
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2011
# ================================================================

require 'Int_factor.rb'
require 'test/unit'

class Int_factor_unit_test < Test::Unit::TestCase
	def test_it
		assert_equal("0",         Int_factor.factor(0).to_s)
		assert_equal("1",         Int_factor.factor(1).to_s)

		assert_equal("-1",        Int_factor.factor(-1).to_s)
		assert_equal("-1 2",      Int_factor.factor(-2).to_s)
		assert_equal("-1 2^3",    Int_factor.factor(-8).to_s)

		assert_equal("1",         Int_factor.factor(1).to_s)
		assert_equal("2",         Int_factor.factor(2).to_s)
		assert_equal("3",         Int_factor.factor(3).to_s)
		assert_equal("2^2",       Int_factor.factor(4).to_s)
		assert_equal("5",         Int_factor.factor(5).to_s)
		assert_equal("2 3",       Int_factor.factor(6).to_s)
		assert_equal("7",         Int_factor.factor(7).to_s)
		assert_equal("2^4 3^2 5", Int_factor.factor(720).to_s)
		assert_equal("23 89",     Int_factor.factor(2047).to_s)
		assert_equal("2^11",      Int_factor.factor(2048).to_s)
		assert_equal("3 683",     Int_factor.factor(2049).to_s)
		assert_equal("7 31 151",  Int_factor.factor(32767).to_s)
	end

	def test_totient
		assert_equal(10,  Int_factor.totient(11))
		assert_equal(24,  Int_factor.totient(35))
		assert_equal(48,  Int_factor.totient(105))
		assert_equal(168, Int_factor.totient(245))
		assert_equal(192, Int_factor.totient(720))

		assert_equal(Int_factor.slow_totient(11),  Int_factor.totient(11))
		assert_equal(Int_factor.slow_totient(35),  Int_factor.totient(35))
		assert_equal(Int_factor.slow_totient(105), Int_factor.totient(105))
		assert_equal(Int_factor.slow_totient(245), Int_factor.totient(245))
		assert_equal(Int_factor.slow_totient(720), Int_factor.totient(720))
	end
end
