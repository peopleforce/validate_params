class String
  alias original_blank? blank?

  def blank?
    self.scrub.original_blank?
  end
end
