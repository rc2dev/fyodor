class ClippingsParser

  SEPARATOR = /^==========\r?\n$/

  def initialize(clippings_path, parser_config)
    @path = clippings_path
    @config = parser_config
    set_type_regexes
  end

  # Parse MyClippings.txt into an array of entries.
  def parse
    cur_entry = nil
    entry_ln = nil
    entries = []

    File.open(@path).each do |line|
      if $. == 1
        cur_entry = Entry.new
        entry_ln = 1
      elsif line =~ SEPARATOR
        entries << cur_entry
        cur_entry = Entry.new
        entry_ln = 0
      end

      case entry_ln
      when 1
        cur_entry.book = get_book(line)
      when 2
        cur_entry.desc = get_desc(line)
        cur_entry.type = get_type(line)
      when 4..Float::INFINITY
        cur_entry.text << get_text(line)
      end

      entry_ln += 1
    end

    entries
  end


  private

  def get_book(line)
    title, author = line.scan(/^(.*) \((.*)\)\r?\n$/).flatten
    {title: title, author: author}
  end

  def get_desc(line)
    line[/^- (.*)\r?\n$/, 1].strip
  end

  def get_type(line)
    if line =~ @type_regexes[:note]
      Entry::TYPE_NOTE
    elsif line =~ @type_regexes[:highlight]
      Entry::TYPE_HIGHLIGHT
    else
      Entry::TYPE_NA
    end
  end

  def get_text(line)
    line.chomp.strip
  end

  def set_type_regexes
    @type_regexes = { note: /^- #{Regexp.quote(@config["note_str"])}/,
                      highlight: /^- #{Regexp.quote(@config["highlight_str"])}/ }
  end

end