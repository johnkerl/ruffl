#!/usr/bin/ruby -Wall

require 'Int_factor.rb'
require 'Int_mod.rb'
require 'F2_poly_factor.rb'
require 'F2_poly.rb'
require 'F2_poly_mod.rb'

module Order

# ----------------------------------------------------------------
# The simplest algorithm is to loop over all possible exponents from 1
# to the order of the unit group.  Instead, we use Lagrange's theorem,
# testing only divisors of the order of the unit group.

# am is of type F2_poly_mod or Int_mod.
def Order.mod_order(am)
	a = am.residue
	m = am.modulus

	if F2_poly_mod === am
		if !a.gcd(m).one?
			raise "Order.mod_order: " \
				"zero or zero divisor #{a} mod #{m}.\n"
		end
		phi = F2_poly_factor.totient(m)
	elsif Int_mod === am
		if Int_arith.gcd(a, m) != 1
			raise "Order.mod_order: " \
				"zero or zero divisor #{a} mod #{m}.\n"
		end
		phi = Int_factor.totient(m)
	else
		raise "Order.mod_order: unrecognized class #{am.class}."
	end

	finfo = Int_factor.factor(phi)
	phi_divisors = finfo.all_divisors
	nd = phi_divisors.length
	one = am/am

	# The output from all_divisors is guaranteed to be sorted up.
	# Thus, here we will find the *least* exponent e such that a^e = 1.
	for e in phi_divisors
		if (am**e) == one
			return e
		end
	end

	# By Lagrange's theorem, g^m = 1 for all units g, with m the order
	# of the unit group.  If we've not found the order of a unit,
	# something is wrong.
	raise "Order.F2_poly_mod_order:  Coding error.\n"
end

# ----------------------------------------------------------------
def Order.mod_max_order(m)
	if F2_poly === m
		F2_poly_mod.units_for_modulus(m).collect{|a| Order.mod_order(a)}.max
	elsif Integer === m
		Int_mod.units_for_modulus(m).collect{|a| Order.mod_order(a)}.max
	else
		raise "Order.mod_max_order: unrecognized class #{m.class}."
	end
end

# ----------------------------------------------------------------
# bm is for co-orbit (coset)
def Order.orbit(am, bm=nil)
	a = am.residue
	m = am.modulus

	# xxx need to check for infinite-loop cases ...
	if F2_poly_mod === am
		termination_block = lambda {|cm| cm.residue.one? }
	elsif Int_mod === am
		termination_block = lambda {|cm| cm.residue == 1 }
	else
		raise "Order.mod_max_order: unrecognized class #{m.class}."
	end

	orbit = []
	cm = am.clone
	while true
		if bm.nil?
			orbit << cm
		else
			orbit << cm*bm
		end
		break if termination_block.call(cm)
		cm = cm * am
	end

	return orbit
end

# ----------------------------------------------------------------
def Order.F2_poly_period(m)
	m = F2_poly.new(m)
	x = F2_poly.new(2)
	if !x.gcd(m).one?
		return 0
	end
	return Order.mod_order(F2_poly_mod.new(x, m))
end

# ----------------------------------------------------------------
# Argument and return value are of type integer.
# Returns a generator or nil.
def Order.Int_mod_generator(m)
	m = Integer(m)
	if m < 2
		raise "Order.Int_mod_generator: modulus must be >= 2; got #{m}."
	end
	phi = Int_factor.totient(m)
	g = Int_mod.new(1, m)
	while g.residue < m
		if Int_arith.gcd(g.residue, m) == 1
			if Order.mod_order(g) == phi
				return g.residue
			end
		end
		g.residue += 1
	end

	# For irreducible moduli with coefficients in a field, the
	# unit group is cyclic so there is always a generator.
	# Either there is a coding error, the modulus isn't irreducible,
	# or the coefficients don't lie in a field.  Since the latter cases
	# aren't our fault, this situation doesn't merit a fatal error.
	return nil
end

# ----------------------------------------------------------------
# Argument and return value are of type F2_poly.
# Returns a generator or nil.
def Order.F2_poly_mod_generator(m)
	m = F2_poly.new(m)
	mdeg = m.degree
	if mdeg < 1
		raise "Order.F2_poly_mod_generator: modulus degree must be" \
			" positive; got #{mdeg}."
	end
	phi = F2_poly_factor.totient(m)
	g = F2_poly_mod.new(1, m)
	while g.residue.degree < mdeg
		if g.residue.gcd(m).one?
			if Order.mod_order(g) == phi
				return g.residue
			end
		end
		g.residue.bits += 1
	end

	# For irreducible moduli with coefficients in a field, the
	# unit group is cyclic so there is always a generator.
	# Either there is a coding error, the modulus isn't irreducible,
	# or the coefficients don't lie in a field.  Since the latter cases
	# aren't our fault, this situation doesn't merit a fatal error.
	return nil
end

# ----------------------------------------------------------------
# The naive test is a one-liner:
#   return (f2poly_totient(m) == f2poly_period(m))
# This appears simple, but f2poly_period() will test x^d for all proper
# divisors of phi(m).  For primitivity, it suffices to check only the
# *maximal* proper divisors of phi(m).

def Order.F2_poly_primitive?(m)
	m = F2_poly.new(m)
	x = F2_poly.new(2)
	if !m.gcd(x).one?
		return false
	end

	# Equivalence class of x in the residue class ring.
	rcrx = F2_poly_mod.new(x, m)

	phi = F2_poly_factor.totient(m)
	finfo = Int_factor.factor(phi)

	mpds = finfo.maximal_proper_divisors
	if mpds == []
		# x or x+1 in F2[x].  The former case was already ruled out; the
		# latter is primitive.
		return true
	end

	for mpd in mpds
		rcrxpower = rcrx ** mpd
		if rcrxpower.one?
			return false
		end
	end

	# This can happen when m is reducible.
	rcrxpower = rcrx ** phi
	if !rcrxpower.one?
		return false
	end

	return true
end

## ----------------------------------------------------------------
## Lexically lowest
#f2poly_t f2poly_find_prim(
#	int degree,
#	int need_irr)
#{
#	f2poly_t rv(0);
#	rv.set_bit(degree);
#	rv.set_bit(0);
#
#	if (degree < 1) {
#		std::cout << "f2poly_find_prim:  degree must be positive; got "
#			<< degree << ".\n";
#		exit(1);
#	}
#
#	while (rv.find_degree() == degree) {
#		if (f2poly_is_primitive(rv)) {
#			if (!need_irr || f2poly_is_irreducible(rv))
#				return rv;
#		}
#		rv.increment();
#	}
#
#	# There are irreducibles, and primitive irreducibles, of all positive
#	# degrees.  It is an error if we failed to find one.
#	std::cout << "f2poly_find_prim:  coding error.\n";
#	exit(1);
#
#	return rv;
#}

## ----------------------------------------------------------------
#f2poly_t f2poly_random_prim(
#	int degree,
#	int need_irr)
#{
#	f2poly_t rv;
#
#	if (degree < 1) {
#		std::cout << "f2poly_random_prim:  degree must be positive; "
#			<< "got " << degree << ".\n";
#		exit(1);
#	}
#
#	for (;;) {
#		rv = f2poly_random(degree);
#		if (f2poly_is_primitive(rv)) {
#			if (!need_irr || f2poly_is_irreducible(rv))
#				return rv;
#		}
#	}
#}

end
