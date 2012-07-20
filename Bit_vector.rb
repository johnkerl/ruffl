#!/usr/bin/ruby -Wall

# ================================================================
# This software is released under the terms of the GNU GPL.
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2004
# Ported to Ruby 2011-02-10
# ================================================================

require 'Bit_arith.rb'

class Bit_vector

	# ------------------------------------------------------------
	def initialize(init_num_elements)
		if (init_num_elements <= 0)
			raise "Bit_vector:  size must be > 0; got #{init_num_elements}.  Exiting."
		end
		@num_bits = init_num_elements
		@bits = 0 # Let Ruby do the dynamic sizing of the integer.
	end
	attr_reader   :num_bits
	attr_accessor :bits

	# ------------------------------------------------------------
	# xxx note bit position zero appears at the right.
	# xxx esp. the identity mx appears as
	# 01
	# 10
	# xxx re-think the ordering  for the factorizer ... *after* the port
	# is complete. :)

	@@write_hex = false
	def Bit_vector.set_hex_output
		@@write_hex = true
	end
	def Bit_vector.set_binary_output
		@@write_hex = false
	end

	def to_s()
		if @@write_hex == true
			"%0*x" % [(@num_bits+3) >> 2, @bits]
		else
			"%0*b" % [@num_bits, @bits]
		end
	end

	# ----------------------------------------------------------------
	def [](j)
		if (j < 0) || (j >= @num_bits)
			raise "Index #{j} out of bounds 0..#{@num_bits-1}"
		end
		(@bits >> j) & 1
	end

	def []=(j, v)
		if (j < 0) || (j >= @num_bits)
			raise "Index #{j} out of bounds 0..#{@num_bits-1}"
		end
		if (v & 1) == 1
			@bits |= 1 << j
		else
			@bits &= ~(1 << j)
		end
	end

	def toggle_element(j)
		if (j < 0) || (j >= @num_bits)
			raise "Index #{j} out of bounds 0..#{@num_bits-1}"
		end
		@bits ^= 1 << j
	end

	# ----------------------------------------------------------------
	# For use by the row-reduction algorithm in Bit_matrix.

	def find_leader_pos
		Bit_arith.lsb_pos(@bits)

		# Much slower:
		# mask = 1
		# count = 0
		# while count < @num_bits
		#		if (@bits & mask) != 0
		#		return count
		#	end
		#	mask <<= 1
		#	count += 1
		# end
		# return -1
	end


	## ----------------------------------------------------------------
	## This is componentwise multiplication (u * v), useful for implementing
	## direct products of rings.
	##
	## Use dot() (e.g. u.dot(v)) for inner product, or tmatrix's outer() (e.g.
	## tmatrix::outer(u, v)) for outer product.
	#
	#bit_vector_t bit_vector_t::operator*(
	#	bit_vector_t that)
	#{
	#	this->check_equal_lengths(that)
	#	bit_vector_t rv(this->num_bits)
	#	for (int i = 0; i < this->num_words; i++)
	#		rv.words[i] = this->words[i] & that.words[i]
	#	return rv
	#}
	#
	## ----------------------------------------------------------------
	#bit_t bit_vector_t::dot(
	#	bit_vector_t that)
	#{
	#	if (this->num_bits != that.num_bits)
	#		this->check_equal_lengths(that)
	#	unsigned accum = 0
	#	for (int i = 0; i < this->num_words; i++)
	#		accum ^= this->words[i] & that.words[i]
	#	int num_ones = count_one_bits((unsigned char *)&accum, sizeof(accum))
	#	bit_t rv(num_ones & 1)
	#	return rv
	#}
	#
	## ----------------------------------------------------------------
	#void bit_vector_t::check_equal_lengths(bit_vector_t & that)
	#{
	#	if (this->num_bits != that.num_bits) {
	#		raise
	#			<< "bit_vector_t operator+():  Incompatibly sized "
	#			<< "arguments (" << this->num_bits << ", "
	#			<< that.num_bits << ")." << std::endl
	#	}
	#}
	#
	## ----------------------------------------------------------------
	#void bit_vector_t::bounds_check(int index)
	#{
	#	if ((index < 0) || (index >= this->num_bits)) {
	#		raise
	#			<< "bit_vector_t array operator: index "
	#			<< index
	#			<< " out of bounds "
	#			<< 0
	#			<< ":"
	#			<< (this->num_bits - 1)
	#			<< std::endl
	#	}
	#}

end
