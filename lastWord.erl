-module(lastWord).
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
	Word = string:strip(io:get_line(File, ''), right, $\n),
	Result = do_work(Word, []),
	compute_loop(Iter-1, File, [Result | Acc]).

do_work([], Acc) -> Acc;
do_work([H1 | T] , Acc =[H2 | _T2]) when H1 >= H2 -> do_work(T, [H1 | Acc]);
do_work([H | T], Acc) ->
	R = lists:reverse(Acc),
	L2 = [H | R],
	do_work(T, lists:reverse(L2)).
	
write_file(_File, [], _Count) -> ok;
write_file(File, [H | T], Count) ->
        io:format(File, "Case #~w: ~s~n", [Count, H]),
        write_file(File, T, Count+1).

