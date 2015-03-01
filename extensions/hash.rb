# encoding: UTF-8
#############################
# extensions/hash.rb
#############################

require 'hashie'

class Hash
  include Hashie::Extensions::MethodAccess

  def compact
    reject { |_, v| v.nil? }
  end

  def compact!
    reject! { |_, v| v.nil? }
  end
end
