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

    file.puts "#{book.num_highlights} highlights and #{book.num_notes} notes"
    file.puts "#{book.num_na} unrecognized" if book.num_na > 0

    file.puts
    file.puts "---"
    file.puts
  end

  def self.write_entries(file, entries)
    entries.each do |entry|
      case entry.type
      when "NOTE"
        file.puts "* _#{entry.text}_"
      else
        file.puts "* #{entry.text}"
      end
      file.puts
      file.puts "<sup>*#{entry.desc}*</sup>"
      file.puts
    end
  end
end