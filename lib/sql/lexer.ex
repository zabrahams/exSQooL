defmodule SQL.Lexer do
  alias SQL.Lexer.Token

  def lex(query) do
    query
    |> split
  end

  defp split(query) do
    String.split query
  end

  defp lex_tokens(tokens) do
    Enum.map(determine_token)
  end

  #TODO define this thing!
  defp determine_token() do

  end

end
