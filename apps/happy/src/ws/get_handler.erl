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
	cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain; charset=utf-8">>
	}, <<"session">>, Req);
echo(<<"GET">>, Echo, Req) ->
    ?INFO("echo get: ~p", [Echo]),
	cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain; charset=utf-8">>
	}, Echo, Req);
echo(_, _, Req) ->
	%% Method not allowed.
	cowboy_req:reply(405, Req).

