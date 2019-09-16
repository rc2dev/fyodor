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
    end
  end


  private

  def header
    return <<~EOF
    # #{@book.title}
    #{"by #{@book.author}" unless @book.author.to_s.empty?}

    #{header_counts}

    ---

    EOF
  end

  def header_counts
    output = ""
    @book.count.each do |type, n|
      output += "#{n} #{pluralize(type, n)}, " if n > 0
    end

    output.delete_suffix!(", ")
  end

  def pluralize(type, n)
    n == 1 ? SINGULAR[type] : PLURAL[type]
  end

  def body
    body = ""

    @book.entries.each do |entry|
      body += <<~EOF
      #{entry.type == Entry::TYPE[:note] ?  "* _#{entry.text}_" : "* #{entry.text}" }

      <sup>*#{entry.desc}*</sup>

      EOF
    end

    body
  end
end