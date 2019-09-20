require "forwardable"

class Library
  extend Forwardable
  include Enumerable

  attr_reader :rejected

  def_delegators :@books, :empty?, :size

  attr_reader :rejected

  def initialize
    @books = []
    @rejected = {empty: 0, dup: 0}
  end

  def add_entry(title, author, entry)
    if entry.empty?
      @rejected[:empty] += 1
      return
    end

    res = book(title, author) << entry
    @rejected[:dup] +=1 if res.nil?
  end

  def count_types
    reduce({}) { |acc, book| acc.merge(book.count_types) { |key, val1, val2| val1 + val2 } }
  end

  def count_desc_unparsed
    reduce(0) { |acc, book| acc + book.count_desc_unparsed }
  end

  def count_entries
    reduce(0) { |acc, book| acc + book.size }
  end

  # Required for Enumerable.
  def each &block
    @books.each { |book| block.call(book) }
  end


  private

  def book(title, author)
    book = find { |book| book.title == title && book.author == author }
    if book.nil?
      book = Book.new(title, author)
      @books << book
    end
    book
  end
end
