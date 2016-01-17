%% @author Andrew J. Finnell
%% @copyright 2016 Andrew J. Finnell.

Definitions.

DIGIT = [0-9]
DIGIT_ = [0-9_]
WHITESPACE = [\r\n\t\s]

Rules.

(-)?{DIGIT}{DIGIT_}*(\.{DIGIT_}*)?((E|e)(\+|-)?{DIGIT}{DIGIT_}*)? : {token, validate_real(TokenLine, TokenChars)}.
{WHITESPACE}+                 : skip_token.
#.*                           : skip_token. %% comments

Erlang code.

-type lineno() :: integer().
-type token() :: {real, lineno(), float()}.

%% The '_' character is just for readability.
is_used_char($_) -> false;
is_used_char(_) -> true.

-spec validate_real(lineno(), string()) -> token().
validate_real(Line, Characters) ->
  StrippedCharacters = lists:filter(fun is_used_char/1, Characters),
  try list_to_float(StrippedCharacters) of
    Float -> {real, Line, Float}
  catch
    error:badarg ->
      {real, Line, float(list_to_integer(StrippedCharacters))}
  end.
