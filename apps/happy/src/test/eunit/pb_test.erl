%%%-------------------------------------------------------------------
%% @doc proto test API
%% @author piaohua<814004090@qq.com>
%% @end 2018-03-30 22:21:26
%%%-------------------------------------------------------------------

-module(pb_test).
-author("piaohua").

-export([
        ]).

-include_lib("eunit/include/eunit.hrl").

% This imports the record for you to use from the generated file
-include("login_pb.hrl").

pb_msg_test() ->
    Msg = #'CLogin'{phone = "137"},
    Bin = login_pb:encode_msg(Msg),
    Msg2 = login_pb:decode_msg(Bin, 'CLogin'),
    ?_assert(Msg =:= Msg2).

basic_test_() ->
    ?_test(?assert(1 + 1 =:= 2)).
