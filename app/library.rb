class Library
  include Enumerable

  def initialize
    @books = []
  end

  def add_entry(title, author, entry)
    return if entry.empty?
    book(title, author) << entry
  end

  def print_stats
    puts "=> #{count} books found"
    count_types.each { |type, n| puts "#{Util::PLURAL[type].capitalize.rjust(12)}: #{n}" }
    puts "-----------------"
    puts "#{"TOTAL".rjust(12)}: #{count_types.sum {|k, v| v}}"
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

  def count_types
    reduce({}) { |acc, book| acc.merge(book.count_types) {|key, val1, val2| val1+val2 } }
  end
end
