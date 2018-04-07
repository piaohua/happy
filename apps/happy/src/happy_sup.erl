%%%-------------------------------------------------------------------
%% @doc happy top level supervisor.
%% @author piaohua<814004090@qq.com>
%% @end 2018-03-30 22:22:45
%%%-------------------------------------------------------------------

-module(happy_sup).

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

-spec start_link(Args) -> {ok, pid()} when
      Args :: list().
start_link(Args) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, Args).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([_Port]) ->
    Procs = [
        % {role, {role, start_link, [Port]}, permanent, 10000, worker, [role]},
        {mongo_sup, {mongo_sup, start_link, []}, permanent, 10000, supervisor, [mongo_sup]}
    ],
    {ok, { {one_for_all, 10, 10}, Procs} }.

%%====================================================================
%% Internal functions
%%====================================================================
