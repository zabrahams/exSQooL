defmodule SQL.Lexer do
  alias SQL.Lexer.Token

  def process(query) do
    lex(query, nil, []) |>
    reverse
  end

  #TODO define this thing!
  defp determine_token(literal) do
    upcased = String.upcase(literal)
    cond do
     upcased == "CREATE" ->
        %Token{type: :create, literal: literal}
      upcased == "TABLE" ->
        %Token{type: :table, literal: literal}
      upcased == ";" ->
        %Token{type: :semicolon, literal: literal}
      upcased == "SELECT" ->
        %Token{type: :select, literal: literal}
      upcased == "FROM" ->
        %Token{type: :from, literal: literal}
      upcased == "*" ->
        %Token{type: :star, literal: literal}
      upcased == "WHERE" ->
        %Token{type: :where, literal: literal}
      upcased == "=" ->
        %Token{type: :equals, literal: literal}
      upcased == "" ->
        %Token{type: :integer, literal: literal}
      upcased == "," ->
        %Token{type: :comma, literal: literal}
      String.match?(upcased, ~r(\d+)) ->
        %Token{type: :integer, literal: literal}
      true ->
        %Token{type: :identifier, literal: literal}
    end
  end

  def lex('', nil, tokens),  do: tokens
  def lex(input, nil, tokens) do
    [partial_token | remainder] = input
    lex(remainder, partial_token, tokens)
  end
  def lex(input, partial_token, tokens) when is_whitespace?(partial_token) do
    lex(input, nil, tokens)
  end
  def lex(input, partial_token, tokens) when is_sql_string?(partial_token) do
    lex_string(input, partial_token, tokens)
  end
  def lex(input, partial_token, tokens) when is_sql_symbol?(partial_token) do
    lex_symbol(input, partial_token, tokens)
  end
  def lex(input, parital_token, tokens) when is_characteraliscious?(partial_token) do
    lex_command_or_ident(input, partial_token, tokens)
  end

  def lex_string(input, partial_token, tokens) do
    cond do
      is_sql_string?(input) && Enum.at(partial_token, -1) != ?\ ->
        remainder = tl(input)
        literal = tl(partial_token)
        new_token = %Token{type: :string, literal: List.to_string(literal)}
        lex(remainder, nil, [new_token | tokens])
      _ ->
        [new_input | remainder] = input
        lex(remainder, partial_token ++ [new_input], tokens)
    end
  end

  def lex_command_or_ident(input, partial_token, tokens) do
    cond do
      is_characeraliscious?(input) || is_numeric?(input) ->
        [new_input | remainder] = input
        lex_command_or_ident(remainder, partial_token ++ [new_input], tokens)
      true ->
        new_token = get_command_or_ident(partial_token)
        lex(input, nil, [new_token | token])
    end
  end

  def get_command_or_ident(literal) do
    string_literal = List.to_string(literal)
    case String.upcase(string_literal) do
      "CREATE" ->
        %Token{type: :create, literal: string_literal}
      "TABLE" ->
        %Token{type: :table, literal: string_literal}
      "SELECT" ->
        %Token{type: :select, literal: string_literal}
      "FROM" ->
        %Token{type: :from, literal: string_literal}
      "WHERE" ->
        %Token{type: :where, literal: string_literal}
      _ ->
        %Token{type: :identifier, literal: string_literal}
    end
  end


  def lex_symbol(input, partial_token, tokens) do
    case partial_token do
      ?; ->
        new_token = %Token{type: :semicolon, literal: ";"}
        lex(input, nil, [new_token | tokens])
      ?= ->
        new_token = %Token{type: :equals, literal: "="}
        lex(input, nil, [new_token | tokens])
      ?, ->
        new_token =  %Token{type: :comma, literal: ","}
        lex(input, nil, [new_token | tokens])
      # Lex Super Star
      ?* ->
        new_token =  %Token{type: :asterisk, literal: "*"}
        lex(input, nil, [new_token | tokens])
      ?> ->
        lex_greater_than(input, partial_token, tokens)
      ?< ->
        lex_less_than(input, partial_token, tokens)
    end
  end

  def lex_greater_than(input, partial_token, tokens) do
    case Enum.at(input, 0) do
      ?= ->
        new_token = %Token{type: :greater_equals, literal: ">="}
        lex(tl(input), nil, [new_token | tokens])
      _ ->
        new_token = %token{type: :greater_than, literal: ">"}
        lex(input, nil, [new_token | tokens])
    end
  end

  def lex_less_than(input, partial_token, tokens) do
    case Enum.at(input, 0) do
      ?= ->
        new_token = %Token{type: :less_equals, literal: "<="}
        lex(tl(input), nil, [new_token | tokens])
      ?> ->
        new_token = %Token{type: :not_equals, literal: "<>"}
        lex(tl(input), nil, [new_token | tokens])
      _ ->
        new_token = %token{type: :less_than, literal: "<"}
        lex(input, nil, [new_token | tokens])
    end
  end

  def is_sql_symbol?(input) do
    case Enum.at(input, 0) do
      ?;, ?,, ?=, ?>, ?<, ?* -> true
      _ -> false
    end
  end

  def is_sql_string?(input) do
    Enum.at(input, 0) == ?'
  end

  def is_whitespace?(input) do
    case Enum.at(input, 0) do
      9, 10, 12, 13, 32 -> true
      _ -> false
    end
  end

  def is_characteraliscious?(input) do
    first_char = Enum.at(input, 0)
    first_char in 60..90 || first_char in 97..122
  end
end
