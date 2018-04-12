%%%-------------------------------------------------------------------
%% @doc Macro definition
%% @author piaohua<814004090@qq.com>
%% @end 2018-03-30 22:21:26
%%%-------------------------------------------------------------------

-define(DEBUG(Format, Args), lager:debug(Format, Args)).
-define(INFO(Format, Args), lager:info(Format, Args)).
-define(NOTICE(Format, Args), lager:notice(Format, Args)).
-define(WARN(Format, Args), lager:warning(Format, Args)).
-define(ERROR(Format, Args), lager:error(Format, Args)).
-define(CRIT(Format, Args), lager:critical(Format, Args)).
-define(ALERT(Format, Args), lager:critical(Format, Args)).
-define(EMERG(Format, Args), lager:emergency(Format, Args)).

-define(DEBUG(Format), lager:debug(Format)).
-define(INFO(Format), lager:info(Format)).
-define(NOTICE(Format), lager:notice(Format)).
-define(WARN(Format), lager:warning(Format)).
-define(ERROR(Format), lager:error(Format)).
-define(CRIT(Format), lager:critical(Format)).
-define(ALERT(Format), lager:critical(Format)).
-define(EMERG(Format), lager:emergency(Format)).
