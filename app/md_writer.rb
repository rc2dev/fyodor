class MdWriter

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
    by #{@book.author}

    #{types_counter}

    ---

    EOF
  end

  def types_counter
    output = ""
    highlights = @book.num_highlights
    notes = @book.num_notes
    na = @book.num_na

    highlights_lbl = highlights == 1 ? "highlight" : "highlights"
    notes_lbl = notes == 1 ? "note" : "notes"
    na_lbl = "unrecognized"

    output += "\n#{highlights} #{highlights_lbl} and #{notes} #{notes_lbl}" if highlights > 0 || notes > 0
    output += "\n#{na} #{na_lbl}" if na > 0
    output
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

end