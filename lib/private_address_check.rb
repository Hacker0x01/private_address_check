require "ipaddr"
require "socket"

require "private_address_check/version"

module PrivateAddressCheck
  module_function

  # https://www.iana.org/assignments/iana-ipv4-special-registry/iana-ipv4-special-registry.xhtml
  # https://www.iana.org/assignments/iana-ipv6-special-registry/iana-ipv6-special-registry.xhtml
  CIDR_LIST = [
    IPAddr.new("127.0.0.0/8"),     # Loopback
    IPAddr.new("::1/128"),         # Loopback
    IPAddr.new("0.0.0.0/8"),       # Current network (only valid as source address)
    IPAddr.new("169.254.0.0/16"),  # Link-local
    IPAddr.new("10.0.0.0/8"),      # Private network
    IPAddr.new("100.64.0.0/10"),   # Shared Address Space
    IPAddr.new("172.16.0.0/12"),   # Private network
    IPAddr.new("192.0.0.0/24"),    # IETF Protocol Assignments
    IPAddr.new("192.0.2.0/24"),    # TEST-NET-1, documentation and examples
    IPAddr.new("192.88.99.0/24"),  # IPv6 to IPv4 relay (includes 2002::/16)
    IPAddr.new("192.168.0.0/16"),  # Private network
    IPAddr.new("198.18.0.0/15"),   # Network benchmark tests
    IPAddr.new("198.51.100.0/24"), # TEST-NET-2, documentation and examples
    IPAddr.new("203.0.113.0/24"),  # TEST-NET-3, documentation and examples
    IPAddr.new("224.0.0.0/4"),     # IP multicast (former Class D network)
    IPAddr.new("240.0.0.0/4"),     # Reserved (former Class E network)
    IPAddr.new("255.255.255.255"), # Broadcast
    IPAddr.new("64:ff9b::/96"),    # IPv4/IPv6 translation (RFC 6052)
    IPAddr.new("100::/64"),        # Discard prefix (RFC 6666)
    IPAddr.new("2001::/32"),       # Teredo tunneling
    IPAddr.new("2001:10::/28"),    # Deprecated (previously ORCHID)
    IPAddr.new("2001:20::/28"),    # ORCHIDv2
    IPAddr.new("2001:db8::/32"),   # Addresses used in documentation and example source code
    IPAddr.new("2002::/16"),       # 6to4
    IPAddr.new("fc00::/7"),        # Unique local address
    IPAddr.new("fe80::/10"),       # Link-local address
    IPAddr.new("ff00::/8")         # Multicast
  ].freeze

  def private_address?(address)
    CIDR_LIST.any? do |cidr|
      cidr.include?(address)
    end
  end

  def resolves_to_private_address?(hostname)
    ips = Socket.getaddrinfo(hostname, nil).map { |info| IPAddr.new(info[3]) }
    return true if ips.empty?

    ips.any? do |ip|
      private_address?(ip)
    end
  end
end
