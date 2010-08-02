
class AppParam < ActiveRecord::Base

  def value
    YAML.load(self.yaml)
  end

  def self.params_hash
    h = {}
    find(:all).each {|p| h[p.name.to_sym] = p.value }
    h
  end
end
