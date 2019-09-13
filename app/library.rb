class Library

  attr_reader :books
  
  def initialize(entries)
    @books = []

    entries.each do |entry|
      book = get_book(entry.book[:title], entry.book[:author])
      book.entries << entry
    end    
  end

  def clean_library
    @books.each { |book| book.clean_book }
    @books.delete_if { |book| book.entries.count == 0 }
  end


  private

  def get_book(title, author)
    book = @books.find { |book| book.title == title && book.author == author }
    if book.nil?
      book = Book.new(title, author)
      @books << book
    end

    book
  end
end