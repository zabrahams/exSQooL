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
      %Lexer.Token{type: :asterisk, literal: "*"},
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
      %Lexer.Token{type: :asterisk, literal: "*"},
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

  test "select with where equals statement" do
    query ="SELECT * FROM puppies WHERE eyes = 1;"

    lexed_query = Lexer.process(query)

    expected = [
      %Lexer.Token{type: :select, literal: "SELECT"},
      %Lexer.Token{type: :asterisk, literal: "*"},
      %Lexer.Token{type: :from, literal: "FROM"},
      %Lexer.Token{type: :identifier, literal: "puppies"},
      %Lexer.Token{type: :where, literal: "WHERE"},
      %Lexer.Token{type: :identifier, literal: "eyes"},
      %Lexer.Token{type: :equals, literal: "="},
      %Lexer.Token{type: :integer, literal: "1"},
      %Lexer.Token{type: :semicolon, literal: ";"}
    ]

    assert lexed_query == expected
  end

  test "select with where and newlines" do
    query = """
SELECT * FROM puppies
WHERE eyes = 1;
"""

    lexed_query = Lexer.process(query)

    expected = [
      %Lexer.Token{type: :select, literal: "SELECT"},
      %Lexer.Token{type: :asterisk, literal: "*"},
      %Lexer.Token{type: :from, literal: "FROM"},
      %Lexer.Token{type: :identifier, literal: "puppies"},
      %Lexer.Token{type: :where, literal: "WHERE"},
      %Lexer.Token{type: :identifier, literal: "eyes"},
      %Lexer.Token{type: :equals, literal: "="},
      %Lexer.Token{type: :integer, literal: "1"},
      %Lexer.Token{type: :semicolon, literal: ";"}
    ]

    assert lexed_query == expected
  end

  test "select with string" do
    query = """
SELECT * FROM puppies
WHERE breed = 'Pineapple Tail';
"""

    lexed_query = Lexer.process(query)

    expected = [
      %Lexer.Token{type: :select, literal: "SELECT"},
      %Lexer.Token{type: :asterisk, literal: "*"},
      %Lexer.Token{type: :from, literal: "FROM"},
      %Lexer.Token{type: :identifier, literal: "puppies"},
      %Lexer.Token{type: :where, literal: "WHERE"},
      %Lexer.Token{type: :identifier, literal: "breed"},
      %Lexer.Token{type: :equals, literal: "="},
      %Lexer.Token{type: :string, literal: "Pineapple Tail"},
      %Lexer.Token{type: :semicolon, literal: ";"}
    ]

    assert lexed_query == expected
  end

end
