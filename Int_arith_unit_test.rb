#!/usr/bin/ruby -Wall

# ================================================================
# This software is released under the terms of the GNU GPL.
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2011
# ================================================================

require 'Int_arith.rb'
require 'test/unit'

class Int_arith_unit_test < Test::Unit::TestCase
	def test_gcd
		assert_equal(0,  Int_arith.gcd(0,   0))
		assert_equal(1,  Int_arith.gcd(1,   1))
		assert_equal(60, Int_arith.gcd(0,  60))
		assert_equal(12, Int_arith.gcd(24, 60))
		assert_equal(3,  Int_arith.gcd(24, 63))
		assert_equal(1,  Int_arith.gcd(24, 65))
	end

	def test_ext_gcd
		a = Int_arith.ext_gcd( 1,  1); e =  [ 1,  0,  1]; assert_equal(a, e)
		a = Int_arith.ext_gcd( 1,  2); e =  [ 1,  1,  0]; assert_equal(a, e)
		a = Int_arith.ext_gcd( 2,  3); e =  [ 1, -1,  1]; assert_equal(a, e)
		a = Int_arith.ext_gcd( 4,  6); e =  [ 2, -1,  1]; assert_equal(a, e)
		a = Int_arith.ext_gcd(24, 60); e =  [12, -2,  1]; assert_equal(a, e)
		a = Int_arith.ext_gcd(24, 63); e =  [ 3,  8, -3]; assert_equal(a, e)
		a = Int_arith.ext_gcd(24, 65); e =  [ 1, 19, -7]; assert_equal(a, e)

	end

	def test_eulerphi(n)
		assert_equal(0, Int_arith.eulerphi(0))
		assert_equal(0, Int_arith.eulerphi(1))
		assert_equal(1, Int_arith.eulerphi(2))
		assert_equal(2, Int_arith.eulerphi(3))
		assert_equal(2, Int_arith.eulerphi(4))
		assert_equal(4, Int_arith.eulerphi(5))
		assert_equal(2, Int_arith.eulerphi(6))
		assert_equal(6, Int_arith.eulerphi(7))
		assert_equal(4, Int_arith.eulerphi(8))
		assert_equal(2592, Int_arith.eulerphi(2701))
		assert_equal(32768, Int_arith.eulerphi(65535))
	end

	def test_intexp
		assert_equal(1, Int_arith.intexp(1,0))
		assert_equal(1, Int_arith.intexp(1,10))
		assert_equal(1, Int_arith.intexp(2,0))
		assert_equal(2, Int_arith.intexp(2,1))
		assert_equal(4, Int_arith.intexp(2,2))
		assert_equal(8, Int_arith.intexp(2,3))
		assert_equal(5764801, Int_arith.intexp(7,8))
	end

	def test_intmodexp
		assert_equal(1,  Int_arith.intmodexp(0,0,11))
		assert_equal(1,  Int_arith.intmodexp(2,0,11))
		assert_equal(2,  Int_arith.intmodexp(2,1,11))
		assert_equal(4,  Int_arith.intmodexp(2,2,11))
		assert_equal(8,  Int_arith.intmodexp(2,3,11))
		assert_equal(5,  Int_arith.intmodexp(2,4,11))
		assert_equal(10, Int_arith.intmodexp(2,5,11))
		assert_equal(9,  Int_arith.intmodexp(2,6,11))
		assert_equal(7,  Int_arith.intmodexp(2,7,11))
		assert_equal(3,  Int_arith.intmodexp(2,8,11))
		assert_equal(6,  Int_arith.intmodexp(2,9,11))
		assert_equal(1,  Int_arith.intmodexp(2,10,11))
		assert_equal(2,  Int_arith.intmodexp(2,11,11))
		assert_equal(4,  Int_arith.intmodexp(2,12,11))
		assert_equal(6,  Int_arith.intmodexp(2,-1,11))
	end

	def test_intmodrecip
		assert_equal( 1, Int_arith.intmodrecip( 1,11))
		assert_equal( 6, Int_arith.intmodrecip( 2,11))
		assert_equal( 4, Int_arith.intmodrecip( 3,11))
		assert_equal( 3, Int_arith.intmodrecip( 4,11))
		assert_equal( 9, Int_arith.intmodrecip( 5,11))
		assert_equal( 2, Int_arith.intmodrecip( 6,11))
		assert_equal( 8, Int_arith.intmodrecip( 7,11))
		assert_equal( 7, Int_arith.intmodrecip( 8,11))
		assert_equal( 5, Int_arith.intmodrecip( 9,11))
		assert_equal(10, Int_arith.intmodrecip(10,11))
		assert_equal( 1, Int_arith.intmodrecip(12,11))
		assert_equal(10, Int_arith.intmodrecip(1330,11))
	end

	def test_factorial
		assert_equal(1, Int_arith.factorial(0))
		assert_equal(1, Int_arith.factorial(1))
		assert_equal(2, Int_arith.factorial(2))
		assert_equal(6, Int_arith.factorial(3))
		assert_equal(24, Int_arith.factorial(4))
		assert_equal(120, Int_arith.factorial(5))
		assert_equal(2432902008176640000, Int_arith.factorial(20))
	end
end
