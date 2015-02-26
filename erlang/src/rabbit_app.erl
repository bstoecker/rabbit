-module(rabbit_app).

-behaviour(application).

%% Application callbacks
-export([start/0, stop/0]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    spawn
    rabbit_sup:start_link().

stop(_State) ->
    ok.
