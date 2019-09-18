class Entry

  TYPE = { note: "note",
           highlight: "highlight",
           bookmark: "bookmark",
           clip: "clip",
           na: "na" }

  attr_accessor :text, :desc, :type, :loc, :loc_start, :page, :time


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
    @loc_start <=> other.loc_start
  end

  # Override the following methods for deduplication.
  def ==(other)
    return false if @type != other.type || @text != other.text

    if desc_parsed? && other.desc_parsed?
      @loc == other.loc
    else
      @desc == other.desc
    end
  end

  alias eql? ==

  def hash
    if desc_parsed?
      @type.hash ^ @text.hash ^ @loc.hash
    else
      @type.hash ^ @text.hash ^ @desc.hash
    end
  end
end
