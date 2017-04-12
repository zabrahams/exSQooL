defmodule SQL.LexerTest do
  alias SQL.Lexer
  use ExUnit.Case

  test "create table statement" do
    query = "CREATE TABLE puppies;"

    lexed_query = Lexer.process(query)

    expected = [
      %Lexer.Token{type: :create, literal: "CREATE"},
      %Lexer.Token{type: :table, literal: "TABLE"},
      %Lexer.Token{type: :identifier, literal: "puppies"},
      %Lexer.Token{type: :semicolon, literal: ";"}
    ]

    assert lexed_query == expected
  end

  test "select from table statement" do
    query = "SELECT * FROM puppies;"

    lexed_query = Lexer.process(query)

    expected = [
      %Lexer.Token{type: :select, literal: "SELECT"},
      %Lexer.Token{type: :*, literal: "*"},
      %Lexer.Token{type: :from, literal: "FROM"},
      %Lexer.Token{type: :identifier, literal: "puppies"},
      %Lexer.Token{type: :semicolon, literal: ";"}
    ]

    assert lexed_query == expected
  end

  test "select from table statement is case insensitive" do
    query = "select * from puppies;"

    lexed_query = Lexer.process(query)

    expected = [
      %Lexer.Token{type: :select, literal: "select"},
      %Lexer.Token{type: :*, literal: "*"},
      %Lexer.Token{type: :from, literal: "from"},
      %Lexer.Token{type: :identifier, literal: "puppies"},
      %Lexer.Token{type: :semicolon, literal: ";"}
    ]

    assert lexed_query == expected
  end


  test "select with columns from table statement" do
    query = "SELECT tails, ears FROM puppies;"

    lexed_query = Lexer.process(query)

    expected = [
      %Lexer.Token{type: :select, literal: "SELECT"},
      %Lexer.Token{type: :identifier, literal: "tails"},
      %Lexer.Token{type: :comma, literal: ","},
      %Lexer.Token{type: :identifier, literal: "ears"},
      %Lexer.Token{type: :from, literal: "FROM"},
      %Lexer.Token{type: :identifier, literal: "puppies"},
      %Lexer.Token{type: :semicolon, literal: ";"}
    ]

    assert lexed_query == expected
  end

end
