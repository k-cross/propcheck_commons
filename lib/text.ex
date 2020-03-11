defmodule PropCheckCommons.Text do
  @moduledoc """
  A set of `ProPEr` generators for common _text_ based inputs as elixir strings.
  """

  use PropCheck

  @control_chars_list Enum.to_list(0x007F..0x009F) ++ Enum.to_list(0x0000..0x001F)

  @type proper_type :: :proper_types.type()

  @doc """
  Only alphanumeric characters.
  """
  @spec alphanumeric_chars() :: proper_type()
  def alphanumeric_chars, do: oneof([range(?A, ?Z), range(?a, ?z), range(?0, ?9)])

  @doc """
  A list with only alphanumeric characters with equal occurence frequency.
  """
  @spec alphanumeric() :: proper_type()
  def alphanumeric, do: list(alphanumeric_chars())

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
