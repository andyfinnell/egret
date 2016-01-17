%% @author Andrew J. Finnell
%% @copyright 2016 Andrew J. Finnell.

-module(egret_codegen).

-export([module/1]).

%% Public API

module({module, Line, ModuleName, Functions}) ->
  ModuleForm = {attribute, Line, module, list_to_atom(ModuleName)},
  {ok, [ModuleForm | functions(Functions, [])]}.
  
%% Implementation

functions([], Accumulator) ->
  Accumulator;
functions([Function | Rest], Accumulator) ->
  functions(Rest, [function(Function) | Accumulator]).

function(F = {function, Line, Prototype, _Exprs, _Module}) ->
  Args = egret_ast:prototype_args(Prototype),
  {function, Line, prototype_name_mangle(Prototype), length(Args), [function_clause(F)]}.

function_clause({function, Line, Prototype, Exprs, _Module}) ->
  Args = egret_ast:prototype_args(Prototype),
  {clause, Line, pattern_sequence(Args), [], body(Exprs)}.

pattern_sequence(Args) ->
  lists:map(fun pattern/1, Args).
    
pattern({variable, Line, Arg}) ->
  {var, Line, list_to_atom(Arg)}.

body(Exprs) ->
  lists:map(fun expr/1, Exprs).
    
expr({real, Line, Number}) ->
  {float, Line, Number}.

prototype_name_mangle({prototype, _Line, Name, _FormalArgs}) ->
  list_to_atom(Name).
