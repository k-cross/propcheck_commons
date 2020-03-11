defmodule PropCheckCommons.Network.Telephony do
  @moduledoc """
  A set of `ProPEr` generators for common _telephony_ inputs.

  Currently, these generators are not representative of the world as
  real telephone numbers have a lot of logic hidden within them.
  """

  use PropCheck

  @type proper_type :: :proper_types.type()

  # TODO: add more configuration settings like extension numbers and formatting
  # options.
  @doc """
  Phone numbers as strings.
  """
  @spec phone(atom(), boolean()) :: proper_type()
  def phone(country_code \\ :us, with_country_code? \\ false)

  def phone(:us, with_country_code?) do
    let phone <- vector(10, range(?0, ?9)) do
      if with_country_code?, do: "+1" <> to_string(phone), else: to_string(phone)
    end
  end

  def phone(:jp, with_country_code?) do
    let phone <- vector(10, range(?0, ?9)) do
      if with_country_code?, do: "+81" <> to_string(phone), else: to_string(phone)
    end
  end

  def phone(:kr, with_country_code?) do
    let phone <- vector(9, range(?0, ?9)) do
      if with_country_code?, do: "+82" <> to_string(phone), else: to_string(phone)
    end
  end
end
