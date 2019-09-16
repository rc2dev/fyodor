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
    output.delete_suffix(", ")
  end

  def pluralize(type, n)
    n == 1 ? SINGULAR[type] : PLURAL[type]
  end

  def body
    entries = @book.reject { |entry| entry.type == Entry::TYPE[:bookmark] }
    entries.count == 0 ? "" : entries_render(entries)
  end

  def bookmarks
    bookmarks = @book.select { |entry| entry.type == Entry::TYPE[:bookmark] }
    bookmarks.count == 0 ? "" : entries_render(bookmarks, "Bookmarks")
  end

  def entries_render(entries, title=nil)
    output = "---\n\n"
    output += "## #{title}\n\n" unless title.nil?
    entries.each do |entry|
      output += "#{entry_text(entry)}\n\n"
      output += "<p style=\"text-align: right;\"><sup>#{entry_info(entry)}</sup></p>\n\n"
    end
    output
  end

  def entry_text(entry)
    case entry.type
    when Entry::TYPE[:bookmark]
      "* #{entry_page(entry)}"
    when Entry::TYPE[:note]
      "> _#{entry.text}_"
    else
      "> #{entry.text}"
    end
  end

  def entry_info(entry)
    case entry.type
    when Entry::TYPE[:bookmark]
      "[#{entry.time}]"
    else
      SINGULAR[entry.type] + " @ " + entry_page(entry) + " [#{entry.time}]"
    end
  end

  def entry_page(entry)
    ((entry.page.nil? ? "" : "page #{entry.page}, ") +
      (entry.loc.nil? ? "" : "loc. #{entry.loc}")).delete_suffix(", ")
  end
end