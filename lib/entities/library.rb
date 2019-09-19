require "forwardable"

class Library
  extend Forwardable
  include Enumerable

  def_delegators :@books, :empty?, :size

  def initialize
    @books = []
  end

  def add_entry(title, author, entry)
    return if entry.empty?
    book(title, author) << entry
  end

  def count_types
    reduce({}) { |acc, book| acc.merge(book.count_types) {|key, val1, val2| val1+val2 } }
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
