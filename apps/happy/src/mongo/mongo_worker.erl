%%%-------------------------------------------------------------------
%%% @author piaohua
%%% @copyright (C) 2018, piaohua
%%% @doc
%%%
%%% @end
%%% Created : 2018-04-06 18:24:31.476564
%%%-------------------------------------------------------------------
-module(mongo_worker).

%% API
-export([
         insert/2
         ,insert/3
         ,update/3
         ,update/4
         ,updates/3
         ,updates/4
         ,upsert/3
         ,upsert/4
         ,find/2
         ,find/3
         ,find/4
         ,find_one/2
         ,find_one/3
         ,count/2
         ,count/3
        ]).

-define(DEFAULT_POOL, pool1).

%%%===================================================================
%%% API
%%%===================================================================

-spec insert(Collection, Docs) -> 
    {{boolean(), map()}, map() | list()} when
      Collection :: binary(),
      Docs :: map() | list().
insert(Collection, Docs) ->
    insert(?DEFAULT_POOL, Collection, Docs).

insert(PoolName, Collection, Docs) ->
    poolboy:transaction(PoolName, fun(Worker) ->
    mc_worker_api:insert(Worker, Collection, Docs)
    end).

-spec update(Collection, Selector, Docs) -> {boolean(), map()} when
      Collection :: binary(),
      Selector :: map(),
      Docs :: map() | list().
update(Collection, Selector, Docs) ->
    update(?DEFAULT_POOL, Collection, Selector, Docs).

update(PoolName, Collection, Selector, Docs) ->
    poolboy:transaction(PoolName, fun(Worker) ->
    mc_worker_api:update(Worker, Collection, Selector, Docs)
    end).

updates(Collection, Selector, Docs) ->
    updates(?DEFAULT_POOL, Collection, Selector, Docs).

updates(PoolName, Collection, Selector, Docs) ->
    poolboy:transaction(PoolName, fun(Worker) ->
    mc_worker_api:update(Worker, Collection, Selector, Docs, false, true)
    end).

upsert(Collection, Selector, Docs) ->
    upsert(?DEFAULT_POOL, Collection, Selector, Docs).
upsert(PoolName, Collection, Selector, Docs) ->
    poolboy:transaction(PoolName, fun(Worker) ->
    mc_worker_api:update(Worker, Collection, Selector, Docs, true, false)
    end).

-spec find(Collection, Selector) -> list() when
      Collection :: binary(),
      Selector :: map().
find(Collection, Selector) ->
    find(?DEFAULT_POOL, Collection, Selector, #{}).
find(Collection, Selector, Args) ->
    find(?DEFAULT_POOL, Collection, Selector, Args).
find(PoolName, Collection, Selector, Args) ->
    poolboy:transaction(PoolName, fun(Worker) ->
    case mc_worker_api:find(Worker, Collection, Selector, Args) of
        [] -> [];
        {ok, Cursor} when is_pid(Cursor) ->
            mc_cursor:rest(Cursor);
        _ -> []
    end
    end).

-spec find_one(Collection, Selector) -> map() | undefined when
      Collection :: binary(),
      Selector :: map().
find_one(Collection, Selector) ->
    find_one(?DEFAULT_POOL, Collection, Selector).
find_one(PoolName, Collection, Selector) ->
    poolboy:transaction(PoolName, fun(Worker) ->
    mc_worker_api:find_one(Worker, Collection, Selector)
    end).

-spec count(Collection, Selector) -> integer() when
      Collection :: binary(),
      Selector :: map().
count(Collection, Selector) ->
    count(?DEFAULT_POOL, Collection, Selector).

count(PoolName, Collection, Selector) ->
    poolboy:transaction(PoolName, fun(Worker) ->
    mc_worker_api:count(Worker, Collection, Selector)
    end).

%%%===================================================================
%%% Internal functions
%%%===================================================================
