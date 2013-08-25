#!/usr/bin/ruby -Wall

# ================================================================
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2011
# ================================================================

require 'Bit_vector.rb'
require 'test/unit'

class Bit_vectorUnitTest < Test::Unit::TestCase

	def test_to_s
		Bit_vector.set_binary_output
		assert_equal("0",      Bit_vector.new(1).to_s)
		assert_equal("00",     Bit_vector.new(2).to_s)
		assert_equal("000",    Bit_vector.new(3).to_s)
		assert_equal("0000",   Bit_vector.new(4).to_s)
		assert_equal("00000",  Bit_vector.new(5).to_s)
		assert_equal("000000", Bit_vector.new(6).to_s)

		Bit_vector.set_hex_output
		assert_equal("0",  Bit_vector.new(1).to_s)
		assert_equal("0",  Bit_vector.new(2).to_s)
		assert_equal("0",  Bit_vector.new(3).to_s)
		assert_equal("0",  Bit_vector.new(4).to_s)
		assert_equal("00", Bit_vector.new(5).to_s)
		assert_equal("00", Bit_vector.new(6).to_s)
	end

	def test_brackets_and_toggle
		Bit_vector.set_binary_output
		v = Bit_vector.new(8)
		assert_equal("00000000", v.to_s)

		# xxx note right to left ...
		v[0] = 1; assert_equal("00000001", v.to_s)
		v[7] = 1; assert_equal("10000001", v.to_s)
		v[6] = 1; assert_equal("11000001", v.to_s)
		v.toggle_element(6); assert_equal("10000001", v.to_s)
		v.toggle_element(6); assert_equal("11000001", v.to_s)
		v.toggle_element(6); assert_equal("10000001", v.to_s)

		assert_raise(RuntimeError) {v[ 8] = 1}
		assert_raise(RuntimeError) {v[ 8] = 0}
		assert_raise(RuntimeError) {v[-1] = 1}
		assert_raise(RuntimeError) {v[-1] = 0}
	end

	def test_find_leader_pos
		Bit_vector.set_binary_output
		v = Bit_vector.new(8)
		assert_equal(-1, v.find_leader_pos)

		v[0] = 1; assert_equal(0, v.find_leader_pos)
		v[4] = 1; assert_equal(0, v.find_leader_pos)
		v[5] = 1; assert_equal(0, v.find_leader_pos)
		v[0] = 0; assert_equal(4, v.find_leader_pos)
	end

end
