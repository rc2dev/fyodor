module Fyodor
  class Entry
    TYPE = {
      note: "note",
      highlight: "highlight",
      bookmark: "bookmark",
      clip: "clip"
    }

    ATTRS = [
      :book_title,
      :book_author,
      :text,
      :desc,
      :type,
      :loc,
      :loc_start,
      :page,
      :page_start,
      :time
    ]

    attr_reader *ATTRS

    def initialize(args)
      ATTRS.each do |attr|
        instance_variable_set("@#{attr}", args[attr])
      end

      # These are our comparables. Let's make sure they are numbers.
      @loc_start = @loc_start.to_i
      @page_start = @page_start.to_i

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
      ! @type.nil? && (@loc_start != 0 || @page_start != 0)
    end

    # Override this method to use a SortedSet.
    def <=>(other)
      return @page_start <=> other.page_start if @loc_start == 0

      @loc_start <=> other.loc_start
    end

    # Override the following methods for deduplication.
    def ==(other)
      return false if @type != other.type || @text != other.text

      if desc_parsed? && other.desc_parsed?
        @loc == other.loc && @page == other.page
      else
        @desc == other.desc
      end
    end

    alias eql? ==

    def hash
      if desc_parsed?
        @text.hash ^ @type.hash ^ @loc.hash ^ @page.hash
      else
        @text.hash ^ @desc.hash
      end
    end
  end
end
