#!/usr/bin/ruby -Wall

# ================================================================
# This software is released under the terms of the GNU GPL.
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2011
# ================================================================

require 'F2_poly_factor.rb'
require 'test/unit'

class F2_poly_factor_unit_test < Test::Unit::TestCase

	def test_pre_berlekamp
		# Degree 0 or 1, or squares thereof (not requiring Berlekamp):
		assert_equal("0",   F2_poly_factor.factor("0").to_s)
		assert_equal("1",   F2_poly_factor.factor("1").to_s)
		assert_equal("2",   F2_poly_factor.factor("2").to_s)
		assert_equal("3",   F2_poly_factor.factor("3").to_s)
		assert_equal("2^2", F2_poly_factor.factor("4").to_s)
		assert_equal("2^4", F2_poly_factor.factor("10").to_s)
		assert_equal("2^8", F2_poly_factor.factor("100").to_s)
		assert_equal("2^64",
			F2_poly_factor.factor("10000000000000000").to_s)
	end

	def test_irrs
		# Irreducibles:
		assert_equal("b",   F2_poly_factor.factor("b").to_s)
		assert_equal("11b",   F2_poly_factor.factor("11b").to_s)
		assert_equal("1000000af",
			F2_poly_factor.factor("1000000af").to_s)
	end

	def test_sq_irrs
		# Squares of irreducibles:
		assert_equal("11b^2", F2_poly_factor.factor("10145").to_s)
	end

	def test_sqfree
		# Products of distinct irreducibles:
		assert_equal("2 3", F2_poly_factor.factor("6").to_s)
	end

	def test_medium
		# Others:
		assert_equal("2^2 3 7 13^2 19", \
			F2_poly_factor.factor("34a54").to_s)
	end

	def test_many
		out_ins = [
			["171",                               "171"],
			["2^2 3^2 13",                        "17c"],
			["2^5 3^3",                           "1e0"],
			["3 f7",                              "119"],
			["14d",                               "14d"],
			["2^2 7 19",                          "13c"],
			["3 7 25",                            "10d"],
			["3^2 5b",                            "137"],
			["2 7 2f",                            "19a"],
			["3^2 7 19",                          "173"],
			["2 7 2493b",                         "1fff42"],
			["7 66b81",                           "131287"],
			["2 b 13 3b d3",                      "153d02"],
			["2 33b 597",                         "1ce122"],
			["2 3^2 2a02b",                       "10410e"],
			["3d 57 323",                         "15f505"],
			["2 7 b 7d79",                        "100b92"],
			["3 3b 5b1d",                         "1528c1"],
			["2^5 75 24b",                        "1e8ee0"],
			["168507",                            "168507"],
			["d^2 e5 115800ce49",                 "34798af04231d"],
			["2 b d 3b 177 21cdb913",             "20a22af1ac182"],
			["2 f04b1 4bdd52e29 57ab7dcad",       "1b4180d415d94613c4d8c2a"],
			["2^5 3 b 57387 355d773 1a9f7c6177",  "1d93f54c8aadf94cea78160"],
			["ab 1d3d 2645b6b6d6191e52d1",        "19180b9bfb8623e4e8a853f"],
			["1b070eaa8bcda8b1634b6d9",           "1b070eaa8bcda8b1634b6d9"]]
		out_ins.each do |out_in|
			output, input = out_in
			assert_equal(output, F2_poly_factor.factor(input).to_s)
		end
	end

	def test_irr
		assert_equal(true,  F2_poly_factor.irr?("3"))
		assert_equal(false, F2_poly_factor.irr?("12"))
		assert_equal(true,  F2_poly_factor.irr?("13"))
	end

	def test_lowest_irrs
		in_outs = [
		    [ 1, "3"],
		    [ 2, "7"],
		    [ 3, "b"],
		    [ 4, "13"],
		    [ 5, "25"],
		    [ 6, "43"],
		    [ 7, "83"],
		    [ 8, "11b"],
		    [ 9, "203"],
		    [10, "409"],
		    [11, "805"],
		    [12, "1009"],
		    [13, "201b"],
		    [14, "4021"],
		    [15, "8003"],
		    [16, "1002b"],
		    [17, "20009"],
		    [18, "40009"],
		    [19, "80027"],
		    [20, "100009"],
		    [21, "200005"],
		    [22, "400003"],
		    [23, "800021"],
		    [24, "100001b"],
		    [25, "2000009"],
		    [26, "400001b"],
		    [27, "8000027"],
		    [28, "10000003"],
		    [29, "20000005"],
		    [30, "40000003"],
		    [31, "80000009"],
		    [32, "10000008d"]]
		in_outs.each do |in_out|
			input, output = in_out
			assert_equal(output, F2_poly_factor.lowest_irr(input).to_s)
		end
	end

	def test_totient
		assert_equal(8,  F2_poly_factor.totient(F2_poly.new(0x10)))
		assert_equal(3,  F2_poly_factor.totient(F2_poly.new(0x12)))
		assert_equal(15, F2_poly_factor.totient(F2_poly.new(0x13)))
		assert_equal(15, F2_poly_factor.totient(F2_poly.new(0x1f)))
	end

end
