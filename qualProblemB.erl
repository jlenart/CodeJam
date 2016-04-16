-module(qualProblemB).
-export([read_and_write/0]).

-define(HAPPY, $+).
-define(SAD, $-).

read_and_write() ->
	{ok, FileDesc} = file:open("input_B.txt", read),
	% first line of the file is the number of test cases
	{Iter, _} = string:to_integer(io:get_line(FileDesc, '')),
	% for each iteration, read the new N and determine the result, which is added to a list
	Results = compute(Iter, FileDesc),
	file:close(FileDesc),
	{ok, OutFd} = file:open("output_B.txt", write),
	% ouput file and count of test case starting number for printing purposes	
	write_file(OutFd, Results, 1),
	file:close(OutFd).

compute(Iter, FDesc) ->
	compute_loop(Iter, FDesc, []).

compute_loop(0, _File, Acc) -> lists:reverse(Acc);
compute_loop(Iter, File, Acc) ->
	Data = string:strip(io:get_line(File, ''), right, $\n),
	AllHappy = build_happy(length(Data), []),
	Result = do_work(lists:reverse(Data), AllHappy, 0),
	compute_loop(Iter-1, File, [Result | Acc]).

do_work(AllHappy, AllHappy, Count) -> Count;
do_work(RData, AllHappy, Count) ->
	NewData = find_and_flip(RData, [], false),
	do_work(lists:reverse(NewData), AllHappy, Count + 1).	

find_and_flip([], Acc, _Flip) -> Acc;
find_and_flip([?HAPPY | Stack], Acc, false) -> find_and_flip(Stack, [?HAPPY | Acc], false);
find_and_flip([?SAD | Stack], Acc, false) -> find_and_flip(Stack, [?HAPPY | Acc], true); 
find_and_flip([?HAPPY | Stack], Acc, true) -> find_and_flip(Stack, [?SAD | Acc], true);
find_and_flip([?SAD | Stack], Acc, true) -> find_and_flip(Stack, [?HAPPY | Acc], true). 

build_happy(0, Acc) -> Acc;
build_happy(N, Acc) -> build_happy(N-1, [?HAPPY | Acc]).

write_file(_File, [], _Count) -> ok;
write_file(File, [H | T], Count) ->
	io:format(File, "Case #~w: ~w~n", [Count, H]),
	write_file(File, T, Count+1).
	
