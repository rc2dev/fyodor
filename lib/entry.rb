class Entry
  TYPE = { note: "note",
           highlight: "highlight",
           bookmark: "bookmark",
           clip: "clip" }

  attr_reader :book_title, :book_author, :text, :desc, :type, :loc, :loc_start, :page, :time

  def initialize(attrs)
    @book_title = attrs[:book_title]
    @book_author = attrs[:book_author]
    @text = attrs[:text]
    @desc = attrs[:desc]
    @type = attrs[:type]
    @loc = attrs[:loc]
    # This is our comparable, we need it as a number.
    @loc_start = attrs[:loc_start].to_i
    @page = attrs[:page]
    @time = attrs[:time]

    raise ArgumentError, "Invalid Entry type" unless TYPE.value?(@type) || @type.nil?
  end

  def empty?
    if @type == TYPE[:bookmark] || @type.nil?
      @desc.strip == ""
    else
      @text.strip == ""
    end
  end

  def desc_parsed?
    @loc_start != 0 && ! @type.nil?
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
      @text.hash ^ @type.hash ^ @loc.hash
    else
      @text.hash ^ @desc.hash
    end
  end
end
