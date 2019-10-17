require "forwardable"
require "set"

class Book
  extend Forwardable
  include Enumerable

  attr_reader :title, :author, :rej_dup

  def_delegators :@entries, :each, :size
  
  def initialize(title, author=nil)
    raise "Book title can't be empty" if title.to_s.empty?

    @title = title
    @author = author
    @entries = SortedSet.new
    @rej_dup = 0
  end

  def <<(entry)
    return if entry.empty?
    # #add? returns nil if the entry was duplicated
    @rej_dup += 1 if @entries.add?(entry).nil?
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
end
