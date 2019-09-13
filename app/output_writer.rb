class OutputWriter

  def self.write_all(library, output_dir)
    library.books.values.each do |book|
      write_md(book, output_dir)
    end
  end


  private

  def self.write_md(book, output_dir)
    file_path = output_dir + book.filename
    file = File.open(file_path, "w")

    file.puts "# #{book.name}"

    if book.entries.count > 1
      file.puts "#{book.entries.length} highlights and notes"
    else
      file.puts "#{book.entries.length} highlight or note"
    end

    file.puts
    file.puts "---"
    file.puts

    book.entries.each do |entry|
      file.puts "* #{entry.text}"
      file.puts
      file.puts "<sup>*#{entry.desc}*</sup>"
      file.puts
    end

    file.close
  end

end