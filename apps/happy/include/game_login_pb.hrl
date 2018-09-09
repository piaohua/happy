%% -*- coding: utf-8 -*-
%% Automatically generated, do not edit
%% Generated by gpb_compile version 4.1.3

-ifndef(game_login_pb).
-define(game_login_pb, true).

-define(game_login_pb_gpb_version, "4.1.3").

-ifndef('CWXLOGIN_PB_H').
-define('CWXLOGIN_PB_H', true).
-record('CWxLogin',
        {withCredentials = false :: boolean() | 0 | 1 | undefined, % = 1
         rawData = <<>>         :: iodata() | undefined, % = 2
         signature = <<>>       :: iodata() | undefined, % = 3
         encryptedData = <<>>   :: iodata() | undefined, % = 4
         iv = <<>>              :: iodata() | undefined % = 5
        }).
-endif.

-ifndef('SLOGIN_PB_H').
-define('SLOGIN_PB_H', true).
-record('SLogin',
        {userid = <<>>          :: iodata() | undefined, % = 1
         error = 'OK'           :: 'OK' | 'RegistFailed' | 'LoginFailed' | 'PropNotEnough' | 'GateUnreachable' | 'EnergyNotEnough' | 'CoinNotEnough' | 'DiamondNotEnough' | 'AlreadyAward' | 'AwardFailed' | 'OrderFailed' | 'Failed' | 'WSGetFailed' | 'WSLoginFailed' | 'SetShopFailed' | 'SetPropFailed' | 'SetPrizeFailed' | 'SetGateFailed' | 'EnergyEnough' | integer() | undefined % = 2, enum ErrCode
        }).
-endif.

-ifndef('CLOGIN_PB_H').
-define('CLOGIN_PB_H', true).
-record('CLogin',
        {signature = <<>>       :: iodata() | undefined, % = 1
         timestamp = 0          :: integer() | undefined % = 2, 32 bits
        }).
-endif.

-ifndef('SLOGINOUT_PB_H').
-define('SLOGINOUT_PB_H', true).
-record('SLoginOut',
        {type = 'OUT_TYPE0'     :: 'OUT_TYPE0' | 'OUT_TYPE1' | 'OUT_TYPE2' | integer() | undefined % = 1, enum OutType
        }).
-endif.

-ifndef('SWXLOGIN_PB_H').
-define('SWXLOGIN_PB_H', true).
-record('SWxLogin',
        {userid = <<>>          :: iodata() | undefined, % = 1
         error = 'OK'           :: 'OK' | 'RegistFailed' | 'LoginFailed' | 'PropNotEnough' | 'GateUnreachable' | 'EnergyNotEnough' | 'CoinNotEnough' | 'DiamondNotEnough' | 'AlreadyAward' | 'AwardFailed' | 'OrderFailed' | 'Failed' | 'WSGetFailed' | 'WSLoginFailed' | 'SetShopFailed' | 'SetPropFailed' | 'SetPrizeFailed' | 'SetGateFailed' | 'EnergyEnough' | integer() | undefined % = 2, enum ErrCode
        }).
-endif.

-endif.