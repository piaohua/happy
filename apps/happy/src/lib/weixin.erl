%%%-------------------------------------------------------------------
%% @doc weixin weixin api
%% @author piaohua<814004090@qq.com>
%% @end 2018-09-07 13:51:36
%%%-------------------------------------------------------------------
-module(weixin).

%% API
-export([
         jscode2session/4
         ,wxerr/2
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
            %Body = "{\"openid\": \"OPENID\", \"session_key\": \"SESSIONKEY\", \"unionid\": \"UNIONID\"}",
            case rfc4627:decode(Body) of
                {ok, {obj, Kvs}, _} ->
                    case lists:keyfind("errcode", 1, Kvs) of
                        {"errcode", _ErrCode} ->
                            {error, Body};
                        _ ->
                            {ok, jscode2session2(Kvs)}
                    end;
                Error ->
                    {error, wxerr("decode", Error)}
            end;
        Error ->
            {error, wxerr("httpc_request", Error)}
        catch X:Y ->
            {error, wxerr(X, Y)}
    end.

-spec jscode2session2(Kvs) -> Tuple when
      Kvs :: list(),
      Tuple :: tuple().
jscode2session2(Kvs) ->
    jscode2session2(Kvs, {<<>>, <<>>, <<>>}).
jscode2session2([{"openid", Openid}|R], {_, Skey, Uid}) ->
    jscode2session2(R, {Openid, Skey, Uid});
jscode2session2([{"session_key", SessionKey}|R], {Oid, _, Uid}) ->
    jscode2session2(R, {Oid, SessionKey, Uid});
jscode2session2([{"unionid", Unionid}|R], {Oid, Skey, _}) ->
    jscode2session2(R, {Oid, Skey, Unionid});
jscode2session2([], Tuple) ->
    Tuple.

-spec wxerr(ErrCode, ErrMsg) -> Error when
      ErrCode :: integer() | string() | atom(),
      ErrMsg :: string() | term(),
      Error :: string().
wxerr(ErrCode, ErrMsg) ->
    io_lib:format("{\"errcode\":~p,\"errmsg\":\"~p\"}", [ErrCode, ErrMsg]).
