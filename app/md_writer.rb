class MdWriter

  PLURAL = { Entry::TYPE[:highlight] => "highlights",
             Entry::TYPE[:note] => "notes",
             Entry::TYPE[:bookmark] => "bookmarks",
             Entry::TYPE[:clip] => "clips",
             Entry::TYPE[:na] => "unrecognized" }

  SINGULAR = { Entry::TYPE[:highlight] => "highlight",
               Entry::TYPE[:note] => "note",
               Entry::TYPE[:bookmark] => "bookmark",
               Entry::TYPE[:clip] => "clip",
               Entry::TYPE[:na] => "unrecognized" }


  def initialize(book, path)
    @book = book
    @path = path
  end

  def write
    File.open(@path, "w") do |f|
      f.puts(header)
      f.puts(body)
      f.puts(bookmarks)
    end
  end


  private

  def header
    return <<~EOF
    # #{@book.title}
    #{"by #{@book.author}" unless @book.author.to_s.empty?}

    #{header_counts}

    EOF
  end

  def header_counts
    output = ""
    @book.count_types.each do |type, n|
      output += "#{n} #{pluralize(type, n)}, " if n > 0
    end

    output.delete_suffix!(", ")
  end

  def pluralize(type, n)
    n == 1 ? SINGULAR[type] : PLURAL[type]
  end

  def body
    entries = @book.reject { |entry| entry.type == Entry::TYPE[:bookmark] }
    return if entries.count == 0

    output = "\n---\n\n"
    entries.each do |entry|
      output += entry.type == Entry::TYPE[:note] ?  "* _#{entry.text}_\n" : "* #{entry.text}\n"
      output += "\n<sup>*#{entry.desc}*</sup>\n\n"
    end
    output
  end

  def bookmarks
    bookmarks = @book.select { |entry| entry.type == Entry::TYPE[:bookmark] }
    return if bookmarks.count == 0

    output = "\n---\n\n"
    output += "## Bookmarks\n\n"
    bookmarks.each { |bookmark| output +=  "* #{bookmark.desc}\n" }
    output
  end
end