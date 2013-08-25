#!/usr/bin/ruby

# ================================================================
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2004
# Ported to Ruby 2011-02-10
# ================================================================

# Algorithms mostly due to:
# aggregate.org/MAGIC:

module Bit_arith

# ================================================================
# 32-bit versions

def Bit_arith.msb32(x)
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);
    return(x & ~(x >> 1));
end

def Bit_arith.lsb32(x)
	x & -x
end

# aggregate-magic pop count:
# def Bit_arith.ones32(x)
#     x -= ((x >> 1) & 0x55555555);
#     x = (((x >> 2) & 0x33333333) + (x & 0x33333333));
#     x = (((x >> 4) + x) & 0x0f0f0f0f);
#     x += (x >> 8);
#     x += (x >> 16);
#     return(x & 0x0000003f);
# end
# MIT HAKMEM pop count:
def Bit_arith.ones32(x)
	r = x - ((x >> 1) & 033333333333) - ((x >> 2) & 011111111111)
	return ((r + (r >> 3)) & 030707070707) % 63;
end

def Bit_arith.floor_log2_32(x)
     x |= (x >> 1);
     x |= (x >> 2);
     x |= (x >> 4);
     x |= (x >> 8);
     x |= (x >> 16);
     return(Bit_arith.ones32(x) - 1); # If log(0) is to be -1
     #return(Bit_arith.ones32(x >> 1)); # If log(0) is to be 0
end

def Bit_arith.msb_pos_32(x)
	Bit_arith.floor_log2_32(Bit_arith.msb32(x))
end
def Bit_arith.lsb_pos_32(x)
	Bit_arith.floor_log2_32(Bit_arith.lsb32(x))
end

# ================================================================
# Arbitrary-word-length versions

def Bit_arith.msb_pos(x)
	if x == 0
		return -1
	elsif x < 0
		raise "Bit_arith.msb_pos:  input must not be negative; got #{x}."
	end

	count = 0
	while true
		word = x & 0xffffffff
		x >>= 32
		p = Bit_arith.msb_pos_32(word)
		if x == 0
			return p + count
		end
		count += 32
	end
end

def Bit_arith.msb(x)
	shift_amount = 1
	xshift = x >> shift_amount
	while xshift > 0
		x |= xshift
		shift_amount <<= 1
		xshift = x >> shift_amount
	end
    # x |= (x >> 1);
    # x |= (x >> 2);
    # x |= (x >> 4);
    # x |= (x >> 8);
    # x |= (x >> 16);
	# ...
    return(x & ~(x >> 1));
end

def Bit_arith.lsb(x)
	x & -x
end

def Bit_arith.ones(x)
	if x < 0
		raise "Bit_arith.ones:  input must not be negative; got #{x}."
	end

	count = 0
	while x != 0
		word = x & 0xffffffff
		x >>= 32
		count += Bit_arith.ones32(word)
	end
	return count
end

# We assume there's only a single bit set
def Bit_arith.exact_log2(x)
	# Avoid infinite loop, just in case we are misinvoked.
	# If we are invoked with negative input, our answer will be wrong.
	# Better that than an infinite loop.
	if x == 0
		#raise "Bit_arith.exact_log2:  input must not be zero."
		return -1
	end

	count = 0
	while true
		word = x & 0xffffffff
		if word != 0
			return count + Bit_arith.floor_log2_32(word)
		end
		x >>= 32
		count += 32
	end
end

def Bit_arith.lsb_pos(x)
	if x == 0
		return -1
	end
	Bit_arith.exact_log2(Bit_arith.lsb(x))
end

end # module
