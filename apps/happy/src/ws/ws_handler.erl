%%%-------------------------------------------------------------------
%% @doc happy ws handler API
%% @author piaohua<814004090@qq.com>
%% @end 2018-03-30 22:21:26
%%%-------------------------------------------------------------------

-module(ws_handler).
-author("piaohua").

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).
-export([websocket_terminate/2]).

-include("../../include/define.hrl").
-include("../../include/game_login_pb.hrl").

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

init(Req, Opts) ->
    ?DEBUG("init Request: ~p", [Req]),
	#{session := Session} = cowboy_req:match_qs([{session, [], undefined}], Req),
    ?DEBUG("Session ~p", [Session]),
    ?DEBUG("Opts ~p", [Opts]),
    {cowboy_websocket, Req, #{<<"session">> => Session, <<"online">> => false}, #{
        compress => true, %% frame compression extension
        idle_timeout => 30000, %% It defaults to 60000
        max_frame_size => 1024}}.

websocket_init(State) ->
    ?DEBUG("State ~p", [State]),
    #{<<"session">> := Session} = State,
    case Session of
        <<>> ->
            self() ! stop;
        _ ->
            ok
    end,
    %erlang:start_timer(1000, self(), <<"Hello!">>),
    {ok, State}.

websocket_handle(ping, State) ->
    ?INFO("websocket_handle ping"),
    {reply, pong, State};

websocket_handle({binary, BinData}, State) ->
    ?INFO("happy websocket_handle Request: ~p", [BinData]),
    case unpack:p(BinData) of 
        {ok, Msg} when is_record(Msg, 'CWxLogin') ->
            ?INFO("Msg: ~p", [Msg]),

            #{<<"session">> := Session} = State,
            case mongo_worker:find_one(<<"col_user_test">>, #{<<"session">> => Session}) of
                #{<<"session_key">> := SessionKey} when SessionKey =/= <<>> ->
                    %%验证sha1( rawData + sessionKey )
                    Sign = list_to_binary(aes:sha(Msg#'CWxLogin'.rawData, SessionKey)),
                    case Sign == Msg#'CWxLogin'.signature of
                        true ->
                            %%验证敏感信息
                            {ok, UserInfoBin} = aes:decrypt_wechat(Msg#'CWxLogin'.encryptedData, SessionKey, Msg#'CWxLogin'.iv),
                            ?INFO("UserInfoBin: ~p", [UserInfoBin]),
                            %% TODO login handler
                            UserInfoBin;
                        false -> ?ERROR("sign failed")
                    end;
                _ -> ?ERROR("session invaild")
            end;

        {ok, Msg} ->
            ?INFO("Msg: ~p", [Msg]);
        {Result, Bin} ->
            ?DEBUG("Result: ~p, Bin: ~p", [Result, Bin])
    end,
    {reply, {binary, BinData}, State};

websocket_handle({text, Msg}, State) ->
    ?INFO("happy websocket_handle Request: ~p", [Msg]),
    %% self() ! stop,
    %% self() ! close,
    {reply, {text, << "That's what she said! happy ", Msg/binary >>}, State};

websocket_handle(_Data, State) ->
    ?INFO("websocket_handle unknown Request: ~p", [_Data]),
    {ok, State}.

websocket_info({timeout, _Ref, Msg}, State) ->
    ?INFO("websocket_info Request: ~p", [Msg]),
    %erlang:start_timer(1000, self(), <<"How' you doin'?">>),
    {reply, {text, Msg}, State};

websocket_info(stop, State) ->
    ?INFO("websocket_info stop"),
    {stop, State};

websocket_info(close, State) ->
    ?INFO("websocket_info close"),
    {reply, {close, 1000, <<"some-reason">>}, State};

websocket_info(_Info, State) ->
    ?INFO("websocket_info unknown Request: ~p", [_Info]),
    {ok, State}.

websocket_terminate(Reason, _State) ->
    ?INFO("websocket_handle terminate: ~p", [Reason]),
    ok.
