#!/usr/bin/ruby -Wall

# ================================================================
# This software is released under the terms of the GNU GPL.
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2004
# Ported to Ruby 2011-02-10
# ================================================================

require 'F2_poly.rb'
require 'Factorization.rb'
require 'Bit_matrix.rb'

module F2_poly_factor

# ----------------------------------------------------------------
# Returns a Factorization object.

def F2_poly_factor.factor(f)
	if String === f
		f = F2_poly.new(f)
	elsif Integer === f
		f = F2_poly.new(f)
	end

	finfo = Factorization.new()
	if f.degree == 0
		finfo.insert_trivial_factor(f)
		return finfo
	end
	F2_poly_factor.pre_berlekamp(f, finfo, true)
	return finfo
end

# ----------------------------------------------------------------
# Returns nothing; modifies the Factorization object which is the
# second method argument.

def F2_poly_factor.pre_berlekamp(f, finfo, recurse)
	d = f.deriv
	g = f.gcd(d)

	if g.zero?
		if f.nonzero?
			raise "F2_poly_factor.pre_berlekamp: coding error detected" \
				" at file #{__FILE__} line #{__LINE__}."
		end
		finfo.insert_factor(f)
	elsif g.one?
		# Input is squarefree: ready for Berlekamp.
		F2_poly_factor.berlekamp(f, finfo, recurse)
	elsif d.zero?
		# Input is a perfect square
		is_square, sqroot = f.square_root
		sfinfo = Factorization.new()
		if !is_square
			raise "F2_poly_factor.pre_berlekamp: coding error detected" \
				" atfile #{__FILE__} line #{__LINE__}."
		end

		# Multiplicity is p only if degree is > 0.
		F2_poly_factor.pre_berlekamp(sqroot, sfinfo, recurse)
		if f.degree > 0
			sfinfo.exp_all(2)
		end
		finfo.merge(sfinfo)
	else
		q = f / g
		F2_poly_factor.pre_berlekamp(g, finfo, recurse)
		F2_poly_factor.pre_berlekamp(q, finfo, recurse)
	end
end

# ----------------------------------------------------------------
# Berlekamp factorization: see my "Computation in finite fields"
# (ffcomp.pdf) for a full description of this algorithm.
#
# Given squarefree f(x), we want to find polynomials h(x) such that
# h^q equiv h (mod f).  (Example: f = 31 = 7 * b.  Deg(f) = 5.)
# By explicit search, we can find the following polynomials h of degree
# < 5 such that h**2 = h mod f (Lidl and Niederreiter call these
# "f-reducing polynomials"): 00 01 1c 1d.
#
# To avoid having to do a search, we use linear algebra instead.
#
# f = x^5+x^4+1 = 110001
#   x^0 = 00001
#   x^2 = 00100
#   x^4 = 10000
#   x^6 = 10011
#   x^8 = 11101
#
# h   = a_4 x^4 + a_3 x^3 + a_2 x^2 + a_1 x + a_0
# h^2 = a_4(x^4+x^3+x^2+1) + a_3(x^4+x+1) + a_2(x^4) + a_1(x^2) + a_0(1)
#
# [ a_4 ]     [ 1 1 1 0 0 ]     [ a_4 ]
# [ a_3 ]     [ 1 0 0 0 0 ]     [ a_3 ]
# [ a_2 ]  =  [ 1 0 0 1 0 ]  *  [ a_2 ]
# [ a_1 ]     [ 1 1 0 0 0 ]     [ a_1 ]
# [ a_0 ]     [ 1 1 0 0 1 ]     [ a_0 ]
#
# [ 0 ]  .  [ 0 1 1 0 0 ]  .  [ a_4 ]
# [ 0 ]  .  [ 1 1 0 0 0 ]  .  [ a_3 ]
# [ 0 ]  =  [ 1 0 1 1 0 ]  *  [ a_2 ]
# [ 0 ]  .  [ 1 1 0 1 0 ]  .  [ a_1 ]
# [ 0 ]  .  [ 1 1 0 0 0 ]  .  [ a_0 ]
#
# Call the matrix B.  Its (n-1-j)th column is x^{jq} mod f.  Put it in
# row-echelon form to obtain
#
# [ 1 0 1 0 0 ]
# [ 0 1 1 0 0 ]
# [ 0 0 0 1 0 ]
# [ 0 0 0 0 0 ]
# [ 0 0 0 0 0 ]
#
# with kernel basis
#
# [ 1 1 1 0 0 ]
# [ 0 0 0 0 1 ]
#
# These are h1 = 1c and h2 = 1, respectively.  Compute gcd(f, h1) = 7 and
# gcd(f, h1+1) = b to obtain non-trivial factors of f.

@@one  = F2_poly.new(1) # Re-use these at each call -- they never change
@@x    = F2_poly.new(2)
@@x2   = F2_poly.new(4)

def F2_poly_factor.berlekamp(f, finfo, recurse)
	n = f.degree
	x2modf = @@x2 % f
	x2i = F2_poly.new(1)

	if (n < 2)
		finfo.insert_factor(f)
		return
	end

	_BI = Bit_matrix.new(n, n)

	# Populate the B matrix.
	# xxx comment order reversal makes it easier for me to read &
	# think about.  or not ... after chg ...
	for j in 0..(n-1)
		for i in 0..(n-1)
			_BI[n-1-i][n-1-j] = x2i[i]
		end
		x2i = (x2i * x2modf) % f
	end

	# Form B - I.
	for i in 0..(n-1)
		_BI[i].toggle_element(i)
	end

	_BI.row_echelon_form()
	rank = _BI.rank_rr()
	dimker = n - rank

	if (dimker == 1)
		finfo.insert_factor(f)
		return
	end

	# Find a basis for the nullspace of B - I.
	nullspace_basis = _BI.kernel_basis

	if nullspace_basis.nil?
		raise "Coding error detected: file #{__FILE__} line #{__LINE__}"
	end
	if nullspace_basis.num_rows != dimker
		raise "Coding error detected: file #{__FILE__} line #{__LINE__}"
	end

	# For each h in the nullspace basis, form
	#   f1 = gcd(f, h)
	#   f2 = gcd(f, h-1)
	# Now, the polynomial h=1 is always in the nullspace, in which case
	# f1 = 1 and f2 = f, which results in a trivial factorization.  Any
	# of the other h's will work fine, producing a non-trivial
	# factorization of f into two factors.  (Note that either or both
	# of them may be reducible, in which we'll need to apply this
	# algorithm recursively until we're down to irreducible factors.)
	# Here, for the sake of illustration, is what happens with all the
	# h's, even though we need only one of them (with f = 703):

	# h=001
	#  f1: 001
	#  f2: 70e = 2 3 7 b d
	# h=102     = 2 3 b d
	#  f1: 102 = 2 3 b d
	#  f2: 007 = 7
	# h=284     = 2 2 7 3b
	#  f1: 00e = 2 7
	#  f2: 081 = 3 b d
	# h=0e8     = 2 2 2 3 b
	#  f1: 03a = 2 3 b
	#  f2: 023 = 7 d
	# h=310     = 2 2 2 2 7 b
	#  f1: 062 = 2 7 b
	#  f2: 017 = 3 d

	for row in 0..(dimker-1)
		h = F2_poly_factor.f2poly_from_vector(nullspace_basis[row], n)
		hc = h + @@one

		check1 = (h  * h)  % f
		check2 = (hc * hc) % f
		if (h != check1) || (hc != check2)
			raise "Coding error detected: file " \
				"#{__FILE__} line #{__LINE__}\n" \
				"h = #{h} h^2= #{check1} hc = #{hc} hc^2 = #{check2}"
		end

		f1 = f.gcd(h)
		f2 = f.gcd(hc)

		if f1.one? || f2.one?
			next
		end

		# The nullity of B-I is the number of irreducible
		# factors of f.  If the nullity is 2, we have a
		# pair of factors which are both irreducible and
		# so we don't need to recurse.
		if (dimker == 2)
			finfo.insert_factor(f1)
			finfo.insert_factor(f2)
		elsif !recurse
			finfo.insert_factor(f1)
			finfo.insert_factor(f2)
		else
			F2_poly_factor.pre_berlekamp(f1, finfo, recurse)
			F2_poly_factor.pre_berlekamp(f2, finfo, recurse)
		end
		return
	end

	raise "Coding error detected: file #{__FILE__} line #{__LINE__}"
end

# ----------------------------------------------------------------
# v is nominally a Bit_vector.
# xxx remove after swappage?

def F2_poly_factor.f2poly_from_vector(v, n)
	f = F2_poly.new(0)
	for i in 0..(n-1)
		if v[n-1-i] == 1
			f[i] = 1
		end
	end
	return f
end

# ----------------------------------------------------------------
def F2_poly_factor.irr?(f)
	if String === f
		f = F2_poly.new(f)
	end
	degree = f.degree
	if degree == 0
		return false
	elsif degree == 1
		return true
	end

	finfo = Factorization.new()
	F2_poly_factor.pre_berlekamp(f, finfo, false)

	if finfo.num_factors == 1
		return true
	else
		return false
	end
end

# ----------------------------------------------------------------
# Lexically lowest
def F2_poly_factor.lowest_irr(degree)
	rv = F2_poly.new((1 << degree) | 1)

	if (degree < 1)
		raise "F2_poly_factor.lowest_irr: degree must be positive; " \
			"got #{degree}."
	end

	while rv.degree == degree
		if F2_poly_factor.irr?(rv)
			return rv
		end
		rv.bits += 2
	end

	# There are irreducibles of all positive degrees, so it is
	# an error if we failed to find one.
	raise "F2_poly_factor.lowest_irr: coding error detected."
end

# ----------------------------------------------------------------
def F2_poly_factor.random_irr(degree)
	if degree < 1
		raise "F2_poly_factor.random_irr: degree must be " \
			"positive; got #{degree}."
	end

	while true
		rv = F2_poly.random(degree)
		rv.bits |= 1
		if F2_poly_factor.irr?(rv)
			return rv
		end
	end
end

# ----------------------------------------------------------------
# How to compute the order of the unit group of a residue class ring over
# F_q[x], i.e. the totient function of a polynomial in F_q[x].  Let the
# prime factorization of f(x) be
#
#   f(x) = \prod_{i=1}^m {f_i}^{e_i}
#
# The CRT says
#
#   \F_q[x]/<{f(x)}> \cong \oplus_{i=1}^m \F_q[x]/\pig{{f_i}^{e_i}}
#
# as a ring isomorphism, and likewise for the multiplicative group (units).
# So the question reduces to, what is the totient function of
# ${f_i}^{e_i}$.  Let $d_i = \deg(f_i)$.  Then a \emph{non}-unit in the
# residue class ring is is any multiple of $f_i$.  The $i$th factor ring
# has order $q^{d_i e_i}$.  Any non-zero poly of degree less than $d_i$ is
# necessarily relatively prime to $f_i$, since $f_i$ is prime.  Letting the
# zero poly have degree 0, there are $q^{d_i e_i - d_i}$ multiples of
# $f_i$.  Then the number of units in the $i$th factor ring is
#
#   q^{d_i e_i} - q^{d_i e_i-d_i } = q^{d_i (e_i-1)}(q^{d_i} -1)
#
# and so the order of the multiplicative group is
#
#   \prod_{i=1}^m q^{d_i (e_i-1)}(q^{d_i} -1)
#
# In the irreducible case, $m=1$, $d_1=n$, $e_1=1$, whence
#
#   q^{n (1-1)}(q^{n} -1) = q^{n-1}
#
# which recovers the special case for finite fields.

def F2_poly_factor.totient(f)
	rv = 1
	finfo = F2_poly_factor.factor(f)
	nf = finfo.num_distinct_factors

	for i in (0..(nf-1))
		fi = finfo.get_factor(i)
		ei = finfo.get_multiplicity(i)
		di = fi.degree
		rv *= (1 << (di * (ei-1))) * ((1 << di) -1)
	end

	return rv
end

end # module
