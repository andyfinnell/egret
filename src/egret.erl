%% @author Andrew J. Finnell
%% @copyright 2016 Andrew J. Finnell.

-module(egret).

-export([main/1]).

%% Public API

-spec main(list()) -> ok.
main(Args) ->
	execute(Args).

%% Implementation

-spec execute(list()) -> ok.
execute([Filename]) ->  
  process_parse(egret_compiler:file(Filename), Filename);
execute(_Args) ->
	usage().

process_parse({ok, ModuleName, Binary, Warnings}, Filename) ->
  ok = write_beam(filename:dirname(Filename), ModuleName, Binary),
  print_errors(Warnings, "Warning", Filename),
  io:format("Success: ~p.~n", [ModuleName]);
process_parse({error, {Errors, Warnings}}, Filename) ->
  print_errors(Errors, "Error", Filename),
  print_errors(Warnings, "Warning", Filename),
  io:format("Failure.~n").

print_errors(Errors, Type, Filename) ->
  PrintError = fun(Info) -> print_error(Info, Type, Filename) end,
  lists:foreach(PrintError, Errors).

print_error({_Filename, ErrorInfos}, Type, Filename) ->
  PrintError = fun(Info) -> print_error_info(Info, Type, Filename) end,
  lists:foreach(PrintError, ErrorInfos).
  
print_error_info({Line, Module, Descriptor}, Type, Filename) ->
  ErrorString = Module:format_error(Descriptor),
  io:format("~s:~p: ~s: ~s~n", [Filename, Line, Type, ErrorString]).

write_beam(Dirname, ModuleName, Binary) ->
  Filename = filename:join(Dirname, string:concat(atom_to_list(ModuleName), ".beam")),
  file:write_file(Filename, Binary).
  
-spec usage() -> ok.
usage() ->
	io:format("Usage: egret <path-to-compile>...~n"),
	ok.