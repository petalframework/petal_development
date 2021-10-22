defmodule Util do
  @doc """
  Useful for printing maps onto the page during development. Or passing a map to a hook
  """
  def to_json(obj) do
    Jason.encode!(obj, pretty: true)
  end

  @doc """
  Get a random string of given length.
  Returns a random url safe encoded64 string of the given length.
  Used to generate tokens for the various modules that require unique tokens.
  """
  def random_string(length \\ 10) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  def random_numeric_string(length \\ 10) do
    length
    |> :crypto.strong_rand_bytes()
    |> :crypto.bytes_to_integer()
    |> Integer.to_string()
    |> binary_part(0, length)
  end

  @doc """
  Immitates .compact in Ruby... removes nil values from an array https://ruby-doc.org/core-1.9.3/Array.html#method-i-compact
  """
  def compact(list), do: Enum.filter(list, &(!is_nil(&1)))

  def email_valid?(email) do
    EmailChecker.valid?(email)
  end

  @doc """
  Util.blank?(nil) => true
  Util.blank?("") => true
  Util.blank?([]) => true
  Util.blank?("Hello") => false
  """
  def blank?(term) do
    Blankable.blank?(term)
  end

  @doc """
  Opposite of blank?
  """
  def present?(term) do
    !Blankable.blank?(term)
  end

  def map_has_atom_keys?(map) do
    Map.keys(map)
    |> List.first()
    |> is_atom()
  end

  def format_money(cents, currency \\ "AUD") do
    CurrencyFormatter.format(cents, currency)
  end

  # expectes address_city, address_street etc
  def format_address(obj) do
    "#{obj.address_street}, #{obj.address_postcode}, #{obj.address_city}"
  end

  def format_time(
        date_time,
        format \\ "{D} {Mshort} {YY} at {h12}:{m}{am}",
        timezone \\ "Australia/Melbourne"
      ) do
    date_time
    |> Timex.Timezone.convert(timezone)
    |> Timex.format!(format)
  end

  @doc "Trim whitespace on either end of a string. Account for nil"
  def trim(str) when is_nil(str), do: str
  def trim(str) when is_binary(str), do: String.trim(str)

  def trim_strings_in_array(array) do
    Enum.map(array, &String.trim/1)
    |> Enum.filter(&present?/1)
  end

  @doc """
  maybe_plural("hat", 0) => hats
  maybe_plural("hat", 1) => hat
  maybe_plural("hat", 2) => hats
  """
  def maybe_plural(word, count), do: Inflex.inflect(word, count)

  @doc """
  Use for when you want to combine all form errors into one message (maybe to display in a flash)
  """
  def combine_changeset_error_messages(changeset) do
    errors =
      Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    errors
    |> Enum.map(fn {key, errors} ->
      "#{Phoenix.Naming.humanize(key)}: #{Enum.join(errors, ", ")}"
    end)
    |> Enum.join("\n")
  end

  # eg. Util.truncate(string, length: 150)
  def truncate(text, options \\ []) do
    Util.Truncate.truncate(text, options)
  end

  def number_with_delimiter(i) when is_binary(i), do: number_with_delimiter(String.to_integer(i))

  def number_with_delimiter(i) when is_integer(i) do
    i
    |> Integer.to_charlist()
    |> Enum.reverse()
    |> Enum.chunk_every(3, 3, [])
    |> Enum.join(",")
    |> String.reverse()
  end
end
