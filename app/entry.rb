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
