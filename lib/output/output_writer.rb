class OutputWriter

  def initialize(library, output_dir, ignored_books)
    @library = library
    @output_dir = output_dir
    @ignored_books = ignored_books
  end

  def write_all
    puts "\nWriting to #{@output_dir}..." if @library.count > 0

    @library.each do |book|
      if ignore?(book)
        puts "Ignored: #{book.author} - #{book.title}"
      else
        MdWriter.new(book, path(book)).write
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