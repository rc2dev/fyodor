require "forwardable"
require "set"

class Book
  extend Forwardable
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
    return if entry.empty?
    # #add? tells us if the entry was duplicated
    @entries.add?(entry)
  end

  def basename
    base = @author.to_s.empty? ? @title : "#{@author} - #{@title}"
    base.strip.gsub(/[?*:|\/"<>]/,"_")
  end

  def count_types
    list = group_by(&:type).map { |k, v| [k, v.size] }
    Hash[list]
  end

  def count_desc_unparsed
    count { |entry| ! entry.desc_parsed? }
  end

  # Required for Enumerable.
  def each &block
    @entries.each { |entry| block.call(entry) }
  end
end
