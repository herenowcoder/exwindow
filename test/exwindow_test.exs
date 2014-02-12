defmodule TokensTest do
  use ExUnit.Case
  import Exwindow

  test "empty" do
    assert tokens("") === []
  end

  test "space", do:
    assert tokens(" ") === [spc]

  test "spaces", do:
    assert tokens("  ") === [spc,spc]

  test "lf", do:
    assert tokens("\n") === [lf]

  test "lfs", do:
    assert tokens("\n\n") === [lf,lf]

  test "one word", do:
    assert tokens("foo") === [tok(word('foo'),3)]

  test "2 words separated by space", do:
    assert tokens("foo quux") === [tok(word('foo'),3), spc, tok(word('quux'),4)]

  test "3 words separated by spaces", do:
    assert tokens("fu bar quux") ===
      [tok(word('fu'),2), spc, tok(word('bar'),3), spc, tok(word('quux'),4)]

  test "2 words in separate lines", do:
    assert tokens("fu\nbar") === [tok(word('fu'),2), lf, tok(word('bar'),3)]

  test "2 words split by space & newline", do:
    assert tokens("ab \nc") === [tok(word('ab'),2), spc, lf, tok(word('c'),1)]

  test "2 words split by newline & space", do:
    assert tokens("ab\n c") === [tok(word('ab'),2), lf, spc, tok(word('c'),1)]

  test "2 words split by mixed spaces and newlines", do:
    assert tokens("ab\n\n \n \nc") ===
      [ tok(word('ab'),2), lf, lf, spc, lf, spc, lf, tok(word('c'),1) ]

end
