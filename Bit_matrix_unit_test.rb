#!/usr/bin/ruby -Wall

# ================================================================
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2011
# ================================================================

require 'Bit_matrix.rb'
require 'test/unit'

class Bit_matrixUnitTest < Test::Unit::TestCase

	def test_to_s
		Bit_matrix.set_binary_output
		assert_equal("0000\n0000\n0000\n", Bit_matrix.new(3,4).to_s)
		Bit_matrix.set_hex_output
		assert_equal("0\n0\n0\n", Bit_matrix.new(3,4).to_s)
	end

	def test_row_reduce
		Bit_matrix.set_binary_output

		a = Bit_matrix.new(4,4)
		assert_equal("0000\n0000\n0000\n0000\n", a.to_s)

		a.row_reduce_below
		assert_equal("0000\n0000\n0000\n0000\n", a.to_s)

		a.row_echelon_form
		assert_equal("0000\n0000\n0000\n0000\n", a.to_s)


		a = Bit_matrix.new(4,4)
		a[0][0] = 1
		a[0][1] = 1
		a[1][0] = 1
		a[3][2] = 1
		assert_equal("0011\n0001\n0000\n0100\n", a.to_s)

		a.row_reduce_below
		assert_equal("0011\n0010\n0100\n0000\n", a.to_s)

		a.row_echelon_form
		assert_equal("0001\n0010\n0100\n0000\n", a.to_s)

		#assert_equal("0000\n0000\n0000\n", Bit_matrix.new(3,4).to_s)
		#Bit_matrix.set_hex_output
		#assert_equal("0\n0\n0\n", Bit_matrix.new(3,4).to_s)
	end

	def test_rank
		Bit_matrix.set_binary_output
		a = Bit_matrix.new(4,4)
		assert_equal(0, a.rank)
		a[1][0] = 1
		a[0][1] = 1
		assert_equal(2, a.rank)

		a = Bit_matrix.new(4,4)
		assert_equal(0, a.rank)
		a[0][0] = 1
		a[1][1] = 1
		a[2][2] = 1
		a[3][3] = 1
		assert_equal(4, a.rank)
	end

	def test_rank_rr
		Bit_matrix.set_binary_output
		a = Bit_matrix.new(4,4)
		assert_equal(0, a.rank_rr)
		a[0][0] = 1
		a[1][3] = 1
		assert_equal(2, a.rank_rr)
	end

	def test_kernel_basis
		Bit_matrix.set_binary_output
		a = Bit_matrix.new(4,4)
		assert_equal(0, a.rank_rr)
		a[0][0] = 1
		a[1][1] = 1
		a[2][2] = 1
		a[3][3] = 1
		assert_equal(nil, a.kernel_basis)

		a = Bit_matrix.new(4,4)
		assert_equal(0, a.rank_rr)
		a[0][0] = 1
		a[1][1] = 1
		a[2][2] = 1
		assert_equal("1000\n", a.kernel_basis.to_s)

		a = Bit_matrix.new(4,4)
		assert_equal(0, a.rank_rr)
		a[0][0] = 1
		a[1][1] = 1
		a[3][3] = 1
		assert_equal("0100\n", a.kernel_basis.to_s)

		a = Bit_matrix.new(4,4)
		assert_equal(0, a.rank_rr)
		a[0][0] = 1
		a[2][2] = 1
		a[3][3] = 1
		assert_equal("0010\n", a.kernel_basis.to_s)

		a = Bit_matrix.new(4,4)
		assert_equal(0, a.rank_rr)
		a[1][1] = 1
		a[2][2] = 1
		a[3][3] = 1
		assert_equal("0001\n", a.kernel_basis.to_s)

	end

end
