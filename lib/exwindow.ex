defmodule Exwindow do
  import Enum, only: [reverse: 1]

  defmacro tok(content, size), do: quote do: {:tok, unquote(content), unquote(size)}
  defmacro word(chars), do: quote do: {:word, unquote(chars)}
  defmacro lf,  do: quote do: tok(:lf,0)
  defmacro spc, do: quote do: tok(:spc,1)

  def tokens(str) do
    cw(str, 0, [], [])
  end

  defp cw("", _, [], words) do
    reverse words
  end

  defp cw("", i, chars, words) do
    last_word = tok(word(reverse chars), i)
    reverse [last_word | words]
  end

  defp cw("\n"<>rest, _, [], words) do
    cw(rest, 0, [], [lf | words])
  end

  defp cw("\n"<>rest, i, chars, words) do
    word = tok(word(reverse chars), i)
    cw(rest, 0, [], [lf, word | words])
  end

  defp cw(" "<>rest, _, [], words) do
    cw(rest, 0, [], [spc | words])
  end

  defp cw(" "<>rest, i, chars, words) do
    word = tok(word(reverse chars), i)
    cw(rest, 0, [], [spc, word | words])
  end

  defp cw(<<c::utf8, rest::binary>>, i, chars, words) do
    cw(rest, i+1, [c|chars], words)
  end

end
