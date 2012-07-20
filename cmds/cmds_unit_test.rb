#!/usr/bin/ruby -Wall

# ================================================================
# This software is released under the terms of the GNU GPL.
# Please see LICENSE.txt in the same directory as this file.
#
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2011
# ================================================================

require 'test/unit'

class Cmds_unit_test < Test::Unit::TestCase

	# ----------------------------------------------------------------
	def test_zplus
		o = `z+`; assert_equal($?, 0); assert_equal("0\n", o)
		o = `z+ 3`; assert_equal($?, 0); assert_equal("3\n", o)
		o = `z+ 3 44`; assert_equal($?, 0); assert_equal("47\n", o)
		o = `z+ 3 44 5`; assert_equal($?, 0); assert_equal("52\n", o)
	end

	def test_zminus
		o = `z-`; assert_not_equal($?, 0)
		o = `z- 3`; assert_equal($?, 0); assert_equal("-3\n", o)
		o = `z- 3 44`; assert_equal($?, 0); assert_equal("-41\n", o)
		o = `z- 3 44 5`; assert_not_equal($?, 0)
	end

	def test_zmul
		o = `z.`; assert_equal($?, 0); assert_equal("1\n", o)
		o = `z. 3`; assert_equal($?, 0); assert_equal("3\n", o)
		o = `z. 3 44`; assert_equal($?, 0); assert_equal("132\n", o)
		o = `z. 3 44 5`; assert_equal($?, 0); assert_equal("660\n", o)
	end

	def test_zdiv
		o = `zdiv`; assert_not_equal($?, 0)
		o = `zdiv 44`; assert_not_equal($?, 0)
		o = `zdiv 44 3`; assert_equal($?, 0); assert_equal("14\n", o)
		o = `zdiv 44 3 5`; assert_not_equal($?, 0)
	end

	def test_zmod
		o = `zmod`; assert_not_equal($?, 0)
		o = `zmod 44`; assert_not_equal($?, 0)
		o = `zmod 44 3`; assert_equal($?, 0); assert_equal("2\n", o)
		o = `zmod 44 3 5`; assert_not_equal($?, 0)
	end

	def test_zexp
		o = `zexp`; assert_not_equal($?, 0)
		o = `zexp 3`; assert_not_equal($?, 0)
		o = `zexp 2 3`; assert_equal($?, 0); assert_equal("8\n", o)
		o = `zexp 5 7 3`; assert_equal($?, 0); assert_equal("125\n343\n", o)
	end

	def test_zgcd
		o = `zgcd`; assert_not_equal($?, 0)
		o = `zgcd 88`; assert_equal($?, 0); assert_equal("88\n", o)
		o = `zgcd 88 66`; assert_equal($?, 0); assert_equal("22\n", o)
		o = `zgcd 88 66 88`; assert_equal($?, 0); assert_equal("22\n", o)
		o = `zgcd 88 66 33`; assert_equal($?, 0); assert_equal("11\n", o)
	end

	def test_zegcd
		o = `zegcd`; assert_not_equal($?, 0)
		o = `zegcd 88`; assert_not_equal($?, 0)
		o = `zegcd 88 66`; assert_equal($?, 0);
			assert_equal("22 = 1 * 88 + -1 * 66\n", o)
		o = `zegcd 88 66 88`; assert_not_equal($?, 0)
	end

	def test_zlcm
		o = `zlcm`; assert_not_equal($?, 0)
		o = `zlcm 88`; assert_equal($?, 0); assert_equal("88\n", o)
		o = `zlcm 88 66`; assert_equal($?, 0); assert_equal("264\n", o)
		o = `zlcm 88 66 88`; assert_equal($?, 0); assert_equal("264\n", o)
		o = `zlcm 88 66 55`; assert_equal($?, 0); assert_equal("1320\n", o)
	end

	def test_zfactor
		o = `zfactor`; assert_not_equal($?, 0)
		o = `zfactor 720`; assert_equal($?, 0);
			assert_equal("720 = 2^4 3^2 5\n", o)
		o = `zfactor 720 44`; assert_equal($?, 0);
			assert_equal("720 = 2^4 3^2 5\n44 = 2^2 11\n", o)
	end

	def test_zrandom
		o = `zrandom`; assert_not_equal($?, 0)
		o = `zrandom 4 5 6`; assert_not_equal($?, 0)
	end

	def test_factorial
		o = `zfactorial`; assert_not_equal($?, 0)
		o = `zfactorial 0`; assert_equal($?, 0); assert_equal("1\n", o)
		o = `zfactorial 1`; assert_equal($?, 0); assert_equal("1\n", o)
		o = `zfactorial 2`; assert_equal($?, 0); assert_equal("2\n", o)
		o = `zfactorial 3`; assert_equal($?, 0); assert_equal("6\n", o)
		o = `zfactorial 10`; assert_equal($?, 0); assert_equal("3628800\n", o)
		o = `zfactorial 25`; assert_equal($?, 0);
			assert_equal("15511210043330985984000000\n", o)
	end

	# ----------------------------------------------------------------
	def test_zmplus
		o = `zm+`; assert_not_equal($?, 0);
		o = `zm+ 11`; assert_equal($?, 0); assert_equal("0\n", o)
		o = `zm+ 11 3`; assert_equal($?, 0); assert_equal("3\n", o)
		o = `zm+ 11 3 44`; assert_equal($?, 0); assert_equal("3\n", o)
		o = `zm+ 11 3 44 5`; assert_equal($?, 0); assert_equal("8\n", o)
	end

	def test_zmminus
		o = `zm-`; assert_not_equal($?, 0);
		o = `zm- 11`; assert_not_equal($?, 0)
		o = `zm- 11 3`; assert_equal($?, 0); assert_equal("8\n", o)
		o = `zm- 11 3 42`; assert_equal($?, 0); assert_equal("5\n", o)
		o = `zm- 11 3 44 5`; assert_not_equal($?, 0)
	end

	def test_zmmul
		o = `zm.`; assert_not_equal($?, 0);
		o = `zm. 11`; assert_equal($?, 0); assert_equal("1\n", o)
		o = `zm. 11 3`; assert_equal($?, 0); assert_equal("3\n", o)
		o = `zm. 11 3 8`; assert_equal($?, 0); assert_equal("2\n", o)
		o = `zm. 11 3 8 5`; assert_equal($?, 0); assert_equal("10\n", o)
	end

	def test_zmdiv
		o = `zmdiv`; assert_not_equal($?, 0);
		o = `zmdiv 11`; assert_not_equal($?, 0)
		o = `zmdiv 11 3`; assert_equal($?, 0); assert_equal("4\n", o)
		o = `zmdiv 11 3 42`; assert_equal($?, 0); assert_equal("4\n", o)
		o = `zmdiv 11 3 44 5`; assert_not_equal($?, 0)
	end

	def test_zmexp
		o = `zmexp`; assert_not_equal($?, 0);
		o = `zmexp 11`; assert_not_equal($?, 0)
		o = `zmexp 11 9`; assert_not_equal($?, 0);
		o = `zmexp 11 3 9`; assert_equal($?, 0); assert_equal("4\n", o)
		o = `zmexp 11 2 3 4 5 9`; assert_equal($?, 0);
			assert_equal("6\n4\n3\n9\n", o)
	end

	def test_zmrandom
		o = `zmrandom`; assert_not_equal($?, 0)
		o = `zmrandom 4 5 6`; assert_not_equal($?, 0)
	end

	def test_zmlist
		o = `zmlist`; assert_not_equal($?, 0)
		o = `zmlist 5`; assert_not_equal($?, 0)
		o = `zmlist 4 5`; assert_not_equal($?, 0)
		o = `zmlist 4 5 6`; assert_not_equal($?, 0)
		o = `zmlist -a 5`; assert_equal($?, 0);
			assert_equal("0\n1\n2\n3\n4\n", o)
		o = `zmlist -u 5`; assert_equal($?, 0);
			assert_equal("1\n2\n3\n4\n", o)
		o = `zmlist -a 6`; assert_equal($?, 0);
			assert_equal("0\n1\n2\n3\n4\n5\n", o)
		o = `zmlist -u 6`; assert_equal($?, 0);
			assert_equal("1\n5\n", o)
	end

	# ----------------------------------------------------------------
	def test_fplus
		o = `f+`; assert_equal($?, 0); assert_equal("0\n", o)
		o = `f+ 3`; assert_equal($?, 0); assert_equal("3\n", o)
		o = `f+ 3 aa`; assert_equal($?, 0); assert_equal("a9\n", o)
		o = `f+ 3 aa c`; assert_equal($?, 0); assert_equal("a5\n", o)
	end

	def test_fminus
		o = `f-`; assert_not_equal($?, 0)
		o = `f- 3`; assert_equal($?, 0); assert_equal("3\n", o)
		o = `f- 3 aa`; assert_equal($?, 0); assert_equal("a9\n", o)
		o = `f- 3 aa c`; assert_not_equal($?, 0)
	end

	def test_fmul
		o = `f.`; assert_equal($?, 0); assert_equal("1\n", o)
		o = `f. 3`; assert_equal($?, 0); assert_equal("3\n", o)
		o = `f. 3 aa`; assert_equal($?, 0); assert_equal("1fe\n", o)
		o = `f. 3 aa c`; assert_equal($?, 0); assert_equal("808\n", o)
	end

	def test_fdiv
		o = `fdiv`; assert_not_equal($?, 0)
		o = `fdiv aa`; assert_not_equal($?, 0)
		o = `fdiv aa 3`; assert_equal($?, 0); assert_equal("66\n", o)
		o = `fdiv aa 3 c`; assert_not_equal($?, 0)
	end

	def test_fmod
		o = `fmod`; assert_not_equal($?, 0)
		o = `fmod aa`; assert_not_equal($?, 0)
		o = `fmod aa b`; assert_equal($?, 0); assert_equal("7\n", o)
		o = `fmod aa b c`; assert_not_equal($?, 0)
	end

	def test_fexp
		o = `fexp`; assert_not_equal($?, 0)
		o = `fexp 3`; assert_not_equal($?, 0)
		o = `fexp 2 3`; assert_equal($?, 0); assert_equal("8\n", o)
		o = `fexp 5 7 3`; assert_equal($?, 0); assert_equal("55\n6b\n", o)
	end

	def test_fgcd
		o = `fgcd`; assert_not_equal($?, 0)
		o = `fgcd aa`; assert_equal($?, 0); assert_equal("aa\n", o)
		o = `fgcd aa bb`; assert_equal($?, 0); assert_equal("11\n", o);
		o = `fgcd aa bb cc`; assert_equal($?, 0); assert_equal("11\n", o)
	end

	def test_fegcd
		o = `fegcd`; assert_not_equal($?, 0)
		o = `fegcd 88`; assert_not_equal($?, 0)
		o = `fegcd 88 66`; assert_equal($?, 0);
			assert_equal("22 = 1 * 88 + 3 * 66\n", o)
		o = `fegcd 88 66 88`; assert_not_equal($?, 0)
	end

	def test_flcm
		o = `flcm`; assert_not_equal($?, 0)
		o = `flcm 88`; assert_equal($?, 0); assert_equal("88\n", o)
		o = `flcm 88 66`; assert_equal($?, 0); assert_equal("198\n", o)
		o = `flcm 88 66 88`; assert_equal($?, 0); assert_equal("198\n", o)
		o = `flcm 88 66 55`; assert_equal($?, 0); assert_equal("2a8\n", o)
	end

	def test_fdeg
		o = `fdeg`; assert_not_equal($?, 0)
		o = `fdeg 0`; assert_equal($?, 0); assert_equal("0\n", o)
		o = `fdeg 0 1 2 a ff beef`; assert_equal($?, 0);
			assert_equal("0\n0\n1\n3\n7\n15\n", o)
	end

	def test_ffactor
		o = `ffactor`; assert_not_equal($?, 0)
		o = `ffactor 720`; assert_equal($?, 0);
			assert_equal("720 = 2^5 3^2 d\n", o)
		o = `ffactor 720 beef`; assert_equal($?, 0);
			assert_equal("720 = 2^5 3^2 d\nbeef = cb 1bd\n", o)
	end

	def test_frandom
		o = `frandom`; assert_not_equal($?, 0)
		o = `frandom 4 5 6`; assert_not_equal($?, 0)
	end

	def test_ftestirr
		o = `ftestirr`; assert_not_equal($?, 0)
		o = `ftestirr 11b`; assert_equal($?, 0);
			assert_equal("11b IRREDUCIBLE\n", o)
		o = `ftestirr 11b 11c`; assert_equal($?, 0);
			assert_equal("11b IRREDUCIBLE\n11c reducible\n", o)
	end

	def test_flowestirr
		o = `flowestirr`; assert_not_equal($?, 0)
		o = `flowestirr 4`; assert_equal($?, 0); assert_equal("4 13\n", o)
		o = `flowestirr 4 5`; assert_equal($?, 0);
			assert_equal("4 13\n5 25\n", o)
	end

	def test_frandomirr
		o = `frandomirr`; assert_not_equal($?, 0)
		o = `frandomirr 4 5 6`; assert_not_equal($?, 0)
	end

	# ----------------------------------------------------------------
	def test_fmplus
		o = `fm+`; assert_not_equal($?, 0);
		o = `fm+ 13`; assert_equal($?, 0); assert_equal("0\n", o)
		o = `fm+ 13 3`; assert_equal($?, 0); assert_equal("3\n", o)
		o = `fm+ 13 3 44`; assert_equal($?, 0); assert_equal("b\n", o)
		o = `fm+ 13 3 44 5`; assert_equal($?, 0); assert_equal("e\n", o)
	end

	def test_fmminus
		o = `fm-`; assert_not_equal($?, 0);
		o = `fm- 13`; assert_not_equal($?, 0)
		o = `fm- 13 3`; assert_equal($?, 0); assert_equal("3\n", o)
		o = `fm- 13 3 42`; assert_equal($?, 0); assert_equal("d\n", o)
		o = `fm- 13 3 44 5`; assert_not_equal($?, 0)
	end

	def test_fmmul
		o = `fm.`; assert_not_equal($?, 0);
		o = `fm. 13`; assert_equal($?, 0); assert_equal("1\n", o)
		o = `fm. 13 3`; assert_equal($?, 0); assert_equal("3\n", o)
		o = `fm. 13 3 44`; assert_equal($?, 0); assert_equal("b\n", o)
		o = `fm. 13 3 44 5`; assert_equal($?, 0); assert_equal("1\n", o)
	end

	def test_fmdiv
		o = `fmdiv`; assert_not_equal($?, 0);
		o = `fmdiv 13`; assert_not_equal($?, 0)
		o = `fmdiv 13 3`; assert_equal($?, 0); assert_equal("e\n", o)
		o = `fmdiv 13 3 42`; assert_equal($?, 0); assert_equal("5\n", o)
		o = `fmdiv 13 3 44 5`; assert_not_equal($?, 0)
	end

	def test_fmexp
		o = `fmexp`; assert_not_equal($?, 0);
		o = `fmexp 13`; assert_not_equal($?, 0)
		o = `fmexp 13 14`; assert_not_equal($?, 0);
		o = `fmexp 13 3 14`; assert_equal($?, 0); assert_equal("e\n", o)
		o = `fmexp 13 2 3 4 5 14`; assert_equal($?, 0);
			assert_equal("9\ne\nd\nb\n", o)
	end

	def test_fmrandom
		o = `fmrandom`; assert_not_equal($?, 0)
		o = `fmrandom 4 5 6`; assert_not_equal($?, 0)
	end

	def test_fmlist
		o = `fmlist`; assert_not_equal($?, 0)
		o = `fmlist 5`; assert_not_equal($?, 0)
		o = `fmlist 4 5`; assert_not_equal($?, 0)
		o = `fmlist 4 5 6`; assert_not_equal($?, 0)
		o = `fmlist -a b`; assert_equal($?, 0);
			assert_equal("0\n1\n2\n3\n4\n5\n6\n7\n", o)
		o = `fmlist -u 12`; assert_equal($?, 0);
			assert_equal("1\nb\nd\n", o)
	end

	# xxx zm.bl & fmtbl tests ...

	def test_ztotient
		o = `ztotient`; assert_not_equal($?, 0)
		o = `ztotient 11 35 105 245 720`; assert_equal($?, 0);
			assert_equal("10\n24\n48\n168\n192\n", o)
	end

	def test_ftotient
		o = `ftotient`; assert_not_equal($?, 0)
		o = `ftotient 10 12 13 19`; assert_equal($?, 0);
			assert_equal("8\n3\n15\n15\n", o)
	end

	def test_zmord
		o = `zmord`; assert_not_equal($?, 0)
		o = `zmord 11`; assert_not_equal($?, 0)
		o = `zmord 11 2 3 4 5 6`; assert_equal($?, 0);
			assert_equal("10\n5\n5\n5\n10\n", o)
	end

	def test_fmorbit
		o = `fmorbit`; assert_not_equal($?, 0)
		o = `fmorbit 11`; assert_not_equal($?, 0)
		o = `fmorbit 13 6`; assert_equal($?, 0);
			assert_equal("6\n7\n1\n", o)
		o = `fmorbit 13 6 2`; assert_equal($?, 0);
			assert_equal("c\ne\n2\n", o)
	end

	def test_zmorbit
		o = `zmorbit`; assert_not_equal($?, 0)
		o = `zmorbit 11`; assert_not_equal($?, 0)
		o = `zmorbit 11 2`; assert_equal($?, 0)
			assert_equal("2\n4\n8\n5\n10\n9\n7\n3\n6\n1\n", o)
		o = `zmorbit 11 3 2`; assert_equal($?, 0)
			assert_equal("6\n7\n10\n8\n2\n", o)
		o = `zmorbit 21 10`; assert_equal($?, 0)
			assert_equal("10\n16\n13\n4\n19\n1\n", o)
	end

	def test_fmmaxord
		o = `fmmaxord`; assert_not_equal($?, 0)
		o = `fmmaxord 13`; assert_equal($?, 0);
			assert_equal("15\n", o)
		o = `fmmaxord 13 12`; assert_equal($?, 0);
			assert_equal("15\n3\n", o)
		o = `fmmaxord 27`; assert_equal($?, 0);
			assert_equal("14\n", o)
	end

	def test_zmmaxord
		o = `zmmaxord`; assert_not_equal($?, 0)
		o = `zmmaxord 11`; assert_equal($?, 0);
			assert_equal("10\n", o)
		o = `zmmaxord 11 12`; assert_equal($?, 0);
			assert_equal("10\n2\n", o)
		o = `zmmaxord 21`; assert_equal($?, 0);
			assert_equal("6\n", o)
	end

	def test_fmord
		o = `fmord`; assert_not_equal($?, 0)
		o = `fmord 13`; assert_not_equal($?, 0)
		o = `fmord 13 2 3 4 5 6`; assert_equal($?, 0);
			assert_equal("15\n15\n15\n15\n3\n", o)
	end

	def test_zdivisors
		o = `zdivisors`; assert_not_equal($?, 0)
		o = `zdivisors 121 122`; assert_equal($?, 0);
			assert_equal("121: 1 11 121\n122: 1 2 61 122\n", o)
		o = `zdivisors 120`; assert_equal($?, 0);
			assert_equal("120: 1 2 3 4 5 6 8 10 12 15 20 24 30 40 60 120\n", o)
		o = `zdivisors -mp 120`; assert_equal($?, 0);
			assert_equal("120: 24 40 60\n", o)
	end

	def test_fdivisors
		o = `fdivisors`; assert_not_equal($?, 0)
		o = `fdivisors 13 14`; assert_equal($?, 0);
			assert_equal("13: 1 13\n14: 1 2 3 4 5 6 a c 14\n", o)
		o = `fdivisors -mp 14 18`; assert_equal($?, 0);
			assert_equal("14: a c\n18: 8 c\n", o)
	end

	def test_fperiod
		o = `fperiod`; assert_not_equal($?, 0)
		o = `fperiod 13 19 1f 10`; assert_equal($?, 0);
			assert_equal("15\n15\n5\n0\n", o)
	end

	def test_zmfindgen
		o = `zmfindgen`; assert_not_equal($?, 0)
		o = `zmfindgen 11 34`; assert_equal($?, 0);
			assert_equal("2\n3\n", o)
		o = `zmfindgen 21`; assert_not_equal($?, 0);
			assert_equal("No generator found.\n", o)
	end

	def test_fmfindgen
		o = `fmfindgen`; assert_not_equal($?, 0)
		o = `fmfindgen 13 18`; assert_equal($?, 0);
			assert_equal("2\n7\n", o)
		o = `fmfindgen 14`; assert_not_equal($?, 0);
			assert_equal("No generator found.\n", o)
	end

	def test_ftestprim
		o = `ftestprim`; assert_not_equal($?, 0)
		o = `ftestprim 0 1`; assert_equal($?, 0);
			assert_equal("0 imprimitive\n1 PRIMITIVE\n", o)
		o = `ftestprim 13 15`; assert_equal($?, 0);
			assert_equal("13 PRIMITIVE\n15 imprimitive\n", o)
	end

end
