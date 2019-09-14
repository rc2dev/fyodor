class Library

  attr_reader :books
  
  def initialize(entries)
    @books = []

    entries.group_by(&:book_info).each do |book_info, book_entries|
      @books << Book.new(book_info, book_entries)
    end

    finish
  end


  private

  def finish
    @books.each { |book| book.finish }
    @books.delete_if { |book| book.entries.count == 0 }
  end
end