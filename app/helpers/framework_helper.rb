
Mukif.helpers do

  # framework
  
    def partial_with_block(partial_name, locals = {}, &block)
      partial partial_name, :locals => { :html => capture_html(&block) }.merge(locals)
    end
    
    def absolute_url(path)
      "http://#{request.host_with_port}#{path}"
    end
end