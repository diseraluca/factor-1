#include "factor.h"

void primitive_fixnump(void)
{
	drepl(tag_boolean(TAG(dpeek()) == FIXNUM_TYPE));
}

FIXNUM to_fixnum(CELL tagged)
{
	RATIO* r;
	FLOAT* f;

	switch(type_of(tagged))
	{
	case FIXNUM_TYPE:
		return untag_fixnum_fast(tagged);
	case BIGNUM_TYPE:
		return (FIXNUM)s48_bignum_to_long((ARRAY*)UNTAG(tagged));
	case RATIO_TYPE:
		r = (RATIO*)UNTAG(tagged);
		return to_fixnum(divint(r->numerator,r->denominator));
	case FLOAT_TYPE:
		f = (FLOAT*)UNTAG(tagged);
		return (FIXNUM)f->n;
	default:
		type_error(FIXNUM_TYPE,tagged);
		return -1; /* can't happen */
	}
}

void primitive_to_fixnum(void)
{
	drepl(tag_fixnum(to_fixnum(dpeek())));
}

CELL number_eq_fixnum(FIXNUM x, FIXNUM y)
{
	return tag_boolean(x == y);
}

CELL add_fixnum(FIXNUM x, FIXNUM y)
{
	return tag_integer(x + y);
}

CELL subtract_fixnum(FIXNUM x, FIXNUM y)
{
	return tag_integer(x - y);
}

/**
 * Multiply two integers, and trap overflow.
 * Thanks to David Blaikie (The_Vulture from freenode #java) for the hint.
 */
CELL multiply_fixnum(FIXNUM x, FIXNUM y)
{
	FIXNUM prod;

	if(x == 0 || y == 0)
		return tag_fixnum(0);

	prod = x * y;
	/* if this is not equal, we have overflow */
	if(prod / x == y)
		return tag_integer(prod);

	return tag_object(
		s48_bignum_multiply(
			s48_long_to_bignum(x),
			s48_long_to_bignum(y)));
}

CELL divint_fixnum(FIXNUM x, FIXNUM y)
{
	return tag_integer(x / y);
}

CELL divfloat_fixnum(FIXNUM x, FIXNUM y)
{
	return tag_object(make_float((double)x / (double)y));
}

CELL divmod_fixnum(FIXNUM x, FIXNUM y)
{
	dpush(tag_integer(x / y));
	return tag_integer(x % y);
}

CELL mod_fixnum(FIXNUM x, FIXNUM y)
{
	return tag_fixnum(x % y);
}

FIXNUM gcd_fixnum(FIXNUM x, FIXNUM y)
{
	FIXNUM t;

	if(x < 0)
		x = -x;
	if(y < 0)
		y = -y;

	if(x > y)
	{
		t = x;
		x = y;
		y = t;
	}

	for(;;)
	{
		if(x == 0)
			return y;

		t = y % x;
		y = x;
		x = t;
	}
}

CELL divide_fixnum(FIXNUM x, FIXNUM y)
{
	FIXNUM gcd;

	if(y == 0)
		raise(SIGFPE);
	else if(y < 0)
	{
		x = -x;
		y = -y;
	}

	gcd = gcd_fixnum(x,y);
	if(gcd != 1)
	{
		x /= gcd;
		y /= gcd;
	}

	if(y == 1)
		return tag_integer(x);
	else
	{
		return tag_ratio(ratio(
			tag_integer(x),
			tag_integer(y)));
	}
}

CELL and_fixnum(FIXNUM x, FIXNUM y)
{
	return tag_fixnum(x & y);
}

CELL or_fixnum(FIXNUM x, FIXNUM y)
{
	return tag_fixnum(x | y);
}

CELL xor_fixnum(FIXNUM x, FIXNUM y)
{
	return tag_fixnum(x ^ y);
}

/*
 * Note the hairy overflow check.
 * If we're shifting right by n bits, we won't overflow as long as none of the
 * high WORD_SIZE-TAG_BITS-n bits are set.
 */
CELL shift_fixnum(FIXNUM x, FIXNUM y)
{
	if(y < 0)
		return tag_fixnum(x >> -y);
	else if(y == 0)
		return tag_fixnum(x);
	else if(y < WORD_SIZE - TAG_BITS)
	{
		FIXNUM mask = (1 << (WORD_SIZE - 1 - TAG_BITS - y));
		if(x > 0)
			mask = -mask;

		if((x & mask) == 0)
			return tag_fixnum(x << y);
	}

	return tag_object(s48_bignum_arithmetic_shift(
		s48_long_to_bignum(x),y));
}

CELL less_fixnum(FIXNUM x, FIXNUM y)
{
	return tag_boolean(x < y);
}

CELL lesseq_fixnum(FIXNUM x, FIXNUM y)
{
	return tag_boolean(x <= y);
}

CELL greater_fixnum(FIXNUM x, FIXNUM y)
{
	return tag_boolean(x > y);
}

CELL greatereq_fixnum(FIXNUM x, FIXNUM y)
{
	return tag_boolean(x >= y);
}

CELL not_fixnum(FIXNUM x)
{
	return tag_fixnum(~x);
}
