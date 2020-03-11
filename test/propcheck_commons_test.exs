defmodule PropCheckCommonsTest do
  use ExUnit.Case
  use PropCheck

  alias PropCheckCommons.{Network, Text}

  @property_opts [:verbose, {:numtests, 10_000}]

  describe "reliable generator tests" do
    property "for alphanumeric_chars", [:verbose, {:numtests, 100}] do
      forall char <- Text.alphanumeric_chars() do
        str = to_string([char])
        assert Regex.match?(~r/^\w$/, str)
      end
    end

    property "for alphanumeric", @property_opts do
      forall s <- Text.alphanumeric() do
        str = to_string(s)
        assert Regex.match?(~r/^\w*$/, str)
      end
    end

    property "for name", @property_opts do
      forall s <- Text.name(40) do
        assert is_binary(s)
      end
    end

    property "for phone with country code", @property_opts do
      forall s <- Network.Telephony.phone(:jp, true) do
        assert match?(s, "+81")
      end
    end

    property "for phone", @property_opts do
      forall s <- Network.Telephony.phone() do
        assert is_binary(s)
      end
    end

    property "for printable :full", @property_opts do
      forall s <- Text.printable() do
        str = to_string(s)
        assert is_binary(str)
      end
    end

    property "for printable :mysql", @property_opts do
      forall s <- Text.printable(:mysql) do
        str = to_string(s)
        assert is_binary(str)
      end
    end

    property "for text like", @property_opts do
      forall s <- Text.text_like() do
        assert is_binary(s)
      end
    end

    property "for email", @property_opts do
      forall email <- Network.email() do
        assert is_binary(email)
      end
    end

    property "for ipv4 string", @property_opts do
      forall s <- Network.ipv4() do
        assert match?(s, "192.168")
      end
    end

    property "for ipv4 tuple", @property_opts do
      forall {one, two, three, four} <- Network.ipv4(0, nil, :tuple) do
        assert one >= 0 and one < 256
        assert two >= 0 and one < 256
        assert three >= 0 and one < 256
        assert four >= 0 and one < 256
      end
    end

    property "for domain name", @property_opts do
      forall dn <- Network.domain_name() do
        assert is_binary(dn)
      end
    end

    property "for top level domain", [:verbose, {:numtests, 100}] do
      forall dn <- Network.tld() do
        assert is_binary(dn)
      end
    end
  end
end
