-module(rankAndFile).
-export([read_and_write/0]).

read_and_write() ->
        {ok, FileDesc} = file:open("input_B.txt", read),
        {Iter, _} = string:to_integer(io:get_line(FileDesc, '')),
        Results = compute(Iter, FileDesc),
        file:close(FileDesc),
        {ok, OutFd} = file:open("output_B.txt", write),
        write_file(OutFd, Results, 1),
        file:close(OutFd).


compute(Iter, FDesc) ->
        compute_outer_loop(Iter, FDesc, []).

compute_outer_loop(0, _File, Acc) -> lists:reverse(Acc);
compute_outer_loop(Iter, File, Acc) ->
        {Num, _} = string:to_integer(io:get_line(File, '')),
	Result = inner_loop(2*Num-1, File, maps:new()),
        compute_outer_loop(Iter-1, File, [Result | Acc]).

inner_loop(0, _File, Map) ->
	List = maps:to_list(Map),
	Unsorted = [Key || {Key, Value} <- List, Value rem 2 =/= 0],
	lists:sort(Unsorted);
inner_loop(Iter, File, Map) ->
	Tokens = string:tokens(string:strip(io:get_line(File, ''), right, $\n), " "),
	Map2 = add_or_insert(Tokens, Map),
	inner_loop(Iter-1, File, Map2).

add_or_insert([], Map) -> Map;
add_or_insert([H | T], Map) ->
	{Key, _} = string:to_integer(H),
	Map2 = case maps:is_key(Key, Map) of
		false -> maps:put(Key, 1, Map);
		true -> 
			Value = maps:get(Key, Map),
			maps:update(Key, Value+1, Map)
		end,
	add_or_insert(T, Map2).


write_file(_File, [], _Count) -> ok;
write_file(File, [H | T], Count) ->
        io:format(File, "Case #~w: ", [Count]),
        print_list(H, File),
	write_file(File, T, Count+1).

print_list([], File) ->
        io:format(File, "~n", []);
print_list([H|T], File) ->
        io:format(File, "~w ", [H]),
	print_list(T, File).

