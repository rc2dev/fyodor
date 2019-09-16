class OutputWriter

  def initialize(library, output_dir, ignored_books)
    @library = library
    @output_dir = output_dir
    @ignored_books = ignored_books
  end

  def write_all
    puts <<~EOF
      #{@library.books.count} books found.
      #{"Writing to #{@output_dir}..." if @library.books.count > 0}
    EOF

    @library.books.each do |book|
      if ignore?(book)
        puts "Ignored: #{book.author} - #{book.title}"
      else
        write_md(book)
      end
    end
  end


  private

  def write_md(book)
    file_path = @output_dir + book.filename

    file = File.open(file_path, "w")
    file.puts(header(book))
    file.puts(body(book))
    file.close
  end

  def header(book)
    header = <<~EOF
    # #{book.title}
    by #{book.author}

    #{book.num_highlights} highlights and #{book.num_notes} notes\
    #{", #{book.num_na} unrecognized" if book.num_na > 0 }

    ---

    EOF
    header
  end

  def body(book)
    body = ""

    book.entries.each do |entry|
      body += <<~EOF
      #{entry.type == Entry::TYPE_NOTE ?  "* _#{entry.text}_" : "* #{entry.text}" }

      <sup>*#{entry.desc}*</sup>

      EOF
    end

    body
  end

  def ignore?(book)
    if @ignored_books.nil?
      false
    else
      ! @ignored_books.find { |ignored| ignored["title"] == book.title && ignored["author"] == book.author }.nil?
    end
  end
end