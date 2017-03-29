defmodule SQL.LexerTest do
  alias SQL.Lexer
  use ExUnit.Case

  test "create table statement" do
    query = "CREATE TABLE puppies;"

    lexed_query = Lexer.process(query)

    expected = [
      %Lexer.Token{type: :create, literal: "CREATE"},
      %Lexer.Token{type: :table, literal: "TABLE"},
      %Lexer.Token{type: :table_name, literal: "puppies"},
      %Lexer.Token{type: :semicolon, literal: ";"}
    ]

    assert lexed_query == expected
  end

  test "select from table statement" do
    query = "SELECT * FROM puppies;"


    # assert
  end

end
