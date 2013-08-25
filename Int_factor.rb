#!/usr/bin/ruby -Wall

# ================================================================
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2004
# Ported to Ruby 2011-02-10
#
# Note:  this is not a performative integer-factoring algorithm.  It's for
# trivial use, as well as to help me test infrastructure for my f2poly
# (Berlekamp) factorization code.
# ================================================================

require 'Factorization.rb'
require 'Int_arith.rb'

module Int_factor

def Int_factor.factor(n)
	finfo = Factorization.new()

	if (-1 <= n) and (n <= 1)
		finfo.insert_trivial_factor(n)
		return finfo
	end

	if n < 0
		finfo.insert_trivial_factor(-1)
		n = -n
	end

	p = 2
	while n > 1
		multiplicity = 0
		while ((n % p) == 0)
			multiplicity += 1
			n /= p
		end
		if multiplicity > 0
			finfo.insert_factor(p, multiplicity)
		end
		if p > 2
			p += 2
		else
			p += 1
		end
	end
	return finfo
end

def Int_factor.slow_totient(n)
	rv = 0
	for a in (1..(n-1))
		if Int_arith.gcd(a, n) == 1
			rv += 1
		end
	end
	return rv
end

def Int_factor.totient(n)
	finfo = Int_factor.factor(n)

	rv = n
	for p,e in finfo.factors_and_multiplicities
		rv *= (p-1)
		rv /= p
	end
	return rv
end

end # module
