class ClippingsParser

  SEPARATOR = /^==========\r?\n$/

  # Parse MyClippings.txt into an array of entries
  def self.parse(clippings_path)
    cur_entry = nil
    entry_ln = nil
    entries = []

    File.open(clippings_path).each do |line|
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

  def self.get_book(line)
    title, author = line.scan(/^(.*) \((.*)\)\r?\n$/).flatten
    {title: title, author: author}
  end

  def self.get_desc(line)
    line[/^- (.*)\r?\n$/, 1].strip
  end

  def self.get_type(line)
    if line =~ /^- Sua nota/
      Entry::TYPE_NOTE
    elsif line =~ /^- Seu destaque/
      Entry::TYPE_HIGHLIGHT
    else
      Entry::TYPE_NA
    end
  end

  def self.get_text(line)
    line.chomp.strip
  end
end