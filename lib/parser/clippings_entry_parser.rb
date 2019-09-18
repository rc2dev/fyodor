class ClippingsEntryParser

  def initialize(entry_lines, parser_config, library)
    @lines = entry_lines
    @config = parser_config
    @library = library
    @entry = Entry.new
  end

  def parse
    raise "Entry must have four lines!" if @lines.count != 5

    title, author = title_author
    @entry.text = text
    @entry.desc = desc
    @entry.type = type
    @entry.loc = loc
    @entry.loc_start = loc_start
    @entry.page = page
    @entry.time = time
    @library.add_entry(title, author, @entry)
  end


  private

  def title_author
    title, author = @lines[0].scan(regex_cap[:title_author]).first
    title = @lines[0].chomp.strip if title.nil?
    [title, author]
  end

  def desc
    @lines[1].delete_prefix("- ").strip
  end

  def type
    regex_id_type.each { |type, regex| return type if @lines[1] =~ regex }
    Entry::TYPE[:na]
  end

  def loc
    @lines[1][regex_cap[:loc], 1]
  end

  def loc_start
    @lines[1][regex_cap[:loc_start], 1]
  end

  def page
    @lines[1][regex_cap[:page], 1]
  end

  def time
    @lines[1][regex_cap[:time], 1]
  end

  def text
    @lines[3].strip
  end

  def regex_id_type
    { Entry::TYPE[:note] => /^- #{Regexp.quote(@config["note"])}/,
      Entry::TYPE[:highlight] => /^- #{Regexp.quote(@config["highlight"])}/,
      Entry::TYPE[:bookmark] => /^- #{Regexp.quote(@config["bookmark"])}/,
      Entry::TYPE[:clip] => /^- #{Regexp.quote(@config["clip"])}/ }
  end

  def regex_cap
    { title_author: /^(.*) \((.*)\)\r?\n$/,
      loc: /#{Regexp.quote(@config["loc"])} ([^\s]+)/,
      loc_start: /#{Regexp.quote(@config["loc"])} (\d+)(-\d+)?/,
      page: /#{Regexp.quote(@config["page"])} ([^\s]+)/,
      time: /#{Regexp.quote(@config["time"])} ([^\r]*)\r?\n$/ }
  end
end