class Book
  include Enumerable

  attr_reader :title, :author

  def_delegators :@entries, :size
  
  def initialize(title, author=nil)
    raise "Book title can't be empty" if title.to_s.empty?

    @title = title
    @author = author
    @entries = SortedSet.new
  end

  def <<(entry)
    raise "Expected an Entry" unless entry.is_a?(Entry)
    @entries << entry unless entry.empty?
  end

  def basename
    base = @author.to_s.empty? ? @title : "#{@author} - #{@title}"
    base.strip.gsub(/[?*:|\/"<>]/,"_")
  end

  def count_types
    list = group_by(&:type).map { |k, v| [k, v.size] }
    Hash[list]
  end

  # Required for Enumerable.
  def each &block
    @entries.each { |entry| block.call(entry) }
  end
end
