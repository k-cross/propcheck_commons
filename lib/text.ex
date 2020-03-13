defmodule PropCheckCommons.Text do
  @moduledoc """
  A set of `ProPEr` generators for common _text_ based inputs as elixir strings.
  For specific character sets, there are always two types of generators:

  1. Character sets, identifiable by ending with `chars()` such as
  `alphanumeric_chars()`, are made to be simple maximizing composablability.

  2. Other sets contain options that can be set but are in general made to be used
  for common cases and automatically return Elixir Strings.
  """

  use PropCheck

  @control_chars_list Enum.to_list(0x007F..0x009F) ++ Enum.to_list(0x0000..0x001F)

  @type proper_type :: :proper_types.type()
  @type alphanumeric_opts :: [
    {:raw, boolean()},
    {:empty, boolean()}
  ]

  @type printable_opts :: [
    {:empty, boolean()}
  ]

  @doc """
  A `oneof` character integer range with only alphanumerics.
  """
  @spec alphanumeric_chars() :: proper_type()
  def alphanumeric_chars, do: oneof([range(?A, ?Z), range(?a, ?z), range(?0, ?9)])

  @doc """
  An Elixir `String` with only alphanumeric characters with equal frequency of occurence.
  """
  @spec alphanumeric(alphanumeric_opts()) :: proper_type()
  def alphanumeric(opts \\ [raw: false, empty: true]) do
    list(alphanumeric_chars())
  end

  @doc """
  Creates a list of printable unicode characters with the following ranges:

  * `:full` entire range of UTF-8
  * `:mysql` subset of UTF-8 that works without the `utf8mb4` setting

  NOTE: if additional ranges should be added please create an issue :)
  """
  @spec printable(:full | :mysql) :: proper_type()
  def printable(kind \\ :full)

  def printable(:full) do
    let char_list <-
          such_that(l <- list(range(0x0001, 0xFFFF)), when: :io_lib.printable_unicode_list(l)) do
      char_list -- @control_chars_list
    end
  end

  def printable(:mysql) do
    let char_list <-
          such_that(l <- list(range(0x0001, 0xA69F)), when: :io_lib.printable_unicode_list(l)) do
      char_list -- @control_chars_list
    end
  end

  @doc """
  Names with characters that are likely to occur.
  """
  @spec name(pos_integer()) :: proper_type()
  def name(max \\ 30) when is_integer(max) do
    let(
      name_list <-
        such_that(
          l <-
            non_empty(
              list(
                frequency([
                  {2, range(?A, ?Z)},
                  {80, range(?a, ?z)},
                  {10, ?\s},
                  {1, oneof([?., ?,, ?-, ?'])},
                  {1, range(?0, ?9)}
                ])
              )
            ),
          when: length(l) <= max
        ),
      do: to_string(name_list)
    )
  end

  @doc "Generates text with specific frequency resembling English text."
  def text_like() do
    let l <-
          list(
            frequency([
              {2, range(?A, ?Z)},
              {80, range(?a, ?z)},
              {10, ?\s},
              {1, ?\n},
              {1, oneof([?., ?,, ?!, ??, ?-])},
              {1, range(?0, ?9)}
            ])
          ) do
      to_string(l)
    end
  end
end
