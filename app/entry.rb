class Entry
  attr_accessor :book, :desc, :type, :text

  TYPE_NOTE = "note"
  TYPE_HIGHLIGHT = "highlight"
  TYPE_NA = "na"

  def initialize
    @book = nil
    @desc = nil
    @text = ""
  end
end
