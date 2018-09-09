%% -*- coding: utf-8 -*-
%% Automatically generated, do not edit
%% Generated by gpb_compile version 4.1.3
-module(game_code_pb).

-export([encode_msg/1, encode_msg/2]).
-export([decode_msg/2, decode_msg/3]).
-export([merge_msgs/2, merge_msgs/3]).
-export([verify_msg/1, verify_msg/2]).
-export([get_msg_defs/0]).
-export([get_msg_names/0]).
-export([get_group_names/0]).
-export([get_msg_or_group_names/0]).
-export([get_enum_names/0]).
-export([find_msg_def/1, fetch_msg_def/1]).
-export([find_enum_def/1, fetch_enum_def/1]).
-export([enum_symbol_by_value/2, enum_value_by_symbol/2]).
-export([enum_symbol_by_value_ErrCode/1, enum_value_by_symbol_ErrCode/1]).
-export([get_service_names/0]).
-export([get_service_def/1]).
-export([get_rpc_names/1]).
-export([find_rpc_def/2, fetch_rpc_def/2]).
-export([get_package_name/0]).
-export([gpb_version_as_string/0, gpb_version_as_list/0]).

-include("game_code_pb.hrl").
-include("gpb.hrl").

%% enumerated types
-type 'ErrCode'() :: 'OK' | 'RegistFailed' | 'LoginFailed' | 'PropNotEnough' | 'GateUnreachable' | 'EnergyNotEnough' | 'CoinNotEnough' | 'DiamondNotEnough' | 'AlreadyAward' | 'AwardFailed' | 'OrderFailed' | 'Failed' | 'WSGetFailed' | 'WSLoginFailed' | 'SetShopFailed' | 'SetPropFailed' | 'SetPrizeFailed' | 'SetGateFailed' | 'EnergyEnough'.
-export_type(['ErrCode'/0]).

%% message types

-export_type([]).

-spec encode_msg(_) -> no_return().
encode_msg(Msg) -> encode_msg(Msg, []).


-spec encode_msg(_,_) -> no_return().
encode_msg(_Msg, _Opts) ->
    erlang:error({gpb_error, no_messages}).




-spec decode_msg(binary(), atom()) -> no_return().
decode_msg(Bin, _MsgName) when is_binary(Bin) ->
    erlang:error({gpb_error, no_messages}).

-spec decode_msg(binary(), atom(), list()) -> no_return().
decode_msg(Bin, _MsgName, _Opts) when is_binary(Bin) ->
    erlang:error({gpb_error, no_messages}).





-spec merge_msgs(_, _) -> no_return().
merge_msgs(Prev, New) -> merge_msgs(Prev, New, []).

-spec merge_msgs(_, _, _) -> no_return().
merge_msgs(_Prev, _New, _Opts) ->
    erlang:error({gpb_error, no_messages}).


-spec verify_msg(_) -> no_return().
verify_msg(Msg) -> verify_msg(Msg, []).

-spec verify_msg(_,_) -> no_return().
verify_msg(Msg, _Opts) ->
    mk_type_error(not_a_known_message, Msg, []).



-spec mk_type_error(_, _, list()) -> no_return().
mk_type_error(Error, ValueSeen, Path) ->
    Path2 = prettify_path(Path),
    erlang:error({gpb_type_error,
		  {Error, [{value, ValueSeen}, {path, Path2}]}}).


prettify_path([]) -> top_level.



get_msg_defs() ->
    [{{enum, 'ErrCode'},
      [{'OK', 0}, {'RegistFailed', 1}, {'LoginFailed', 2},
       {'PropNotEnough', 3}, {'GateUnreachable', 4},
       {'EnergyNotEnough', 5}, {'CoinNotEnough', 6},
       {'DiamondNotEnough', 7}, {'AlreadyAward', 8},
       {'AwardFailed', 9}, {'OrderFailed', 10}, {'Failed', 11},
       {'WSGetFailed', 12}, {'WSLoginFailed', 13},
       {'SetShopFailed', 14}, {'SetPropFailed', 15},
       {'SetPrizeFailed', 16}, {'SetGateFailed', 17},
       {'EnergyEnough', 18}]}].


get_msg_names() -> [].


get_group_names() -> [].


get_msg_or_group_names() -> [].


get_enum_names() -> ['ErrCode'].


-spec fetch_msg_def(_) -> no_return().
fetch_msg_def(MsgName) ->
    erlang:error({no_such_msg, MsgName}).


fetch_enum_def(EnumName) ->
    case find_enum_def(EnumName) of
      Es when is_list(Es) -> Es;
      error -> erlang:error({no_such_enum, EnumName})
    end.


find_msg_def(_) -> error.


find_enum_def('ErrCode') ->
    [{'OK', 0}, {'RegistFailed', 1}, {'LoginFailed', 2},
     {'PropNotEnough', 3}, {'GateUnreachable', 4},
     {'EnergyNotEnough', 5}, {'CoinNotEnough', 6},
     {'DiamondNotEnough', 7}, {'AlreadyAward', 8},
     {'AwardFailed', 9}, {'OrderFailed', 10}, {'Failed', 11},
     {'WSGetFailed', 12}, {'WSLoginFailed', 13},
     {'SetShopFailed', 14}, {'SetPropFailed', 15},
     {'SetPrizeFailed', 16}, {'SetGateFailed', 17},
     {'EnergyEnough', 18}];
find_enum_def(_) -> error.


enum_symbol_by_value('ErrCode', Value) ->
    enum_symbol_by_value_ErrCode(Value).


enum_value_by_symbol('ErrCode', Sym) ->
    enum_value_by_symbol_ErrCode(Sym).


enum_symbol_by_value_ErrCode(0) -> 'OK';
enum_symbol_by_value_ErrCode(1) -> 'RegistFailed';
enum_symbol_by_value_ErrCode(2) -> 'LoginFailed';
enum_symbol_by_value_ErrCode(3) -> 'PropNotEnough';
enum_symbol_by_value_ErrCode(4) -> 'GateUnreachable';
enum_symbol_by_value_ErrCode(5) -> 'EnergyNotEnough';
enum_symbol_by_value_ErrCode(6) -> 'CoinNotEnough';
enum_symbol_by_value_ErrCode(7) -> 'DiamondNotEnough';
enum_symbol_by_value_ErrCode(8) -> 'AlreadyAward';
enum_symbol_by_value_ErrCode(9) -> 'AwardFailed';
enum_symbol_by_value_ErrCode(10) -> 'OrderFailed';
enum_symbol_by_value_ErrCode(11) -> 'Failed';
enum_symbol_by_value_ErrCode(12) -> 'WSGetFailed';
enum_symbol_by_value_ErrCode(13) -> 'WSLoginFailed';
enum_symbol_by_value_ErrCode(14) -> 'SetShopFailed';
enum_symbol_by_value_ErrCode(15) -> 'SetPropFailed';
enum_symbol_by_value_ErrCode(16) -> 'SetPrizeFailed';
enum_symbol_by_value_ErrCode(17) -> 'SetGateFailed';
enum_symbol_by_value_ErrCode(18) -> 'EnergyEnough'.


enum_value_by_symbol_ErrCode('OK') -> 0;
enum_value_by_symbol_ErrCode('RegistFailed') -> 1;
enum_value_by_symbol_ErrCode('LoginFailed') -> 2;
enum_value_by_symbol_ErrCode('PropNotEnough') -> 3;
enum_value_by_symbol_ErrCode('GateUnreachable') -> 4;
enum_value_by_symbol_ErrCode('EnergyNotEnough') -> 5;
enum_value_by_symbol_ErrCode('CoinNotEnough') -> 6;
enum_value_by_symbol_ErrCode('DiamondNotEnough') -> 7;
enum_value_by_symbol_ErrCode('AlreadyAward') -> 8;
enum_value_by_symbol_ErrCode('AwardFailed') -> 9;
enum_value_by_symbol_ErrCode('OrderFailed') -> 10;
enum_value_by_symbol_ErrCode('Failed') -> 11;
enum_value_by_symbol_ErrCode('WSGetFailed') -> 12;
enum_value_by_symbol_ErrCode('WSLoginFailed') -> 13;
enum_value_by_symbol_ErrCode('SetShopFailed') -> 14;
enum_value_by_symbol_ErrCode('SetPropFailed') -> 15;
enum_value_by_symbol_ErrCode('SetPrizeFailed') -> 16;
enum_value_by_symbol_ErrCode('SetGateFailed') -> 17;
enum_value_by_symbol_ErrCode('EnergyEnough') -> 18.


get_service_names() -> [].


get_service_def(_) -> error.


get_rpc_names(_) -> error.


find_rpc_def(_, _) -> error.



-spec fetch_rpc_def(_, _) -> no_return().
fetch_rpc_def(ServiceName, RpcName) ->
    erlang:error({no_such_rpc, ServiceName, RpcName}).


get_package_name() -> pb.



gpb_version_as_string() ->
    "4.1.3".

gpb_version_as_list() ->
    [4,1,3].