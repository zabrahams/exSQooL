defmodule SQL.Lexer do
  alias SQL.Lexer.Token

  def process(query) do
    query
    |> space_semicolon
    |> space_commas
    |> split
    |> lex_tokens
  end

  defp space_semicolon(query) do
    query
    |> String.replace(";", " ; ")
  end

  def space_commas(query) do
    query
    |> String.replace(",", " , ")
  end

  defp split(query) do
    String.split query
  end

  defp lex_tokens(tokens) do
    Enum.map(tokens, fn x -> determine_token(x) end)
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
        %Token{type: :*, literal: literal}
      upcased == "WHERE" ->
        %Token{type: :where, literal: literal}
      upcased == "=" ->
        %Token{type: :=, literal: literal}
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

  def lex('', _, tokens),  do: tokens
  def lex(input, nil, tokens) do
    [partial_token | remainder] = input
    lex(remainder, partial_token, tokens)
  end
  def lex(input, partial_token, tokens) when is_sql_string(partial_token) do
    if Enum.at(input, 0) == ?'&& Enum.at(partial_token, -1) != ?\ do
      ...


  end

  def is_sql_string(input) do
    Enum.at(input, 0) == ?'
  end

end
