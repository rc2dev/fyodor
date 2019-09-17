class Entry

  TYPE = { note: "note",
           highlight: "highlight",
           bookmark: "bookmark",
           clip: "clip",
           na: "na" }

  attr_accessor :desc, :type, :loc, :loc_start, :page, :time, :text

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

  # This is our comparable; it should be a number.
  def loc_start=(loc_start)
    @loc_start = loc_start.to_i
  end

  def desc_parsed?
    @loc_start != 0
  end

  # Override this method to use a SortedSet.
  def <=>(other)
    loc_start <=> other.loc_start
  end

  # Override the following methods for deduplication.
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
