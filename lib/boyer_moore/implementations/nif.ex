defmodule BoyerMoore.Implementations.Nif do
  use Rustler, otp_app: :boyer_moore, crate: "boyermoore_implementations_nif"

  # When your NIF is loaded, it will override this function.

  defp contains(_haystack, _needle), do: :erlang.nif_error(:nif_not_loaded)
  defp contains_compiled(_haystack, _pattern), do: :erlang.nif_error(:nif_not_loaded)
  def compile(_pattern), do: :erlang.nif_error(:nif_not_loaded)

  def contains?(haystack, needle) when is_reference(needle) do
    contains_compiled(haystack, needle)
  end

  def contains?(haystack, needle) do
    contains(haystack, needle)
  end
end
