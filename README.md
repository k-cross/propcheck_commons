# PropCheckCommons

The full [Hex Documentation](https://hexdocs.pm/propcheck_commons).

This library is intended to provide common `generators` that are routine to define.
The main project goal is to provide rigorous coverage of common standards and inputs that would otherwise be left to isolated implementations that don't cover the entire spectrum of possibility.
It also provides an opportunity for the community to contribute to best practices on generator creation and to add additional generators that are common enough to include.

Some of the included generators are:

* email
* domain names
* text

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `propcheck_commons` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:propcheck_commons, "~> 0.1"}
  ]
end
```

Licensed under GPL 3.0 only because the dependency on ProPEr.
