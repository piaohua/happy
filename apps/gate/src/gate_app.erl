%%%-------------------------------------------------------------------
%% @doc gate public API
%% @author piaohua<814004090@qq.com>
%% @end 2018-03-30 22:21:26
%%%-------------------------------------------------------------------

-module(gate_app).
-author("piaohua").

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-include("../include/online.hrl").
-include("../include/offline.hrl").

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    io:format("_StartType ~p, _StartArgs ~p~n", [_StartType, _StartArgs]),
    %% 启动服务
    inets:start(),
    ssl:start(),
    %% 启动cache服务
    application:start(cache),
    %% 初始化ETS
    init_ets(),
    {ok, Port} = application:get_env(gate, ws_port),
    case gate_sup:start_link([Port]) of
        {ok, SupPid} ->
            %% TODO
            {ok, _} = ws:start_link(Port),
            {ok, SupPid};
        {error, Error} ->
            {error, Error}
    end.

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================

init_ets() ->
    %% 在线表
    ets:new(online, [{keypos, #online.id}, named_table, public, set]),
    %% 离线表
    ets:new(offline, [{keypos, #offline.account}, named_table, public, set]),
    ok.
