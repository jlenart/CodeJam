-module(qualProblemA).
-export([read_and_write/0]).

read_and_write() ->
	{ok, FileDesc} = file:open("input_A.txt", read),
	% first line of the file is the number of test cases
	{Iter, _} = string:to_integer(io:get_line(FileDesc, '')),
	% for each iteration, read the new N and determine the result, which is added to a list
	Results = compute(Iter, FileDesc),
	file:close(FileDesc),
	{ok, OutFd} = file:open("output_A.txt", write),
	% ouput file and count of test case starting number for printing purposes	
	write_file(OutFd, Results, 1),
	file:close(OutFd).

compute(Iter, FDesc) ->
	compute_loop(Iter, FDesc, []).

compute_loop(0, _File, Acc) -> lists:reverse(Acc);
compute_loop(Iter, File, Acc) ->
	{Num, _} = string:to_integer(io:get_line(File, '')),	
	case Num of 
		0 ->	compute_loop(Iter-1, File, [{string, "INSOMNIA"} | Acc]);
		_ ->
			Result = do_work(1, Num, sets:new()),
			compute_loop(Iter-1, File,[Result | Acc])
	end.

do_work(Mult, Num, Set) ->
	NewNum = Num*Mult,
	Digits = parse_digits(NewNum, []),
	NewSet = add_to_set(Set, Digits),
	case sets:size(NewSet) of
		10 -> NewNum;
		_ -> do_work(Mult+1, Num, NewSet)
	end.

parse_digits(0, Digits) -> Digits;
parse_digits(Num, Digits) -> 
	parse_digits(Num div 10, [Num rem 10 | Digits]).


add_to_set(Set, []) -> Set;
add_to_set(Set, [Digit | T]) -> add_to_set(sets:add_element(Digit, Set), T).

write_file(_File, [], _Count) -> ok;
write_file(File, [{string, Str} | T], Count) ->
	io:format(File, "Case #~w: ~s~n", [Count, Str]),
	write_file(File, T, Count+1);
write_file(File, [H | T], Count) ->
	io:format(File, "Case #~w: ~w~n", [Count, H]),
	write_file(File, T, Count+1).
	
