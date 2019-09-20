class Entry

  TYPE_NOTE = "note"
  TYPE_HIGHLIGHT = "highlight"
  TYPE_NA = "na"

  attr_accessor :desc, :type, :text

  def initialize
    @text = ""
  end
end
