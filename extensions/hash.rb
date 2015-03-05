# encoding: UTF-8
#############################
# extensions/hash.rb
#############################

require 'hashie'

class Hash
  include Hashie::Extensions::MethodAccess
  include Hashie::Extensions::SymbolizeKeys

  def compact
    reject { |_, v| v.nil? }
  end

  def compact!
    reject! { |_, v| v.nil? }
  end
end
