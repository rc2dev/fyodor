class OutputWriter

  def self.write_all(library, output_dir)
    puts "Writing #{library.books.count} files to #{output_dir}..."
    library.books.each do |book|
      write_md(book, output_dir)
    end
  end


  private

  def self.write_md(book, output_dir)
    file_path = output_dir + book.filename
    file = File.open(file_path, "w")

    write_header(file, book)
    write_entries(file, book.entries)

    file.close
  end

  def self.write_header(file, book)
    file.puts "# #{book.title}"
    file.puts "by #{book.author}"
    file.puts

    if book.entries.count > 1
      file.puts "#{book.entries.length} highlights and notes"
    else
      file.puts "#{book.entries.length} highlight or note"
    end

    file.puts
    file.puts "---"
    file.puts
  end

  def self.write_entries(file, entries)
    entries.each do |entry|
      file.puts "* #{entry.text}"
      file.puts
      file.puts "<sup>*#{entry.desc}*</sup>"
      file.puts
    end
  end
end