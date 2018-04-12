%%%-------------------------------------------------------------------
%% @doc packet API
%% @author piaohua<814004090@qq.com>
%% @end 2018-04-09 16:32:54
%%%-------------------------------------------------------------------

-module(packet).
-author("piaohua").

-export([p/1]).

-include("login_pb.hrl").

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

-spec p(Msg) -> {ok, Bin} | {error, undefined} when
      Bin :: binary(),
      Msg :: any().
p(Msg) when is_record(Msg, 'SLogin') ->
    Bin = login_pb:encode_msg(Msg),
    {ok, <<10000:32, Bin/binary>>};

p(_Msg) ->
    {error, undefined}.
