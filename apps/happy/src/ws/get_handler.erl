%%%-------------------------------------------------------------------
%% @doc happy http get handler API
%% @author piaohua<814004090@qq.com>
%% @end 2018-03-30 22:21:26
%%%-------------------------------------------------------------------

-module(get_handler).
-author("piaohua").

-export([init/2]).

-include("../../include/define.hrl").
-include("../../include/login_pb.hrl").

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

init(Req0, Opts) ->
	Method = cowboy_req:method(Req0),
	#{echo := Echo} = cowboy_req:match_qs([{echo, [], undefined}], Req0),
	Req = echo(Method, Echo, Req0),
	{ok, Req, Opts}.

echo(<<"GET">>, undefined, Req) ->
	cowboy_req:reply(400, #{}, <<"Missing echo parameter.">>, Req);
echo(<<"GET">>, <<"session">>, Req) ->
    Out = os:cmd("head /dev/urandom | od -x | tr -d ' ' | cut -c8- | head -c 32"),
    ?INFO("out ~p", [Out]),
	cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain; charset=utf-8">>
	}, Out, Req);
echo(<<"GET">>, <<"aes">>, Req) ->
    Mac = aes:sha_example(),
    ?INFO("Mac ~p", [Mac]),
    B = aes:aes_example(),
    ?INFO("Mac ~p", [B]),
	cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain; charset=utf-8">>
	}, Mac, Req);
echo(<<"GET">>, <<"packet">>, Req) ->
    S2C = #'SLogin'{
             userid = <<"222">>
            },
    case packet:p(S2C) of 
        {ok, Bin} ->
            ?DEBUG("Bin: ~p", [Bin]);
        {Result, Bin} ->
            ?DEBUG("Result: ~p, Bin: ~p", [Result, Bin])
    end,
	cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain; charset=utf-8">>
	}, <<"ok">>, Req);
echo(<<"GET">>, <<"unpack">>, Req) ->
    C2S = #'CLogin'{
             phone = <<"111">>,
             password = <<"sss">>
             },
    case unpack:p(C2S) of 
        {ok, Bin2} ->
            ?DEBUG("Bin: ~p", [Bin2]);
        {Result2, Bin2} ->
            ?DEBUG("Result: ~p, Bin: ~p", [Result2, Bin2])
    end,
	cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain; charset=utf-8">>
	}, <<"ok">>, Req);
echo(<<"GET">>, <<"js_code">>, Req) ->
	#{js_code := Code} = cowboy_req:match_qs([{js_code, [], undefined}], Req),
    ?INFO("js_code get: ~p", [Code]),
    %% 返回 3rd_session
    {ok, Appid} = application:get_env(happy, appid),
    {ok, Secret} = application:get_env(happy, secret),
    {ok, Query} = application:get_env(happy, jscode2session),
    %Body = "{\"errcode\":40013,\"errmsg\":\"invalid appid, hints: [ req_id: oA4pda0426hb41 ]\"}",
    %Body = "{\"openid\": \"OPENID\", \"session_key\": \"SESSIONKEY\", \"unionid\": \"UNIONID\"}",
    case weixin:jscode2session(Appid, Secret, Query, Code) of
        {ok, Tuple} ->
            ?INFO("Tuple: ~p", [Tuple]),
            Result = echo2(Tuple),
            cowboy_req:reply(200, #{
              <<"content-type">> => <<"text/plain; charset=utf-8">>
             }, Result, Req);
        {error, Body} ->
            cowboy_req:reply(200, #{
              <<"content-type">> => <<"text/plain; charset=utf-8">>
             }, list_to_binary(Body), Req)
    end;
echo(<<"GET">>, Echo, Req) ->
    ?INFO("echo get: ~p", [Echo]),
	cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain; charset=utf-8">>
	}, Echo, Req);
echo(_, _, Req) ->
	%% Method not allowed.
	cowboy_req:reply(405, Req).

-spec echo2(Tuple) -> Result when
      Tuple :: tuple(),
      Result :: string().
echo2({Openid, SessionKey, Unionid}) when Openid =/= <<>>, SessionKey =/= <<>>, Unionid =/= <<>> ->
    case mongo_worker:find_one(<<"col_user_test">>, #{<<"openid">> => Openid}) of
        undefined ->
            Session = os:cmd("head /dev/urandom | od -x | tr -d ' ' | cut -c8- | head -c 32"),
            Docs = #{<<"openid">> => Openid, <<"session_key">> => SessionKey,
                     <<"unionid">> => Unionid, <<"session">> => list_to_binary(Session)},
            case mongo_worker:insert(<<"col_user_test">>, Docs) of
                {{true, #{<<"n">> := 1}}, _} ->
                    WSAddr = "ws://127.0.0.1:8091",
                    Result = io_lib:format("{\"session\":\"~s\",\"wsaddr\":\"~p\"}", [Session, WSAddr]),
                    Result;
                Error -> 
                    ?ERROR("insert error ~p", [Error]),
                    weixin:wxerr("insert", "insert failed")
            end;
        #{<<"_id">> := ID, <<"session">> := Session} ->
            Docs = #{<<"$set">> => #{<<"session_key">> => SessionKey}},
            case mongo_worker:update(<<"col_user_test">>, #{<<"_id">> => ID}, Docs) of
                {true, #{<<"n">> := 1}} ->
                    WSAddr = "ws://127.0.0.1:8090",
                    Result = io_lib:format("{\"session\":\"~s\",\"wsaddr\":\"~p\"}", [binary_to_list(Session), WSAddr]),
                    Result;
                Error ->
                    ?ERROR("update error ~p", [Error]),
                    weixin:wxerr("update", "update failed")
            end
    end;
echo2(_) -> weixin:wxerr("error", "not found").
