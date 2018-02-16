class Hash
  
  def to_query
    self.map{|key,val| [CGI.escape(key.to_s), "=", CGI.escape(val.to_s)]}
         .map(&:join).join("&")
  end
end
