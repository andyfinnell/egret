Nonterminals 
expression primary_expr number_expr toplevel.

Terminals real.

Rootsymbol toplevel.

toplevel -> expression                    : {toplevel, [], ['$1']}.

expression -> primary_expr                : '$1'.

primary_expr -> number_expr               : '$1'.

number_expr -> real                       : {real, line('$1'), unwrap('$1')}.

Erlang code.

-export([toplevel_to_module/2]).

unwrap({_,_,V}) -> V.

line({_,Line}) -> Line;
line({_,Line,_}) -> Line.
  
-type toplevel() :: {toplevel, [egret_ast:func()], [egret_ast:kalerl_expr()]}.
  
-spec toplevel_to_module(toplevel(), string()) -> {ok, egret_ast:egret_module()}.
toplevel_to_module({toplevel, Funcs, MainExprs}, ModuleName) ->
  Main = {function, 1, {prototype, 1, "main", []}, main_exprs(MainExprs), none},
  {ok, {module, 1, ModuleName, Funcs ++ [Main]}}.

-spec main_exprs([egret_ast:expr()]) -> [egret_ast:expr()].
main_exprs([]) ->
  [{real, 1, 1.0}];
main_exprs(MainExprs) ->
  MainExprs.

