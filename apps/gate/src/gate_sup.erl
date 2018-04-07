%%%-------------------------------------------------------------------
%% @doc gate top level supervisor.
%% @author piaohua<814004090@qq.com>
%% @end 2018-03-30 22:22:45
%%%-------------------------------------------------------------------

-module(gate_sup).

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
        % {ws, {ws, start_link, [Port]}, permanent, 10000, worker, [ws]}
    ],
    {ok, { {one_for_all, 10, 10}, Procs} }.

%%====================================================================
%% Internal functions
%%====================================================================
