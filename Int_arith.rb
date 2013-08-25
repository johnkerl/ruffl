#!/usr/bin/ruby

# ================================================================
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2004
# Ported to Ruby 2011-02-10
# ================================================================

module Int_arith

# ----------------------------------------------------------------
def Int_arith.gcd(a, b)
	r = 0
	if (a == 0)
		return b
	end
	if (b == 0)
		return a
	end
	while (1)
		r = a % b
		if (r == 0)
			break
		end
		a = b
		b = r
	end
	if (b < 0)
		b = -b
	end
	return b
end

# ----------------------------------------------------------------
# Blankinship's algorithm

def Int_arith.ext_gcd(a, b)

	# Initialize
	mprime = 1
	n      = 1
	m      = 0
	nprime = 0
	c      = a
	d      = b

	while (1)
		# Divide
		q = c / d
		r = c % d
		# Note:  now c = qd + r and 0 <= r < d

		if (r == 0) # Remainder zero?
			break
		end

		# Recycle
		c = d
		d = r

		t      = mprime
		mprime = m
		qm     = q * m
		m      = t - qm

		t      = nprime
		nprime = n
		qn     = q * n
		n      = t - qn
	end
	return [d, m, n]
end

# ----------------------------------------------------------------
def Int_arith.lcm(a, b)
	return a * b/ Int_arith.gcd(a, b)
end

## ----------------------------------------------------------------
@@eulerphi_cache = {}
def Int_arith.eulerphi(n)
	cached_phi = @@eulerphi_cache[n]
	if !cached_phi.nil? # Cache hit
		return cached_phi
	end

	phi = 0
	for i in (1..(n-1))
		if (gcd(n, i) == 1)
			phi += 1
		end
	end
	@@eulerphi_cache[n] = phi
	return phi
end

# ----------------------------------------------------------------
# Binary exponentiation

def Int_arith.intexp(x, e)
	xp = x
	rv = 1

	if (e < 0)
		puts "intexp:  negative exponent", e, "disallowed."
		raise RuntimeError
	end

	while (e != 0)
		if (e & 1) == 1
			rv = rv * xp
		end
		e = e >> 1
		xp = xp * xp
	end
	return rv
end


# ----------------------------------------------------------------
# Binary exponentiation

def Int_arith.intmodexp(x, e, m)

	if (e < 0)
		e = -e
		x = intmodrecip(x, m)
	end

	xp = x
	rv = 1

	while (e != 0)
		if (e & 1) == 1
			rv = (rv * xp) % m
		end
		e = e >> 1
		xp = (xp * xp) % m
	end
	return rv
end

# ----------------------------------------------------------------
def Int_arith.intmodrecip(x, m)
	if (gcd(x, m) != 1)
		print "intmodrecip:  impossible inverse", x, "mod", m
		raise RuntimeError
	end
	phi = eulerphi(m)
	return intmodexp(x, phi-1, m)
end

# ----------------------------------------------------------------
def Int_arith.factorial(n)
	if (n < 0)
		print "factorial: negative input disallowed."
		raise RuntimeError
	end
	if (n < 2)
		return 1
	end
	rv = 1
	for k in (2..(n))
		rv *= k
	end
	return rv
end

## ----------------------------------------------------------------
## How to compute P(n) = number of partitions of n.  Examples for n = 1 to 5:
##
## 1    2      3        4          5
##      1 1    2 1      3 1        4 1
##             1 1 1    2 2        3 2
##                      2 1 1      3 1 1
##                      1 1 1 1    2 2 1
##                                 2 1 1 1
##                                 1 1 1 1 1
##
## This is a first-rest algorithm.  Loop over possible choices k for the first
## number.  The rest must sum to n-k. Furthermore, the rest must be descending
## and so each must be less than or equal to k.  Thus we naturally have an
## auxiliary function P(n, m) counting partitions of n with each element less
## than or equal to m.
#
#def num_ptnsm(n, m)
#	if (n <  0)
#		return 0
#	end
#	if (n <= 1)
#		return 1
#	end
#	if (m == 1)
#		return 1
#	end
#	sum = 0
#	for k in (1..(m))
#		if (n-k >= 0)
#			sum += num_ptnsm(n-k, k)
#		end
#	end
#	return sum
#end

## ----------------------------------------------------------------
#def num_ptns(n)
#	return num_ptnsm(n, n)
#end

## ----------------------------------------------------------------
#def ptnsm(n, m)
#	rv = []
#	if (n <  0): return 0
#	if (n == 0): return [[]]
#	if (n == 1): return [[1]]
#	if (m == 1): return [[1] * n]
#	sum = 0
#	for k in (1..(m))
#		if (n-k >= 0)
#			tails = ptnsm(n-k, k)
#			for tail in tails
#				rv.append([k] + tail)
#			end
#		end
#	end
#	return rv
#end

## ----------------------------------------------------------------
#def ptns(n)
#	return ptnsm(n, n)
#end

end # module
