class OutputWriter

  def self.write_all(library, output_dir)
    puts "Writing #{library.books.count} files to #{output_dir}..."

    library.books.each { |book| write_md(book, output_dir) }
  end


  private

  def self.write_md(book, output_dir)
    file_path = output_dir + book.filename

    file = File.open(file_path, "w")
    file.puts(header(book))
    file.puts(body(book))
    file.close
  end

  def self.header(book)
    header = <<~EOF
    # #{book.title}
    by #{book.author}

    #{book.num_highlights} highlights and #{book.num_notes} notes\
    #{", #{book.num_na} unrecognized" if book.num_na > 0 }

    ---

    EOF
    header
  end

  def self.body(book)
    body = ""

    book.entries.each do |entry|
      body += <<~EOF
      #{entry.type == Entry::TYPE_NOTE ?  "* _#{entry.text}_" : "* #{entry.text}" }

      <sup>*#{entry.desc}*</sup>

      EOF
    end

    body
  end
end