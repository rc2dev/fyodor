require "fyodor/book"
require "forwardable"

module Fyodor
  class Library
    extend Forwardable
    include Enumerable

    def_delegators :@books, :each, :empty?, :size

    def initialize
      @books = []
      @rej_empty = 0
    end

    def <<(entry)
      if entry.empty?
        @rej_empty += 1
        return
      end

      book(entry.book_title, entry.book_author) << entry
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

    def rejected
      {empty: @rej_empty, dup: count_rej_dup}
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

    def count_rej_dup
      reduce(0) { |acc, book| acc + book.rej_dup }
    end
  end
end
