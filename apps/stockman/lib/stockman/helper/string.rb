class String

  def is_email?
    !self.match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i).nil?
  end
end
