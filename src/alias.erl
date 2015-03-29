%% -*- erlang-indent-level: 4;indent-tabs-mode: nil -*-
%% ex: ts=4 sw=4 et
-module(alias).
-behaviour(provider).

-export([init/1,
         do/1,
         format_error/1]).

-define(PROVIDER, alias).
-define(DEPS, []).

%% ===================================================================
%% Public API
%% ===================================================================

-spec init(rebar_state:t()) -> {ok, rebar_state:t()}.
init(State) ->
    State1 = rebar_state:add_provider(
            State,
            providers:create([{name, ?PROVIDER},
                              {module, ?MODULE},
                              {bare, true},
                              {deps, ?DEPS},
                              {example, "rebar3 alias <alias>"},
                              {short_desc, "Runs an aliased command"},
                              {desc, desc()},
                              {opts, []}])
    ),
    {ok, State1}.

-spec do(rebar_state:t()) -> {ok, rebar_state:t()} | {error, string()}.
do(State) ->
    case rebar_state:command_args(State) of
        [Alias] ->
            case lists:keyfind(list_to_atom(Alias), 1, rebar_state:get(State, alias, [])) of
                {_, Cmd} ->
                    Tasks = rebar_utils:args_to_tasks(Cmd),
                    rebar_prv_do:do_tasks(Tasks, State);
                false ->
                    rebar_api:abort("Alias not found",[])
            end;
        _ ->
            rebar_api:abort("Alias not found",[])
    end.

-spec format_error(any()) -> iolist().
format_error(Reason) ->
    io_lib:format("~p", [Reason]).

desc() ->
    "Run an aliased command from a rebar.config file. "
    "Aliases can be single commands, declared as:\n"
    " {alias, [\n"
    "   {renamed,  [\"help\"]},\n"
    "   {cleanall, [\"clean\", \"-a\"]},\n"
    "   {testall,  [\"do\", \"ct,\", \"eunit,\", \"cover\"]},\n"
    "   {validate, [\"do\", \"ct,\", \"eunit,\", \"dialyzer\"]},\n"
    " ]}.\n"
    "Which is the programmatical format understood by Rebar3\n".
