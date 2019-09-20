class Library

  attr_reader :books
  
  def initialize
    @books = []
  end

  def book(title, author)
    book = @books.find { |book| book.title == title && book.author == author }
    if book.nil?
      book = Book.new(title, author)
      @books << book
    end
    book
  end

  def finish
    @books.each { |book| book.finish }
    @books.delete_if { |book| book.entries.count == 0 }
  end
end