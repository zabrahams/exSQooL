defmodule SQL.Lexer do
  alias SQL.Lexer.Token

  def process(query) do
    query
    |> space_semicolon
    |> split
    |> lex_tokens
  end

  defp space_semicolon(query) do
    query
    |> String.replace(";", " ; ")
  end

  defp split(query) do
    String.split query
  end

  defp lex_tokens(tokens) do
    Enum.map(tokens, fn x -> determine_token(x) end)
  end

  #TODO define this thing!
  defp determine_token(literal) do
    case literal do
      "CREATE" ->
        %Token{type: :create, literal: literal}
      "TABLE" ->
        %Token{type: :table, literal: literal}
      ";" ->
        %Token{type: :semicolon, literal: literal}
      _ ->
        %Token{type: :table_name, literal: literal}
    end
  end

end
