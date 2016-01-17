%% @author Andrew J. Finnell
%% @copyright 2016 Andrew J. Finnell.

-module(egret_compiler).

-compile({parse_transform, do}).

%% Public API

-export([file/1, format_error/1]).

file(Filename) ->
  do([error_m ||
    Contents <- read_error(file:read_file(filename:absname(Filename)), Filename),
    Tokens <- lexer_error(egret_lexer:string(binary_to_list(Contents)), Filename),
    Toplevel <- parser_error(egret_parser:parse(Tokens), Filename),
    IRModule <- egret_parser:toplevel_to_module(Toplevel, filename:rootname(filename:basename(Filename))),
    AbsForms <- egret_codegen:module(IRModule),
    egret_binarygen:forms(AbsForms)
  ]).

format_error(file_not_found) ->
  "File not found".

%% Implementation

read_error({error, _Reason}, Filename) ->
  {error, {[{Filename, [{none, ?MODULE, file_not_found}]}], []}};
read_error(Passthrough, _Filename) ->
  Passthrough.

lexer_error({ok, Tokens, _EndLine}, _Filename) ->
  {ok, Tokens};
lexer_error({error, ErrorInfo, _}, Filename) ->
  {error, {[{Filename, [ErrorInfo]}], []}}.
  
parser_error({error, ErrorInfo}, Filename) ->
  {error, {[{Filename, [ErrorInfo]}], []}};
parser_error(Passthrough, _Filename) ->
  Passthrough.
