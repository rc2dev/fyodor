class ClippingsParser

  def initialize(clippings_path, parser_config, library)
    @path = clippings_path
    @config = parser_config
    @library = library
  end

  def parse
    @entry = Entry.new
    @entry_ln = 1

    File.open(@path).each do |line|
      @line = line

      new_entry if end_entry?
      parse_line
      @entry_ln +=1
    end
  end


  private

  def end_entry?
    @line =~ regex_id[:separator]
  end

  def new_entry
    @library.add_entry(@title, @author, @entry)
    @entry_ln = 0
    @entry = Entry.new
  end

  def parse_line
    case @entry_ln
    when 1
      @title, @author = parse_title_author
    when 2
      @entry.desc = parse_desc
      @entry.type = parse_type
      @entry.loc = parse_loc
      @entry.page = parse_page
      @entry.time = parse_time
    when 4..Float::INFINITY
      @entry.text << parse_text
    end
  end

  def parse_title_author
    title, author = @line.scan(regex_cap[:title_author]).first
    title = @line.chomp.strip if title.nil?
    [title, author]
  end

  def parse_desc
    @line[regex_cap[:desc], 1].chomp.strip
  end

  def parse_type
    if @line =~ regex_id[:note]
      Entry::TYPE[:note]
    elsif @line =~ regex_id[:highlight]
      Entry::TYPE[:highlight]
    elsif @line =~ regex_id[:bookmark]
      Entry::TYPE[:bookmark]
    elsif @line =~ regex_id[:clip]
      Entry::TYPE[:clip]
    else
      Entry::TYPE[:na]
    end
  end

  def parse_loc
    @line[regex_cap[:loc], 1]
  end

  def parse_page
    @line[regex_cap[:page], 1]
  end

  def parse_time
    @line[regex_cap[:time], 1].chomp.strip
  end

  def parse_text
    @line.chomp.strip
  end

  def regex_id
    { separator: /^==========\r?\n$/,
      note: /^- #{Regexp.quote(@config["note"])}/,
      highlight: /^- #{Regexp.quote(@config["highlight"])}/,
      bookmark: /^- #{Regexp.quote(@config["bookmark"])}/,
      clip: /^- #{Regexp.quote(@config["clip"])}/ }
  end

  def regex_cap
    { title_author: /^(.*) \((.*)\)\r?\n$/,
      desc: /^- (.*)$/,
      loc: /#{Regexp.quote(@config["loc"])} ([^\s]+)/,
      page: /#{Regexp.quote(@config["page"])} ([^\s]+)/,
      time: /#{Regexp.quote(@config["time"])} (.*)$/ }
  end
end