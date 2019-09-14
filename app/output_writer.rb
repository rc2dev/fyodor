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
      @book = book
      if ignore?
        puts "Ignored: #{@book.author} - #{@book.title}"
      else
        write
      end
    end
    @book = nil
  end


  private

  def write
    File.open(path, "w") do |f|
      f.puts(header)
      f.puts(body)
    end
  end

  def header
    return <<~EOF
    # #{@book.title}
    by #{@book.author}

    #{@book.num_highlights} highlights and #{@book.num_notes} notes\
    #{", #{@book.num_na} unrecognized" if @book.num_na > 0}

    ---

    EOF
  end

  def body
    body = ""

    @book.entries.each do |entry|
      body += <<~EOF
      #{entry.type == Entry::TYPE_NOTE ?  "* _#{entry.text}_" : "* #{entry.text}" }

      <sup>*#{entry.desc}*</sup>

      EOF
    end

    body
  end

  def ignore?
    if @ignored_books.nil?
      false
    else
      ! @ignored_books.find { |ignored| ignored["title"] == @book.title && ignored["author"] == @book.author }.nil?
    end
  end

  def path
    path = @output_dir + "#{@book.basename}.md"

    i = 2
    while(path.exist?)
      path = @output_dir + "#{@book.basename} - #{i}.md"
      i += 1
    end

    path
  end
end