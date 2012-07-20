#!/usr/bin/ruby -Wall

# ================================================================
# This software is released under the terms of the GNU GPL.
# Please see LICENSE.txt in the same directory as this file.
# John Kerl
# kerl.john.r@gmail.com
# Copyright (c) 2004
# Ported to Ruby 2011-02-10
# ================================================================

require 'Bit_vector.rb'

class Bit_matrix

	# ----------------------------------------------------------------
	def initialize(init_num_rows, init_num_cols)

		if (init_num_rows <= 0) || (init_num_cols <= 0)
			raise "Bit_matrix_t:  Matrix dimensions must be >= 0; got" \
				"#{init_num_rows} x #{init_num_cols}.  Exiting."
		end

		@num_rows = init_num_rows
		@num_cols = init_num_cols
		@rows = Array.new(@num_rows)
		for i in Range.new(0, init_num_rows, false)
			@rows[i] = Bit_vector.new(init_num_cols)
		end
	end
	attr_reader :num_rows, :num_cols, :rows

	# ----------------------------------------------------------------
	def to_s
		rv = ""
		for i in 0..(@num_rows-1)
			rv <<= @rows[i].to_s << "\n"
		end
		rv
	end

	def Bit_matrix.set_hex_output
		Bit_vector.set_hex_output
	end
	def Bit_matrix.set_binary_output
		Bit_vector.set_binary_output
	end

	# ----------------------------------------------------------------
	def [](i)
		@rows[i]
	end
	def []=(i,v)
		@rows[i] = v
	end

	# ----------------------------------------------------------------
	# Operates on the matrix in-place.

	def row_echelon_form
		self.row_reduce_below()

		for row in 0..(@num_rows-1)
			for row2 in (row+1)..(@num_rows-1)
				row2_leader_pos = @rows[row2].find_leader_pos
				if row2_leader_pos < 0
					break
				end
				row_leader_val  = @rows[row][row2_leader_pos]
				if row_leader_val == 0
					next
				end
				@rows[row].bits ^= @rows[row2].bits
			end
		end
	end

	# ----------------------------------------------------------------
	# This method makes a copy of the matrix and row-reduces it.  To save CPU
	# cycles, please use rank_rr() if the matrix is already row-reduced.
	def rank
		rr = self.clone
		rr.row_reduce_below
		rr.rank_rr
	end

	# This method assumes the matrix is already row-reduced.  If not,
	# please use rank() instead.
	def rank_rr
		rank = 0
		for i in 0..(@num_rows-1)
			if @rows[i].bits == 0
				return rank
			else
				rank += 1
			end
		end
		rank
	end

	# ----------------------------------------------------------------
	# This is a general row-reduction method.  It operates on the matrix
	# in-place.
	#
	# The "scalar" argument is used for computation of the determinant.  When
	# the determinant is not desired, this scalar is tracked anyway the
	# overhead is minimal.  Let A and B be the input and output, respectively.
	# The scalar s is such that det(A) = s det(B).
	#
	# The determinant is the unique n-linear alternating form such that det(I)
	# = 1.  This means (letting u, v, w be row vectors of a sample 3x3 matrix):
	#
	# * det(u,v,w)     = - det(v,u,w)                (alternating)
	# * det(au,v,w)    = a det(u,v,w)                (n-linear)
	# * det(u+v,v,w)   =   det(u,v,w) + det(v,v,w)   (n-linear)
	#
	# From this definition, the following results apply:
	#
	# * det(0,v,w)     =   det(0 u,v,w) = 0 det(u,v,w) = 0
	#   (Zero row => zero determinant).
	#
	# * det(v,v,w)     =   det(v,v,w)
	#   det(v,v,w)     = - det(v,v,w) (row swap)
	#   (Duplicate row => zero determinant).
	#
	# The following operations occur during row-reduction:
	#
	# * Swap rows.
	#   A = (u,v,w)                det(A) = d
	#   B = (v,u,w)     s = -1 . s det(B) = d
	#
	# * Divide by leading elements.
	#   A = ( u ,v,w)              det(A) = d
	#   B = (u/a,v,w)   s = a  . s det(B) = a * (1/a) * d = d
	#
	# * Replace u with au+bv.
	#   A = (  u ,v,w)             det(A) = d
	#   B = (au+bv,v,w) s = 1/a. s det(B) = (1/a)*(a det(au,v,w)
	#                                      + b det(v,v,w))=d

	def row_reduce_below
		top_row = 0
		left_column = 0

		while (top_row < @num_rows) && (left_column < @num_cols)
			# Find the nearest row with a non-zero value in this column.
			# Exchange that row with this one.  If this is the last row, there
			# are no rows below to pivot into place, so don't bother.
			if top_row < (@num_rows - 1)
				pivot_row = top_row
				pivot_successful = false
				while !pivot_successful && (pivot_row < @num_rows)
					if @rows[pivot_row][left_column] != 0
						if top_row != pivot_row
							temp             = @rows[top_row]
							@rows[top_row]   = @rows[pivot_row]
							@rows[pivot_row] = temp
						end
						pivot_successful = 1
					else
						pivot_row += 1
					end
				end
				if !pivot_successful
					left_column += 1
					next # Work on the next column.
				end
			end

			# We can have a zero leading element in this row if it's
			# the last row and full of zeroes.
			if @rows[top_row][left_column] != 0
				# Clear this column.
				for row in (top_row+1)..(@num_rows-1)
					current_row_lead = @rows[row][left_column]
					if current_row_lead != 0
						@rows[row].bits ^= @rows[top_row].bits
					end
				end
			end
			left_column += 1
			top_row += 1
		end
	end

	# Returns another Bit_matrix, or nil if the nullity is zero.

	def kernel_basis
		rr = self.clone
		rr.row_echelon_form
		rank = rr.rank_rr
		dimker = rr.num_cols - rank
		if dimker == 0
			return nil
		end

		basis = Bit_matrix.new(dimker, rr.num_cols)

		free_flags   = [1] * @num_cols
		free_indices = [0] * @num_cols
		nfree = 0 # Must == dimker, but I'll compute it anyway

		for i in 0..(rank-1)
			dep_pos = rr.rows[i].find_leader_pos
			if dep_pos >= 0
				free_flags[dep_pos] = 0
			end
		end

		for i in 0..(@num_cols-1)
			if free_flags[i] != 0
				free_indices[nfree] = i
				nfree += 1
			end
		end

		if nfree != dimker
			raise "Coding error detected: file #{__FILE__} line #{__LINE__}"
		end

		# For each free coefficient:
		#   Let that free coefficient be 1 and the rest be zero.
		#   Also set any dependent coefficients which depend on that
		#   free coefficient.

		for i in 0..(dimker-1)
			basis.rows[i][free_indices[i]] = 1

			# Matrix in row echelon form:
			#
			# 0210     c0 = ??      c0 = 1  c0 = 0
			# 1000     c1 = -2 c2   c1 = 0  c1 = 5
			# 0000     c2 = ??      c2 = 0  c2 = 1
			# 0000     c3 = 0       c3 = 0  c3 = 0

			# j  = 0,1
			# fi = 0,2

			# i = 0:
			#   j = 0  row 0 fi 0 = row 0 c0 = 0
			#   j = 1  row 1 fi 0 = row 1 c0 = 0
			# i = 1:
			#   j = 0  row 0 fi 1 = row 0 c2 = 2 dep_pos = 1
			#   j = 1  row 1 fi 1 = row 1 c2 = 0

			# 0001
			# 01?0

			for j in 0..(rank-1)
				if rr.rows[j][free_indices[i]] == 0
					next
				end
				dep_pos = rr.rows[j].find_leader_pos
				if dep_pos < 0
					raise "Coding error detected: file " \
						"#{__FILE__} line #{__LINE__}"
				end
				basis.rows[i][dep_pos] = rr.rows[j][free_indices[i]]
			end
		end
		return basis
	end

# ================================================================

## ----------------------------------------------------------------
#bit_matrix_t::bit_matrix_t(int e, int init_num_rows, int init_num_cols)
#{
#	if ((init_num_rows <= 0) || (init_num_cols <= 0))
#		raise
#			<< "bit_matrix_t::bit_matrix_t():  Matrix dimensions "
#			<< "must be > 0 got " << init_num_rows
#			<< " x " << init_num_cols
#			<< ".  Exiting." << std::endl
#	end
#	@num_rows = init_num_rows
#	@num_cols = init_num_cols
#	@rows = new bit_vector_t[init_num_rows]
#	for (int i = 0 i < init_num_rows; i++)
#		@rows[i] = bit_vector_t(e, init_num_cols)
#end

## ----------------------------------------------------------------
#int bit_matrix_t::load_from_file(char * file_name)
#{
#	if ((strcmp(file_name, "-") == 0) || (strcmp(file_name, "@") == 0))
#		std::cin >> *this
#		if (std::cin.fail())
#			return 0
#		else
#			return 1
#		end
#	end
#
#	std::ifstream ifs
#	ifs.open(file_name, std::ifstream::in)
#
#	if (ifs.fail())
#		std::cerr << "bit_matrix_t::load_from_file:  couldn't open \""
#			<< file_name << "\"\n"
#		return 0
#	end
#
#	ifs >> *this
#
#	if (ifs.fail())
#		std::cerr << "bit_matrix_t::load_from_file:  scan failure "
#			"reading \"" << file_name << "\"\n"
#		ifs.close()
#		return 0
#	end
#	ifs.close()
#	return 1
#end

## ----------------------------------------------------------------
#bit_matrix_t & bit_matrix_t::operator=(const bit_t scalar)
#{
#	if (@rows)
#		for (int i = 0 i < @num_rows; i++)
#			for (int j = 0 j < @num_cols; j++)
#				@rows[i].set(j, scalar)
#	else
#		@num_rows = 1
#		@num_cols = 1
#		@rows = new bit_vector_t[1]
#		@rows[0] = bit_vector_t(1)
#		@rows[0].set(0, scalar)
#	end
#	return *this
#end

## ----------------------------------------------------------------
#int bit_matrix_t::operator==(bit_matrix_t that)
#{
#	@check_dims(that, "operator==")
#	for (int i = 0 i < @num_rows; i++)
#		if (@rows[i] != that.rows[i])
#			return 0
#	return 1
#end

## ----------------------------------------------------------------
#int bit_matrix_t::operator==(bit_t e)
#{
#	for (int i = 0 i < @num_rows; i++)
#		if (@rows[i] != e)
#			return 0
#	return 1
#end

## ----------------------------------------------------------------
#bit_vector_t bit_matrix_t::operator*(
#	bit_vector_t v)
#{
#	int i, j
#	int v_num_elements = v.num_elements()
#
#	if (@num_cols != v_num_elements)
#		raise
#			<< "bit_matrix_t operator*(): Incompatibly dimensioned "
#			<< "operands ("
#			<< @num_rows << "x" << @num_cols << ","
#			<< v_num_elements << ")." << std::endl
#	end
#
#	bit_t zero(0)
#	bit_vector_t rv(zero, @num_rows)
#	for (i = 0 i < @num_rows; i++)
#		for (j = 0 j < @num_cols; j++)
#			rv.set(i, rv.get(i) + @rows[i].get(j) * v.get(j))
#
#	return rv
#end

## ----------------------------------------------------------------
## This is a private auxiliary function for the exp() method.
#
#bit_matrix_t bit_matrix_t::posexp(
#	int power,
#	bit_matrix_t & I)
#{
#	bit_matrix_t a2(*this)
#	bit_matrix_t apower = I
#
#	while (power != 0) { # Repeated squaring.
#		if (power & 1)
#			apower *= a2
#		power = (unsigned)power >> 1
#		a2 *= a2
#	end
#	return apower
#end

## ----------------------------------------------------------------
## * power >=  1:  repeated squaring
## * power ==  0:
## * power <= -1:  if singular, ret 0.  else invert & posexp the inverse.
#
# >>>> xxx use ** in ruby
#
#int bit_matrix_t::exp(
#	int power,
#	bit_matrix_t & rout)
#{
#	if (!@square?())
#		raise << "bit_matrix_t::exp():  non-square input.\n"
#	end
#
#	bit_matrix_t I = @make_I()
#	if (power >= 1)
#		rout = @posexp(power, I)
#		return 1
#	else
#		bit_matrix_t ai
#		if (!@inverse(ai))
#			return 0
#		end
#		else if (power == 0)
#			rout = I
#			return 1
#		end
#		else if (power == -power)
#			raise << "bit_matrix_t::exp:  can't handle "
#				<< "MIN_INT.\n"
#		else
#			rout = ai.posexp(-power, I)
#			return 1
#		end
#	end
#end

## ----------------------------------------------------------------
#bit_matrix_t bit_matrix_t::operator*(
#	bit_matrix_t that)
#{
#	int i, j
#
#	if (@num_cols != that.num_rows)
#		raise
#			<< "bit_matrix_t operator*(): Incompatibly "
#			<< "dimensioned operands ("
#			<< @num_rows << "x" << @num_cols << ","
#			<< that.num_rows << "x" << that.num_cols << ")."
#			<< std::endl
#	end
#
#	bit_t zero(0)
#	bit_t one(1)
#	bit_matrix_t rv(zero, @num_rows, that.num_cols)
#	bit_matrix_t thatt = that.transpose()
#
#	for (i = 0 i < @num_rows; i++)
#		for (j = 0 j < thatt.num_rows; j++)
#			bit_t dot = @rows[i].dot(thatt.rows[j])
#			if (dot == one)
#				rv[i].set(j, 1)
#		end
#	end
#	return rv
#end

## ----------------------------------------------------------------
## This is a static method.
#bit_matrix_t bit_matrix_t::outer(
#	bit_vector_t & u,
#	bit_vector_t & v)
#{
#	int m = u.num_elements()
#	int n = v.num_elements()
#	bit_matrix_t rv
#	for (int i = 0 i < m; i++)
#		for (int j = 0 j < n; j++)
#			rv[i].set(j, u.get(i) * v.get(j))
#	return rv
#end

## ----------------------------------------------------------------
#bit_matrix_t bit_matrix_t::transpose(void)
#{
#	bit_matrix_t rv(@num_cols, @num_rows)
#	for (int i = 0 i < @num_rows; i++)
#		for (int j = 0 j < @num_cols; j++)
#			rv.rows[j].set(i, @rows[i].get(j))
#	return rv
#end

## ----------------------------------------------------------------
## Makes an identity matrix with the same dimensions as *this has.
#
#bit_matrix_t bit_matrix_t::make_I(void)
#{
#	if (!@square?())
#		std::cerr << "bit_matrix_t::make_I():  non-square input.\n"
#		exit(1)
#	end
#
#	bit_matrix_t rv(*this)
#	for (int i = 0 i < @num_rows; i++)
#		for (int j = 0 j < @num_cols; j++)
#			if (i == j)
#				rv.rows[i].set(j, 1)
#			else
#				rv.rows[i].set(j, 0)
#			end
#		end
#	end
#	return rv
#end

## ----------------------------------------------------------------
#int bit_matrix_t::zero?(void)
#{
#	for (int i = 0 i < @num_rows; i++)
#		if (@rows[i].zero?())
#			return 0
#	return 1
#end

## ----------------------------------------------------------------
#int bit_matrix_t::square?(void)
#{
#	if (@num_rows == @num_cols)
#		return 1
#	else
#		return 0
#	end
#end

## ----------------------------------------------------------------
#int bit_matrix_t::I?(void)
#{
#	int i, j
#
#	if (!@square?())
#		return 0
#
#	for (i = 0 i < @num_rows; i++)
#		if (@rows[i].get(i) != 1)
#			return 0
#	end
#	for (i = 0 i < @num_rows; i++)
#		for (j = 0 j < i; j++)
#			if (@rows[i].get(j) != 0)
#				return 0
#		for (j = i+1 j < @num_cols; j++)
#			if (@rows[i].get(j) != 0)
#				return 0
#	end
#	return 1
#end

## ----------------------------------------------------------------
#unsigned ** bit_matrix_t::expose(void)
#{
#	unsigned ** ptrs = new unsigned * [@num_rows]
#	for (int i = 0 i < @num_rows; i++)
#		ptrs[i] = @rows[i].expose()
#	return ptrs
#end

## ----------------------------------------------------------------
#void bit_matrix_t::swap(int arow, int brow)
#{
#	@rows[arow].ptrswap(@rows[brow])
#end

## ----------------------------------------------------------------
## Operates on the matrix in-place.
#
#void bit_matrix_t::row_reduce_below(void)
#{
#	bit_t ignored
#	@row_reduce_below_with_scalar(ignored)
#end

## ----------------------------------------------------------------
#void bit_matrix_t::check_kernel_basis(bit_matrix_t & kerbas)
#{
#	bit_t zero(0)
#	int i
#	int dimker = kerbas.num_rows
#
#	for (i = 0 i < dimker; i++)
#		bit_vector_t Av = *this * kerbas.rows[i]
#		if (Av != zero)
#			std::cerr << "Coding error in kernel basis.\n"
#			std::cerr << "Matrix =\n"
#			std::cerr << *this
#			std::cerr << "Vector =\n"
#			std::cerr << kerbas.rows[i] << "\n"
#			std::cerr << "Product =\n"
#			std::cerr << Av << "\n"
#			std::cerr << "Zero scalar = " << zero << "\n"
#			exit(1)
#		end
#	end
#end

## ----------------------------------------------------------------
#bit_matrix_t bit_matrix_t::paste(bit_matrix_t & that)
#{
#	if (@num_rows != that.num_rows)
#		std::cerr << "bit_matrix_t::paste:  differing number of rows ("
#			<< @num_rows << " vs. "
#			<< that.num_rows << ")\n"
#		exit(1)
#	end
#
#	bit_matrix_t rv(
#		@num_rows, @num_cols + that.num_cols)
#	int i, j
#
#	for (i = 0 i < @num_rows; i++)
#		rv.rows[i] = @rows[i]
#	for (i = 0 i < @num_rows; i++)
#		for (j = 0 j < that.num_cols; j++)
#			rv.rows[i].set(@num_rows + j, that.rows[i].get(j))
#
#	return rv
#end
#
## ----------------------------------------------------------------
#void bit_matrix_t::split(
#	bit_matrix_t & rleft,
#	bit_matrix_t & rright,
#	int split_column)
#{
#	if ((split_column < 0) || (split_column >= @num_cols))
#		std::cerr << "bit_matrix_t::split:  split column "
#			<< split_column << " out of bounds 0:"
#			<< @num_rows - 1 << ".\n"
#		exit(1)
#	end
#
#	rleft  = bit_matrix_t(@num_rows, split_column)
#	rright = bit_matrix_t(@num_rows,
#		@num_cols - split_column)
#
#	int i, j
#
#	for (i = 0 i < @num_rows; i++)
#		for (j = 0 j < split_column; j++)
#			rleft.rows[i].set(j, @rows[i].get(j))
#
#	for (i = 0 i < @num_rows; i++)
#		for (j = split_column j < @num_cols; j++)
#			rright.rows[i].set(j - split_column, @rows[i].get(j))
#end
#
## ----------------------------------------------------------------
#int bit_matrix_t::inverse(bit_matrix_t & rinv)
#{
#	if (!@square?())
#		std::cerr << "bit_matrix_t::inverse():  non-square input.\n"
#		exit(1)
#	end
#
#	bit_matrix_t I = @make_I()
#	bit_matrix_t pair = @paste(I)
#	pair.row_echelon_form()
#
#	pair.split(I, rinv, @num_cols)
#	return I.I?()
#end
#
## ----------------------------------------------------------------
#void bit_matrix_t::check_inverse(bit_matrix_t & rinv)
#{
#	bit_matrix_t AB = *this * rinv
#	bit_matrix_t BA = rinv * *this
#	if (!AB.I?() || !BA.I?())
#		std::cerr << "coding error:  not really inverses.\n"
#		exit(1)
#	end
#end
#
## ----------------------------------------------------------------
#bit_t bit_matrix_t::det(void)
#{
#	if (!@square?())
#		std::cerr << "bit_matrix_t::det():  non-square input.\n"
#		exit(1)
#	end
#	bit_matrix_t rr(*this)
#	bit_t d(1)
#	rr.row_reduce_below_with_scalar(d)
#	for (int i = 0 i < @num_rows; i++)
#		if (rr.rows[i].get(i) == 0)
#			d = 0
#			break
#		end
#	end
#	return d
#end
#
## ----------------------------------------------------------------
#int bit_matrix_t::num_rows(void)
#{
#	return @num_rows
#end
#
## ----------------------------------------------------------------
#int bit_matrix_t::num_cols(void)
#{
#	return @num_cols
#end
#
## ----------------------------------------------------------------
#void bit_matrix_t::mfree(void)
#{
#	if (@rows != 0)
#		delete [] @rows
#	@nullify()
#end
#
## ----------------------------------------------------------------
#void bit_matrix_t::nullify(void)
#{
#	@rows = 0
#	@num_rows = 0
#	@num_cols = 0
#end
#
## ----------------------------------------------------------------
#void bit_matrix_t::check_dims(bit_matrix_t that, char * msg)
#{
#	if ((@num_rows != that.num_rows)
#	||  (@num_cols != that.num_cols))
#		std::cerr
#			<< "bit_matrix_t "
#			<< msg
#			<< ":  Incompatibly sized arguments ("
#			<< @num_rows << "x" << @num_cols << ", "
#			<< that.num_rows << "x" << that.num_cols << ")."
#			<< std::endl
#		exit(1)
#	end
#end

end
