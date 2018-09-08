%%%-------------------------------------------------------------------
%% @doc weixin weixin api
%% @author piaohua<814004090@qq.com>
%% @end 2018-09-07 13:51:36
%%%-------------------------------------------------------------------
-module(weixin).

%% API
-export([
         jscode2session/4
        ]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

%% @doc jscode2session
%%
%% @spec: jscode2session(Appid::string(), Secret::string(), Query::string(), Code::string()) ->
%%      {ok, PlainText::binary()} | {error, Reason::term()}.
-spec jscode2session(Appid, Secret, Query, Code) -> {ok, Session} | {error, Reason} when
    Appid :: string(),
    Secret :: string(),
    Query :: string(),
    Code :: string(),
    Session :: string(),
    Reason :: string() | list().
jscode2session(Appid, Secret, Query, Code) ->
    Query2 = io_lib:format(Query, [Appid, Secret, Code]),
    try httpc:request(post, {Query2, [], "", ""}, [{timeout, 4000}], []) of
        {error, Reason} ->
            {error, wxerr("httpc_request", Reason)};
        {ok, {_, _, Body}} ->
            case rfc4627:decode(Body) of
                {ok, {obj, Kvs}, _} ->
                    case lists:keyfind("errcode", 1, Kvs) of
                        {"errcode", _ErrCode} ->
                            {error, Body};
                        _ ->
                            case lists:keyfind("openid", 1, Kvs) of
                                {"openid", ""} ->
                                    {error, Body};
                                {"openid", _} ->
                                    {ok, Kvs};
                                _Else ->
                                    {error, Body}
                            end
                    end;
                Error ->
                    {error, wxerr("decode", Error)}
            end;
        Error ->
            {error, wxerr("httpc_request", Error)}
        catch X:Y ->
            {error, wxerr(X, Y)}
    end.

-spec wxerr(ErrCode, ErrMsg) -> Error when
      ErrCode :: integer() | string() | atom(),
      ErrMsg :: string() | term(),
      Error :: string().
wxerr(ErrCode, ErrMsg) ->
    io_lib:format("{\"errcode\":~p,\"errmsg\":\"~p\"}", [ErrCode, ErrMsg]).
