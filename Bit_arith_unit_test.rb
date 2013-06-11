#!/usr/bin/ruby -Wall

# ================================================================
# This software is released under the terms of the GNU GPL.
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2011
# ================================================================

require 'Bit_arith.rb'
require 'test/unit'

class Bit_arith_unit_test < Test::Unit::TestCase

	# ----------------------------------------------------------------
	def test_msb32
		assert_equal(0,          Bit_arith.msb32(0x00000000))
		assert_equal(1,          Bit_arith.msb32(0x00000001))
		assert_equal(2,          Bit_arith.msb32(0x00000002))
		assert_equal(2,          Bit_arith.msb32(0x00000003))
		assert_equal(4,          Bit_arith.msb32(0x00000004))
		assert_equal(0x80,       Bit_arith.msb32(0x000000aa))
		assert_equal(0x80,       Bit_arith.msb32(0x000000ff))
		assert_equal(0x8000,     Bit_arith.msb32(0x0000beef))
		assert_equal(0x80000000, Bit_arith.msb32(0xdeadbeef))
	end

	def test_msb_pos_32
		assert_equal(-1, Bit_arith.msb_pos_32(0x00000000))
		assert_equal(0,  Bit_arith.msb_pos_32(0x00000001))
		assert_equal(1,  Bit_arith.msb_pos_32(0x00000002))
		assert_equal(1,  Bit_arith.msb_pos_32(0x00000003))
		assert_equal(2,  Bit_arith.msb_pos_32(0x00000004))
		assert_equal(7,  Bit_arith.msb_pos_32(0x000000aa))
		assert_equal(7,  Bit_arith.msb_pos_32(0x000000ff))
		assert_equal(15, Bit_arith.msb_pos_32(0x0000beef))
		assert_equal(31, Bit_arith.msb_pos_32(0xdeadbeef))
	end

	def test_lsb32
		assert_equal(0, Bit_arith.lsb32(0x00000000))
		assert_equal(1, Bit_arith.lsb32(0x00000001))
		assert_equal(2, Bit_arith.lsb32(0x00000002))
		assert_equal(1, Bit_arith.lsb32(0x00000003))
		assert_equal(4, Bit_arith.lsb32(0x00000004))
		assert_equal(2, Bit_arith.lsb32(0x000000aa))
		assert_equal(1, Bit_arith.lsb32(0x000000ff))
		assert_equal(1, Bit_arith.lsb32(0x0000beef))
		assert_equal(1, Bit_arith.lsb32(0xdeadbeef))
	end

	def test_lsb_pos_32
		assert_equal(-1, Bit_arith.lsb_pos_32(0x00000000))
		assert_equal(0,  Bit_arith.lsb_pos_32(0x00000001))
		assert_equal(1,  Bit_arith.lsb_pos_32(0x00000002))
		assert_equal(0,  Bit_arith.lsb_pos_32(0x00000003))
		assert_equal(2,  Bit_arith.lsb_pos_32(0x00000004))
		assert_equal(1,  Bit_arith.lsb_pos_32(0x000000aa))
		assert_equal(0,  Bit_arith.lsb_pos_32(0x000000ff))
		assert_equal(0,  Bit_arith.lsb_pos_32(0x0000beef))
		assert_equal(0,  Bit_arith.lsb_pos_32(0xdeadbeef))
	end

	def test_ones32
		assert_equal(0,  Bit_arith.ones32(0x00000000))
		assert_equal(1,  Bit_arith.ones32(0x00000001))
		assert_equal(1,  Bit_arith.ones32(0x00000002))
		assert_equal(2,  Bit_arith.ones32(0x00000003))
		assert_equal(1,  Bit_arith.ones32(0x00000004))
		assert_equal(4,  Bit_arith.ones32(0x000000aa))
		assert_equal(8,  Bit_arith.ones32(0x000000ff))
		assert_equal(13, Bit_arith.ones32(0x0000beef))
		assert_equal(24, Bit_arith.ones32(0xdeadbeef))
	end

	def test_floor_log2_32
		assert_equal(-1, Bit_arith.floor_log2_32(0x00000000))
		assert_equal(0,  Bit_arith.floor_log2_32(0x00000001))
		assert_equal(1,  Bit_arith.floor_log2_32(0x00000002))
		assert_equal(1,  Bit_arith.floor_log2_32(0x00000003))
		assert_equal(2,  Bit_arith.floor_log2_32(0x00000004))
		assert_equal(7,  Bit_arith.floor_log2_32(0x000000aa))
		assert_equal(7,  Bit_arith.floor_log2_32(0x000000ff))
		assert_equal(15, Bit_arith.floor_log2_32(0x0000beef))
		assert_equal(31, Bit_arith.floor_log2_32(0xdeadbeef))
	end

	# ----------------------------------------------------------------
	def test_msb
		assert_equal(0,          Bit_arith.msb(0x00000000))
		assert_equal(1,          Bit_arith.msb(0x00000001))
		assert_equal(2,          Bit_arith.msb(0x00000002))
		assert_equal(2,          Bit_arith.msb(0x00000003))
		assert_equal(4,          Bit_arith.msb(0x00000004))
		assert_equal(0x80,       Bit_arith.msb(0x000000aa))
		assert_equal(0x80,       Bit_arith.msb(0x000000ff))
		assert_equal(0x8000,     Bit_arith.msb(0x0000beef))
		assert_equal(0x80000000, Bit_arith.msb(0xdeadbeef))
		assert_equal(0x100000000, Bit_arith.msb(0x1deadbeef))
		assert_equal(0x800000000, Bit_arith.msb(0xdeadbeefe))

		(1..400).each do |x|
			v = 1 << x
			assert_equal(v, Bit_arith.msb(v))
			assert_equal(v>>1, Bit_arith.msb(v-1))
		end
	end

	# ----------------------------------------------------------------
	def test_lsb
		assert_equal(0, Bit_arith.lsb(0x00000000))
		assert_equal(1, Bit_arith.lsb(0x00000001))
		assert_equal(2, Bit_arith.lsb(0x00000002))
		assert_equal(1, Bit_arith.lsb(0x00000003))
		assert_equal(4, Bit_arith.lsb(0x00000004))
		assert_equal(2, Bit_arith.lsb(0x000000aa))
		assert_equal(1, Bit_arith.lsb(0x000000ff))
		assert_equal(1, Bit_arith.lsb(0x0000beef))
		assert_equal(1, Bit_arith.lsb(0xdeadbeef))

		(1..400).each do |x|
			v = 1 << x
			assert_equal(v, Bit_arith.lsb(v))
		end
		srand 0
		(5..400).each do |x|
			u = 1 << x
			v = (rand(64) | 1) << x
			assert_equal(u, Bit_arith.lsb(v))
		end

	end

	def test_msb_pos
		assert_equal(-1, Bit_arith.msb_pos(0x00000000))
		assert_equal(0,  Bit_arith.msb_pos(0x00000001))
		assert_equal(1,  Bit_arith.msb_pos(0x00000002))
		assert_equal(1,  Bit_arith.msb_pos(0x00000003))
		assert_equal(2,  Bit_arith.msb_pos(0x00000004))
		assert_equal(7,  Bit_arith.msb_pos(0x000000aa))
		assert_equal(7,  Bit_arith.msb_pos(0x000000ff))
		assert_equal(15,  Bit_arith.msb_pos(0x0000beef))
		assert_equal(31,  Bit_arith.msb_pos(0xdeadbeef))

		(1..400).each do |x|
			v = 1 << x
			assert_equal(x, Bit_arith.msb_pos(v))
		end
		srand 0
		(5..400).each do |x|
			v = (1 << x) | rand(1<<(x-1))
			assert_equal(x, Bit_arith.msb_pos(v))
		end
	end

	def test_lsb_pos
		assert_equal(-1, Bit_arith.lsb_pos(0x00000000))
		assert_equal(0,  Bit_arith.lsb_pos(0x00000001))
		assert_equal(1,  Bit_arith.lsb_pos(0x00000002))
		assert_equal(0,  Bit_arith.lsb_pos(0x00000003))
		assert_equal(2,  Bit_arith.lsb_pos(0x00000004))
		assert_equal(1,  Bit_arith.lsb_pos(0x000000aa))
		assert_equal(0,  Bit_arith.lsb_pos(0x000000ff))
		assert_equal(0,  Bit_arith.lsb_pos(0x0000beef))
		assert_equal(0,  Bit_arith.lsb_pos(0xdeadbeef))

		(1..400).each do |x|
			v = 1 << x
			assert_equal(x, Bit_arith.lsb_pos(v))
		end
		srand 0
		(5..400).each do |x|
			v = (rand(64) | 1) << x
			assert_equal(x, Bit_arith.lsb_pos(v))
		end
	end

	def test_ones
		assert_equal(0,  Bit_arith.ones(0x00000000))
		assert_equal(1,  Bit_arith.ones(0x00000001))
		assert_equal(1,  Bit_arith.ones(0x00000002))
		assert_equal(2,  Bit_arith.ones(0x00000003))
		assert_equal(1,  Bit_arith.ones(0x00000004))
		assert_equal(4,  Bit_arith.ones(0x000000aa))
		assert_equal(8,  Bit_arith.ones(0x000000ff))
		assert_equal(13, Bit_arith.ones(0x0000beef))
		assert_equal(24, Bit_arith.ones(0xdeadbeef))
	end

end
