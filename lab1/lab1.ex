defmodule Lab1 do
  # Find the multiplicative inverse of a (t * a mod n is congruent to 1)
  def mod_inverse(a, n) do
    # Recursivley divide to get the correct multiplicative inverse
    mod_inverse_division(0, 1, n, a, n)
  end

  # Handle base case and if no multiplicative inverse, and if t is negative
  defp mod_inverse_division(t, _ , r, 0, n) do
    if r > 1 do
      :not_invertible
    else
      if t < 0 do
        t + n
      else
        t
      end
    end
  end

  # Handle division
  defp mod_inverse_division(t, newt, r, newr, n) do
    quotient = div(r, newr)
    mod_inverse_division(newt, t - quotient * newt, newr, r - quotient * newr, n)
  end

  # Base Case
  def mod_pow(_, 0, _), do: 1

  # Even
  def mod_pow(a, m, n) when rem(m, 2) == 0 do
    half = mod_pow(a, div(m, 2), n)
    rem(half * half, n)
  end

  # Odd
  def mod_pow(a, m, n) do
    rem(rem(a, n) * mod_pow(a, m - 1, n), n)
  end

end
