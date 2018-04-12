%%%-------------------------------------------------------------------
%% @doc Macro definition
%% @author piaohua<814004090@qq.com>
%% @end 2018-04-05 16:05:24
%%%-------------------------------------------------------------------


%% 角色在线数据
-record(online,
    {
        id              = 0     %% 角色ID
        ,account        = 0
        ,status         = 0     %% 0=末登陆,1=已登陆
        ,name           = <<>>
    }
).