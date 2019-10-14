class Entry

  TYPE_NOTE = "note"
  TYPE_HIGHLIGHT = "highlight"
  TYPE_BOOKMARK = "bookmark"
  TYPE_CLIP = "clip"
  TYPE_NA = "na"

  attr_accessor :desc, :type, :text

  def initialize
    @text = ""
  end

  def empty?
    @text.strip == "" unless @type == TYPE_BOOKMARK || @type == TYPE_NA
  end

  def uniq_info
    # Notes can have equal text, eg: TODO reminders on a document.
    #   And all bookmarks have no text.
    #   Highlights and clips with equal text are probably useless.
    if @type == TYPE_NOTE || @type == TYPE_BOOKMARK || type == TYPE_NA
      @desc
    else
      @text
    end
  end
end
