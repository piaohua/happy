%%%-------------------------------------------------------------------
%% @doc unpack API
%% @author piaohua<814004090@qq.com>
%% @end 2018-04-09 16:33:00
%%%-------------------------------------------------------------------

-module(unpack).
-author("piaohua").

-export([p/1]).

-include("login_pb.hrl").

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

-spec p(Bin) -> {ok, Msg} | {error, undefined} when
      Bin :: binary(),
      Msg :: any().
p(<<Code:32, Bin/binary>>) ->
    p(Code, Bin);

p(_) ->
    {error, undefined}.

p(10000, Bin) ->
    {ok, login_pb:decode_msg(Bin, 'CLogin')};
p(_Code, _Bin) ->
    {error, undefined}.
