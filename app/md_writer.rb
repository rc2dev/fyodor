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

    output = "---\n\n"
    entries.each do |entry|
      output += "> #{entry_text(entry)}\n\n"
      output += "<p style=\"text-align: right;\"><sup>#{entry_info(entry)}</sup></p>\n\n"
    end
    output
  end

  def bookmarks
    bookmarks = @book.select { |entry| entry.type == Entry::TYPE[:bookmark] }
    return if bookmarks.count == 0

    output = "---\n\n"
    output += "## Bookmarks\n\n"
    bookmarks.each do |bookmark|
      output += "* #{bookmark_text(bookmark)}\n\n"
      output += "<p style=\"text-align: right;\"><sup>#{bookmark_info(bookmark)}</p></sup>\n\n"
    end
    output
  end

  def entry_text(entry)
    entry.type == Entry::TYPE[:note] ?  "_#{entry.text}_" : "#{entry.text}"
  end

  def entry_info(entry)
    output = SINGULAR[entry.type] + " @ "
    output += "page #{entry.page}, " unless entry.page.nil?
    output += "loc. #{entry.loc}" unless entry.loc.nil?
    output.delete_suffix!(", ")

    output += " [#{entry.time}]"
    output
  end

  def bookmark_text(bookmark)
    output = ""
    output += "page #{bookmark.page}, " unless bookmark.page.nil?
    output += "loc. #{bookmark.loc}" unless bookmark.loc.nil?
    output.delete_suffix!(", ")
  end

  def bookmark_info(bookmark)
    "[#{bookmark.time}]"
  end
end