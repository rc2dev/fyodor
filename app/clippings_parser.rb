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
      parse_title_author
    when 2
      parse_desc
      parse_type
      parse_loc
      parse_page
      parse_time
    when 4..Float::INFINITY
      parse_text
    end
  end

  def parse_title_author
    @title, @author = @line.scan(regex_cap[:title_author]).first
    @title = @line.chomp.strip if @title.nil?
  end

  def parse_desc
    @entry.desc = @line[regex_cap[:desc], 1].chomp.strip
  end

  def parse_type
    regex_id_type.each do |type, regex|
      if @line =~ regex
        @entry.type = type
        return
      end
    end
    @entry.type = Entry::TYPE[:na]
  end

  def parse_loc
    @entry.loc = @line[regex_cap[:loc], 1]
    @entry.loc_start = @line[regex_cap[:loc_start], 1]
  end

  def parse_page
    @entry.page = @line[regex_cap[:page], 1]
  end

  def parse_time
    @entry.time = @line[regex_cap[:time], 1].chomp.strip
  end

  def parse_text
    @entry.text << @line.chomp.strip
  end

  def regex_id
    { separator: /^==========\r?\n$/ }
  end

  def regex_id_type
    { Entry::TYPE[:note] => /^- #{Regexp.quote(@config["note"])}/,
      Entry::TYPE[:highlight] => /^- #{Regexp.quote(@config["highlight"])}/,
      Entry::TYPE[:bookmark] => /^- #{Regexp.quote(@config["bookmark"])}/,
      Entry::TYPE[:clip] => /^- #{Regexp.quote(@config["clip"])}/ }
  end

  def regex_cap
    { title_author: /^(.*) \((.*)\)\r?\n$/,
      desc: /^- (.*)$/,
      loc: /#{Regexp.quote(@config["loc"])} ([^\s]+)/,
      loc_start: /#{Regexp.quote(@config["loc"])} (\d+)(-\d+)?/,
      page: /#{Regexp.quote(@config["page"])} ([^\s]+)/,
      time: /#{Regexp.quote(@config["time"])} (.*)$/ }
  end
end