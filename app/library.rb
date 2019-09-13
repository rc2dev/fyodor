class Library

  attr_reader :books
  
  def initialize(entries)
    @books = {}

    entries.each do |entry|
      book = get_book(entry.book)
      book.entries << entry
    end
  end

  def clean_library
    @books.each do |key, book|
      book.clean_book
      @books.delete(key) unless book.entries.count > 0
    end
  end


  private

  def get_book(name)
    @books[name] ||= Book.new(name)
  end
end