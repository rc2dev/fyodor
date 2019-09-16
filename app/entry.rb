class Entry

  TYPE = { note: "note",
           highlight: "highlight",
           bookmark: "bookmark",
           clip: "clip",
           na: "na" }

  attr_accessor :desc, :type, :text

  def initialize
    @text = ""
  end

  def empty?
    @text.strip == "" unless @type == TYPE[:bookmark] || @type == TYPE[:na]
  end

  def uniq_info
    # Notes can have equal text, eg: TODO reminders on a document.
    #   And all bookmarks have no text.
    #   Highlights and clips with equal text are probably useless.
    if @type == TYPE[:note] || @type == TYPE[:bookmark] || type == TYPE[:na]
      @desc
    else
      @text
    end
  end
end
