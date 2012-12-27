#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -pa deps/mochiweb/ebin
-module(parser).
-mode(compile).

-export([main/1, do_parse_test/2]).

main([FileName, N]) when is_list(N) ->
    main([FileName, list_to_integer(N)]);
main([FileName, N]) ->
    {ok, Content} = file:read_file(FileName),
    Result = do_parse_test(Content, N),
    io:format("~p s~n", [Result / 1000000]).
    %% fprof:apply(fun() -> do_parse_test(Content, N) end, []),
    %% io:format("profile.."),
    %% fprof:profile(),
    %% io:format("analyse.."),
    %% fprof:analyse([{dest, []}]).


do_parse_test(Html, N) ->
    {Microseconds, _ReturnValue} = timer:tc(fun loop/2, [Html, N]),
    Microseconds.

loop(_Html, 0) ->
    ok;
loop(Html, N) ->
    Tree = mochiweb_html:parse(Html),
    _Smth = size(Tree),
    loop(Html, N - 1).
