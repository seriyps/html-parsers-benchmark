#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -pa deps/exomler/ebin
-module(exomler_parser).
-mode(compile).

-export([main/1, do_parse_test/2]).

main([FileName, N]) when is_list(N) ->
    main([FileName, list_to_integer(N)]);
main([FileName, N]) ->
    {ok, Content} = file:read_file(FileName),
    do_parse_test(Content, N).


do_parse_test(Html, N) ->
    Start = erlang:now(),
    loop(Html, N),
    Stop = erlang:now(),
    io:format("~p s~n", [timer:now_diff(Stop, Start) / 1000000]).

loop(_Html, 0) ->
    ok;
loop(Html, N) ->
    Tree = exomler:decode(Html),
    _Smth = size(Tree),
    loop(Html, N - 1).
