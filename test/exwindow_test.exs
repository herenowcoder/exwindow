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
