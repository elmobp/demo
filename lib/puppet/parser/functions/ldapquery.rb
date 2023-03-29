# frozen_string_literal: true

# Provides a query interface to an LDAP server
#
# @example simple query
#   ldapquery("(objectClass=dnsDomain)", ['dc'])
#
# @example more complex query for ssh public keys
#   ldapquery('(&(objectClass=ldapPublicKey)(sshPublicKey=*)(objectClass=posixAccount))', ['uid', 'sshPublicKey'])
#
require_relative '../../../puppet_x/ldapquery'

begin
  require 'net/ldap'
rescue StandardError
  Puppet.warn('Missing net/ldap gem required for ldapquery() function')
end

Puppet::Parser::Functions.newfunction(:ldapquery,
                                      type: :rvalue) do |args|
  raise Puppet::ParseError, 'Too many arguments received in ldapquery()' if args.size > 3

  filter, attributes, opts = args

  attributes ||= []
  opts ||= {}
  base = opts['base'] || Puppet[:ldapbase]
  scope = opts['scope'] || 'sub'
  server = opts['server'] || Puppet[:ldapserver]

  return PuppetX::LDAPquery.new(filter, attributes, base, scope, server).results
end

Puppet::Parser::Functions.newfunction(:update_ssh_key,
                                     type: :rvalue) do |args|
  dn, public_key = args
  return PuppetX::LDAPquery.update_ssh_key(dn, public_key)

end

Puppet::Parser::Functions.newfunction(:delete_ssh_keys,
                                     type: :rvalue) do |args|
  dn = args
  return PuppetX::LDAPquery.delete_ssh_keys(dn)

end
