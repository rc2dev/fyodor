class Entry
  attr_accessor :book_info, :desc, :type, :text

  TYPE_NOTE = "note"
  TYPE_HIGHLIGHT = "highlight"
  TYPE_NA = "na"

  def initialize
    @book_info = nil
    @desc = nil
    @text = ""
  end
end
