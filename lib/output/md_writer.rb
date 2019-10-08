require_relative "../util/util"

class MdWriter
  include Util

  def initialize(book, path, config)
    @book = book
    @path = path
    @config = config
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
    entries.size == 0 ? "" : entries_render(entries)
  end

  def bookmarks
    bookmarks = @book.select { |entry| entry.type == Entry::TYPE[:bookmark] }
    bookmarks.size == 0 ? "" : entries_render(bookmarks, "Bookmarks")
  end

  def entries_render(entries, title=nil)
    output = "---\n\n"
    output += "## #{title}\n\n" unless title.nil?
    entries.each do |entry|
      output += "#{entry_text(entry)}\n\n"
      output += "<p style=\"text-align: right;\"><sup>#{entry_desc(entry)}</sup></p>\n\n"
    end
    output
  end

  def entry_text(entry)
    case entry.type
    when Entry::TYPE[:bookmark]
      "* #{page(entry)}"
    when Entry::TYPE[:note]

      "> _#{text(entry)}_"
    else
      "> #{text(entry)}"
    end
  end

  def entry_desc(entry)
    return entry.desc unless entry.desc_parsed?

    case entry.type
    when Entry::TYPE[:bookmark]
      time(entry)
    else
      (type(entry) + " @ " + page(entry) + " " + time(entry)).strip
    end
  end

  def page(entry)
    ((entry.page.nil? ? "" : "page #{entry.page}, ") +
      (entry.loc.nil? ? "" : "loc. #{entry.loc}")).delete_suffix(", ")
  end

  def time(entry)
    @config["time"] ? "[#{entry.time}]" : ""
  end

  def type(entry)
    SINGULAR[entry.type]
  end

  def text(entry)
    # Markdown needs no white space between text and formatters
    entry.text.strip
  end
end