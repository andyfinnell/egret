%% @author Andrew J. Finnell
%% @copyright 2016 Andrew J. Finnell.

-module(egret_ast).

-export([prototype_name/1, prototype_args/1]).

-type lineno() :: integer().
-type variable() :: {variable, lineno(), string()}.


%% Base type for all expression nodes. 
-type expr() ::  
  %% variant for numeric literals like "1.0".
    {real, lineno(), float()}.

%% Function prototype. Name and arguments
-type proto() :: {prototype, lineno(), string(), [variable()]}.

%% Function definition
-type func() :: {function, lineno(), proto(), [expr()], atom() | none}.

-type egret_module() :: {module, lineno(), string(), [func()]}.

-export_type([expr/0, proto/0, func/0, egret_module/0, lineno/0]).

%% Helper functions

prototype_name({prototype, _Line, Name, _FormalArgs}) -> Name.

prototype_args({prototype, _Line, _Name, FormalArgs}) -> FormalArgs.

