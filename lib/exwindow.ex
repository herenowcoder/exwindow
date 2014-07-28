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


  @spec lay([counted_token], pos_integer, pos_integer) :: [token]

  def lay(tokens, w, h) when w > 0 and h > 0 do
    lay(tokens, :nocarry, 0, 1, w, h, [])
  end


  @spec lay([counted_token], atom, non_neg_integer, pos_integer,
            non_neg_integer, non_neg_integer, [token]) :: [token]

  defp lay(_, _, _, iy, _, h, _) when iy > h do
    throw :does_not_fit
  end

  defp lay([], _, _, _, _, _, acc) do
    Enum.reverse(acc)
  end

  defp lay([{:spc,1} | ts], :carry, 0, iy, w, h, acc) do
    lay(ts, :carry, 0, iy, w, h, acc)
  end

  defp lay([{:lf,0} | ts], _, _, iy, w, h, acc) do
    lay(ts, :nocarry, 0, iy+1, w, h, [:lf | acc])
  end

  defp lay(ts0=[{token,len} | ts], _, ix, iy, w, h, acc) when iy <= h do
    ix1 = ix + len
    if ix1 <= w do
      lay(ts, :nocarry, ix1, iy, w, h, [token | acc])
    else
      lay(ts0, :carry, 0, iy+1, w, h, [:lf | acc])
    end
  end
end
