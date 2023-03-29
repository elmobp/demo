# frozen_string_literal: true

# Provides a query interface to an LDAP server
#
# @example simple query
#   delete_ssh_keys("CN=...")
#
require_relative '../../../puppet_x/ldapquery'

begin
  require 'net/ldap'
rescue StandardError
  Puppet.warn('Missing net/ldap gem required for ldapquery() function')
end

Puppet::Parser::Functions.newfunction(:delete_ssh_keys,
                                     type: :rvalue) do |args|
  dn = args
  ldap = PuppetX::LDAPquery.new
  ldap.delete_ssh_keys(dn)

end
