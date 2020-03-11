defmodule PropCheckCommons.Network do
  @moduledoc """
  A set of `ProPEr` generators for common _network_ based inputs.
  """

  use PropCheck

  import PropCheckCommons.Text, only: [alphanumeric: 0]

  @email_symbols ["" | String.split(". _ - +")]
  @domain_symbols ["" | String.split(". -")]

  @type proper_type :: :proper_types.type()
  @type static_range_16 :: non_neg_integer()
  @type static_range_24 :: {non_neg_integer(), non_neg_integer()}
  @type static_range_32 :: {non_neg_integer(), non_neg_integer(), non_neg_integer()}
  @type ip_format :: :tuple | :string

  @doc """
  Get an IPv4 address when there is a given subnet mask. There are two format types that
  it can return, `:tuple` and `:string` for `{192, 168, 0, 0}` and `"192.168.0.0"` respectively.
  The default is `:string`.

  ## Examples

    iex> use PropCheck
    iex> alias PropCheckCommons.Network

    iex> {:ok, "192.168" <> _} = produce(Network.ipv4(0))
    iex> {:ok, {10, 10, 1, num}} = produce(Network.ipv4(24, {10, 10, 1}, :tuple))

    iex> num >= 0 and num < 256
    :true
  """
  @spec ipv4(
          non_neg_integer(),
          static_range_16() | static_range_24() | static_range_32(),
          ip_format()
        ) :: proper_type()
  def ipv4(subnet_mask \\ 24, static \\ {192, 168}, format \\ :string)

  def ipv4(subnet_mask, {one, two, three}, format) when subnet_mask > 24 and subnet_mask <= 32 do
    mask_range = get_min_range_from_mask(subnet_mask - 24)

    let four <- range(mask_range, 255) do
      ipv4_format(format, {one, two, three, four})
    end
  end

  def ipv4(subnet_mask, {one, two}, format) when subnet_mask > 16 and subnet_mask <= 24 do
    mask_range = get_min_range_from_mask(subnet_mask - 16)

    let {three, four} <- {range(mask_range, 255), range(0, 255)} do
      ipv4_format(format, {one, two, three, four})
    end
  end

  def ipv4(subnet_mask, one, format) when subnet_mask > 8 and subnet_mask <= 16 do
    mask_range = get_min_range_from_mask(subnet_mask - 8)

    let {two, three, four} <- {range(mask_range, 255), range(0, 255), range(0, 255)} do
      ipv4_format(format, {one, two, three, four})
    end
  end

  def ipv4(subnet_mask, _, format) when subnet_mask >= 0 and subnet_mask <= 8 do
    mask_range = get_min_range_from_mask(subnet_mask)

    let {one, two, three, four} <-
          {range(mask_range, 255), range(0, 255), range(0, 255), range(0, 255)} do
      ipv4_format(format, {one, two, three, four})
    end
  end

  defp get_min_range_from_mask(8), do: 255
  defp get_min_range_from_mask(7), do: 254
  defp get_min_range_from_mask(6), do: 252
  defp get_min_range_from_mask(5), do: 248
  defp get_min_range_from_mask(4), do: 240
  defp get_min_range_from_mask(3), do: 224
  defp get_min_range_from_mask(2), do: 192
  defp get_min_range_from_mask(1), do: 128
  defp get_min_range_from_mask(0), do: 0

  defp ipv4_format(:tuple, addr_tuple), do: addr_tuple
  defp ipv4_format(:string, addr_tuple), do: Enum.join(Tuple.to_list(addr_tuple), ".")

  # TODO: Define a generator based on the email specifications
  @doc """
  Generic email address with alphanumeric characters and common symbols.
  This does not generate emails based on the email name specifications which
  are in general, too relaxed for most software systems.
  """
  @spec email(pos_integer()) :: proper_type()
  def email(size \\ 100) when is_integer(size) do
    var_gen =
      such_that(
        {lp1, _mid, lp2, lp3, _tld} <- {
          non_empty(alphanumeric()),
          oneof(@email_symbols),
          non_empty(alphanumeric()),
          non_empty(alphanumeric()),
          tld()
        },
        when: Enum.sum([length(lp1), length(lp2), length(lp3)]) < size
      )

    let {lp1, mid, lp2, lp3, tld} <- var_gen do
      Enum.join([to_string(lp1), mid, to_string(lp2), "@", to_string(lp3), tld])
    end
  end

  # TODO: create option for internationalized domain names
  @doc """
  Non-internationalized domain names
  """
  @spec domain_name() :: proper_type()
  def domain_name do
    var_gen =
      such_that(
        {lp1, _mid, lp2, _tld} <- {
          non_empty(alphanumeric()),
          oneof(@domain_symbols),
          non_empty(alphanumeric()),
          tld()
        },
        when: length(lp1) < 30 && length(lp2) < 30
      )

    let {lp1, mid, lp2, tld} <- var_gen do
      Enum.join([to_string(lp1), mid, to_string(lp2), tld])
    end
  end

  @doc """
  Chooses from a list of well-defined and valid top level domains.
  """
  @spec tld() :: proper_type()
  def tld do
    oneof([
      ".com",
      ".co",
      ".co.jp",
      ".org",
      ".net",
      ".team",
      ".biz",
      ".gov",
      ".cancer",
      ".cn",
      ".rs",
      ".ez",
      ".eu",
      ".nk",
      ".int",
      ".edu",
      ".mil"
    ])
  end
end
