%%%-------------------------------------------------------------------
%% @doc happy http post handler API
%% @author piaohua<814004090@qq.com>
%% @end 2018-03-30 22:21:26
%%%-------------------------------------------------------------------

-module(post_handler).
-author("piaohua").

-export([init/2]).

-include("../../include/define.hrl").

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

init(Req0, Opts) ->
	Method = cowboy_req:method(Req0),
	HasBody = cowboy_req:has_body(Req0),
	Req = maybe_echo(Method, HasBody, Req0),
	{ok, Req, Opts}.

maybe_echo(<<"POST">>, true, Req0) ->
	{ok, PostVals, Req} = cowboy_req:read_urlencoded_body(Req0),
	Echo = proplists:get_value(<<"echo">>, PostVals),
    ?INFO("js_code get: ~p", [Echo]),
	Code = proplists:get_value(<<"js_code">>, PostVals),
    ?INFO("js_code get: ~p", [Code]),
	echo(Echo, Code, Req);
maybe_echo(<<"POST">>, false, Req) ->
	cowboy_req:reply(400, #{}, <<"Missing body.">>, Req);
maybe_echo(_, _, Req) ->
	%% Method not allowed.
	cowboy_req:reply(405, Req).

echo(undefined, _, Req) ->
	cowboy_req:reply(400, #{}, <<"Missing echo parameter.">>, Req);
echo(<<"session">>, _, Req) ->
    Out = os:cmd("head /dev/urandom | od -x | tr -d ' ' | cut -c8- | head -c 32"),
    ?INFO("out ~p", [Out]),
	cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain; charset=utf-8">>
	}, Out, Req);
echo(<<"js_code">>, undefined, Req) ->
	cowboy_req:reply(400, #{}, <<"Missing js_code parameter.">>, Req);
echo(<<"js_code">>, <<>>, Req) ->
	cowboy_req:reply(200, #{}, <<"Missing js_code parameter.">>, Req);
echo(<<"js_code">>, Code, Req) ->
    ?INFO("js_code get: ~p", [Code]),
    Out = os:cmd("head /dev/urandom | od -x | tr -d ' ' | cut -c8- | head -c 32"),
    ?INFO("out ~p", [Out]),
	cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain; charset=utf-8">>
	}, Out, Req);
echo(Echo, _, Req) ->
    ?INFO("echo get: ~p", [Echo]),
	cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain; charset=utf-8">>
	}, Echo, Req).
