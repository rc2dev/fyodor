class Book
  include Enumerable

  attr_reader :title, :author

  def initialize(title, author=nil)
    raise "Book title can't be empty" if title.to_s.empty?

    @title = title
    @author = author
    @entries = SortedSet.new
  end

  def <<(entry)
    @entries << entry unless entry.empty?
  end

  def basename
    base = @author.to_s.empty? ? @title : "#{@author} - #{@title}"
    base.strip.gsub(/[?*:|\/"<>]/,"_")
  end

  def count_types
    result = {}
    Entry::TYPE.each_value do |type|
      result[type] = count { |entry| entry.type == type }
    end
    result
  end

  # Required for Enumerable.
  def each &block
    @entries.each { |entry| block.call(entry) }
  end
end
