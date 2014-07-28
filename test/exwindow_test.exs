defmodule ExWindow.CountedTokensTest do
  use ExUnit.Case
  import Exwindow

  def lf,  do: {:lf,0}
  def spc, do: {:spc,1}

  test "empty" do
    assert counted_tokens("") === []
  end

  test "space", do:
    assert counted_tokens(" ") === [spc]

  test "spaces", do:
    assert counted_tokens("  ") === [spc,spc]

  test "lf", do:
    assert counted_tokens("\n") === [lf]

  test "lfs", do:
    assert counted_tokens("\n\n") === [lf,lf]

  test "one word", do:
    assert counted_tokens("foo") === [{'foo',3}]

  test "2 words separated by space", do:
    assert counted_tokens("foo quux") === [{'foo',3}, spc, {'quux',4}]

  test "3 words separated by spaces", do:
    assert counted_tokens("fu bar quux") ===
      [{'fu',2}, spc, {'bar',3}, spc, {'quux',4}]

  test "2 words in separate lines", do:
    assert counted_tokens("fu\nbar") === [{'fu',2}, lf, {'bar',3}]

  test "2 words split by space & newline", do:
    assert counted_tokens("ab \nc") === [{'ab',2}, spc, lf, {'c',1}]

  test "2 words split by newline & space", do:
    assert counted_tokens("ab\n c") === [{'ab',2}, lf, spc, {'c',1}]

  test "2 words split by mixed spaces and newlines", do:
    assert counted_tokens("ab\n\n \n \nc") ===
      [ {'ab',2}, lf, lf, spc, lf, spc, lf, {'c',1} ]

  test "length of unicode word", do:
    assert [{_,3}] = counted_tokens("ąćę")

  test "unicode words", do:
    assert counted_tokens("zażółć gęślą jaźń") === [{'zażółć',6}, spc,
      {'gęślą',5}, spc, {'jaźń',4}]

end


defmodule Exwindow.LayTest do
  use ExUnit.Case
  import Exwindow

  defmacro assert_not_fit(expr) do
    quote do: assert catch_throw(unquote(expr)) == :does_not_fit
  end

  test "invalid sizes" do
    assert_raise FunctionClauseError, fn -> lay("foo", 0, 0) end
    assert_raise FunctionClauseError, fn -> lay("foo", 0, 1) end
    assert_raise FunctionClauseError, fn -> lay("foo", 1, 0) end
    assert_raise FunctionClauseError, fn -> lay("foo", -1, 1) end
    assert_raise FunctionClauseError, fn -> lay("foo", 1, -1) end
  end

  test "empty" do
    assert "" |> counted_tokens |> lay(1,1) == []
  end

  test "1x1 window" do
    assert "a" |> counted_tokens |> lay(1,1) == ['a']
    assert_not_fit "\n" |> counted_tokens |> lay(1,1)
    assert_not_fit "ab" |> counted_tokens |> lay(1,1)
    assert " " |> counted_tokens |> lay(1,1) == [:spc]
    assert_not_fit "  " |> counted_tokens |> lay(1,1)
    # last assert above shouldn't happen - think of fixing this
  end

  test "2x1 window" do
    assert "a " |> counted_tokens |> lay(2,1) == ['a', :spc]
    assert_not_fit "\n"  |> counted_tokens |> lay(2,1)
    assert_not_fit "abc" |> counted_tokens |> lay(2,1)
  end

  test "1x2 window" do
    assert_not_fit "ab" |> counted_tokens |> lay(1,2)
    assert "a " |> counted_tokens |> lay(1,2) == ['a', :lf]
    assert "\n" |> counted_tokens |> lay(1,2) == [:lf]
    assert_not_fit "\n\n" |> counted_tokens |> lay(1,2)
    assert "  "   |> counted_tokens |> lay(1,2) == [:spc, :lf]
    assert "   "  |> counted_tokens |> lay(1,2) == [:spc, :lf]
    assert "    " |> counted_tokens |> lay(1,2) == [:spc, :lf]
  end

  test "words moved to new line" do
    assert "foo quux" |> counted_tokens |> lay(4,2)
      == ['foo', :spc, :lf, 'quux']
    assert "foox quu" |> counted_tokens |> lay(4,2)
      == ['foox', :lf, 'quu']
    assert_not_fit "foo bar baz" |> counted_tokens |> lay(3,2)
    assert_not_fit "foo bar baz" |> counted_tokens |> lay(4,2)
    assert_not_fit "foo bar baz" |> counted_tokens |> lay(5,2)
    assert_not_fit "foo bar baz" |> counted_tokens |> lay(6,2)
    assert"foo bar baz" |> counted_tokens |> lay(7,2)
      == ['foo', :spc, 'bar', :lf, 'baz']
  end

end
