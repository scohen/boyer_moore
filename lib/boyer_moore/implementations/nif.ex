defmodule BoyerMoore.Implementations.Nif do
  use Rustler, otp_app: :boyer_moore, crate: "boyermoore_implementations_nif"

  # When your NIF is loaded, it will override this function.
  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
  def contains(_haystack, _needle), do: :erlang.nif_error(:nif_not_loaded)

  def contains?(haystack, needle) do
    contains(haystack, needle)
  end
end
