require 'securerandom'

module Puppet::Parser::Functions
  newfunction(:crypt, :type => :rvalue) do |args|
    password = args[0]
    salt = args[1]
    password.crypt("$6$#{salt}")
  end
end
