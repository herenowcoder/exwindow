defmodule Exwindow do
  import Enum, only: [reverse: 1]

  @type token :: :lf | :spc | [char]
  @type counted_token :: {token, integer}

  @spec counted_tokens(String.t) :: [counted_token]

  def counted_tokens(str) do
    cw(str, 0, [], [])
  end


  @spec cw(String.t, non_neg_integer, [char], [token]) :: [counted_token]

  defp cw("", _, [], words) do
    reverse words
  end

  defp cw("", i, chars, words) do
    last_word = {reverse(chars), i}
    reverse [last_word | words]
  end

  defp cw("\n"<>rest, _, [], words) do
    cw(rest, 0, [], [{:lf,0} | words])
  end

  defp cw("\n"<>rest, i, chars, words) do
    word = {reverse(chars), i}
    cw(rest, 0, [], [{:lf,0}, word | words])
  end

  defp cw(" "<>rest, _, [], words) do
    cw(rest, 0, [], [{:spc,1} | words])
  end

  defp cw(" "<>rest, i, chars, words) do
    word = {reverse(chars), i}
    cw(rest, 0, [], [{:spc,1}, word | words])
  end

  defp cw(<<c::utf8, rest::binary>>, i, chars, words) do
    cw(rest, i+1, [c|chars], words)
  end

end
