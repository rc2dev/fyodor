require_relative "../entities/entry"

class EntryParser
  def initialize(entry_lines, parser_config)
    @lines = entry_lines
    @config = parser_config
    format_check
  end

  def entry
    Entry.new({text: text, desc: desc, type: type, loc: loc,
      loc_start: loc_start, page: page, time: time})
  end

  def title
    title_author[:title]
  end

  def author
    title_author[:author]
  end


  private

  def title_author
    title, author = @lines[0].scan(regex_cap(:title_author)).first
    # If book has no author, regex fails.
    title = @lines[0] if title.nil?

    {title: title.strip, author: author.to_s.strip}
  end

  def desc
    @lines[1].delete_prefix("- ").strip
  end

  def type
    Entry::TYPE.values.find { |type| @lines[1] =~ regex_type(type) }
  end

  def loc
    @lines[1][regex_cap(:loc), 1]
  end

  def loc_start
    @lines[1][regex_cap(:loc_start), 1].to_i
  end

  def page
    @lines[1][regex_cap(:page), 1]
  end

  def time
    @lines[1][regex_cap(:time), 1]
  end

  def text
    @lines[3].strip
  end

  def regex_type(type)
    s = Regexp.quote(@config[type])
    /^- #{s}/
  end

  def regex_cap(item)
    case item
    when :title_author
      /^(.*) \((.*)\)\r?\n$/
    when :loc
      s = Regexp.quote(@config["loc"])
      /#{s} (\S+)/
    when :loc_start
      s = Regexp.quote(@config["loc"])
      /#{s} (\d+)(-\d+)?/
    when :page
      s = Regexp.quote(@config["page"])
      /#{s} (\S+)/
    when :time
      s = Regexp.quote(@config["time"])
      /#{s} (.*)\r?\n$/
    end
  end

  def format_check
    raise "Entry must have five lines" unless @lines.size == 5
    raise "Entry is badly formatted" if @lines[0].strip.empty?
    raise "Entry is badly formatted" if @lines[1].strip.empty?
    raise "Entry is badly formatted" unless @lines[2].strip.empty?
  end
end