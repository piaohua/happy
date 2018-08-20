%%%-------------------------------------------------------------------
%% @doc gate ws API
%% @author piaohua<814004090@qq.com>
%% @end 2018-03-30 22:21:26
%%%-------------------------------------------------------------------

-module(ws).
-author("piaohua").

-export([start_link/1]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link(Port) ->
    Dispatch = cowboy_router:compile([
        {'_', [
             {"/", cowboy_static, {priv_file, gate, "index.html"}},
             {"/websocket", ws_handler, []},
             {"/static/[...]", cowboy_static, {priv_dir, gate, "static"}}
        ]}
    ]),
    case cowboy:start_clear(http, [{port, Port}, {max_connections, 1024}],
        #{env => #{dispatch => Dispatch}}) of
        {ok, Pid} ->
            {ok, Pid};
        {error, Error} ->
            {error, Error}
    end.
