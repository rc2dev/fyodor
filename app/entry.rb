class Entry

  TYPE = { note: "note",
           highlight: "highlight",
           bookmark: "bookmark",
           clip: "clip",
           na: "na" }

  attr_accessor :desc, :type, :loc, :page, :time, :text

  def initialize
    @text = ""
  end

  def empty?
    if @type == TYPE[:bookmark] || @type == TYPE[:na]
      @desc.strip == ""
    else
      @text.strip == ""
    end
  end

  def type=(type)
    raise ArgumentError, "Invalid Entry type" unless TYPE.value?(type)
    @type = type
  end

  # Override the following methods, so it's easier to deduplicate Entries.
  def ==(other)
    return false if type != other.type

    if type == TYPE[:highlight] || type == TYPE[:clip]
      text == other.text
    else
      text == other.text && desc == other.desc
    end
  end

  alias eql? ==

  def hash
    if type == TYPE[:highlight] || type == TYPE[:clip]
      type.hash ^ text.hash
    else
      type.hash ^ text.hash ^ desc.hash
    end
  end
end
