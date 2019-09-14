class OutputWriter

  def initialize(library, output_dir, ignored_books)
    @library = library
    @output_dir = output_dir
    @ignored_books = ignored_books
  end

  def write_all
    puts "#{@library.books.count} books found."
    puts "Writing to #{@output_dir}..." if @library.books.count > 0

    @library.books.each do |book|
      if ignore?(book)
        puts "Ignored: #{book.author} - #{book.title}"
      else
        md_writer = MdWriter.new(book, path(book))
        md_writer.write
      end
    end
  end


  private

  def ignore?(book)
    if @ignored_books.nil?
      false
    else
      ! @ignored_books.find { |ignored| ignored["title"] == book.title && ignored["author"] == book.author }.nil?
    end
  end

  def path(book)
    path = @output_dir + "#{book.basename}.md"

    i = 2
    while(path.exist?)
      path = @output_dir + "#{book.basename} - #{i}.md"
      i += 1
    end

    path
  end
end