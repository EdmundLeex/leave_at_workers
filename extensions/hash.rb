# encoding: UTF-8
#############################
# extensions/hash.rb
#############################

require 'hashie'

class Hash
  include Hashie::Extensions::MethodAccess

  def rename_keys(mappings = {})
    dup.rename_keys!(mappings)
  end

  def rename_keys!(mappings = {})
    return self unless mappings && !mappings.empty?

    keys.each do |key|
      self[ mappings[key] ] = self.delete(key) if mappings[key]
    end

    self
  end
end
