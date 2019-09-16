class Library
  include Enumerable

  def initialize
    @books = []
  end

  def add_entry(title, author, entry)
    return if entry.empty?
    book(title, author) << entry
  end

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