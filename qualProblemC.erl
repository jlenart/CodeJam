-module(qualProblemC).
-export([convert_to_base/4, is_prime/1]).

convert_to_base(0, _Base, _Place, Sum) -> Sum;
convert_to_base(Num, Base, Place, Sum) ->
	Digit = Num rem 10,
	Sum2 = Sum + calculate_value(Digit, Base, Place),
	convert_to_base(Num div 10, Base, Place + 1, Sum2).

calculate_value(0, _Base, _Place) -> 0;
calculate_value(1, Base, Place) -> trunc(math:pow(Base, Place)).

is_prime(0) -> {false, invalid};
is_prime(1) -> {false, invalid};
is_prime(2) -> {true, prime};
is_prime(3) -> {true, prime};
is_prime(N) when N rem 2 =:= 0-> {false, 2};
is_prime(N) when N rem 3 =:= 0-> {false, 3};
is_prime(N) ->
	SqRt = trunc(math:sqrt(N)),
	check_for_divisors(4, SqRt, N).

check_for_divisors(Divisor, Divisor, N) when N rem Divisor =:= 0 -> {false, Divisor};
check_for_divisors(Divisor, Divisor, _N) -> {true, prime};
check_for_divisors(Divisor, _MaxDiv, N) when N rem Divisor =:= 0-> {false, Divisor};
check_for_divisors(Divisor, MaxDiv, N) -> check_for_divisors(Divisor+1, MaxDiv, N).
