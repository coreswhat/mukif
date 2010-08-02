
  
# extension to allow recursive key symbolization

  class Hash
    def recursive_symbolize_keys!
      symbolize_keys!
      values.select {|v| v.is_a?(Hash) }.each {|h| h.recursive_symbolize_keys! }
    end
  end