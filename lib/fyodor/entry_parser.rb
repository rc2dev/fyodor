require "fyodor/entry"

module Fyodor
  class EntryParser
    def initialize(entry_lines, parser_config)
      @lines = entry_lines
      @config = parser_config
      format_check
    end

    def entry
      Entry.new({
        book_title: book[:title],
        book_author: book[:author],
        text: text,
        desc: desc,
        type: type,
        loc: loc,
        loc_start: loc_start,
        page: page,
        page_start: page_start,
        time: time
      })
    end


    private

    def book
      regex = /^(.*) \((.*)\)\r?\n$/

      title, author = @lines[0].scan(regex).first
      # If book has no author, regex fails.
      if title.nil?
        title = @lines[0]
        author = ""
      end

      title = rm_zero_width_chars(title).strip
      author = rm_zero_width_chars(author).strip

      {title: title, author: author}
    end

    def desc
      @lines[1].delete_prefix("- ").strip
    end

    def type
      Entry::TYPE.values.find do |type|
        keyword = Regexp.quote(@config[type])
        regex = /^- #{keyword}/i

        @lines[1] =~ regex
      end
    end

    def loc
      keyword = Regexp.quote(@config["loc"])
      regex = /#{keyword} (\S+)/i

      @lines[1][regex, 1]
    end

    def loc_start
      keyword = Regexp.quote(@config["loc"])
      regex = /#{keyword} (\d+)(-\d+)?/i

      @lines[1][regex, 1].to_i
    end

    def page
      keyword = Regexp.quote(@config["page"])
      regex = /#{keyword} (\S+)/i

      @lines[1][regex, 1]
    end

    def page_start
      keyword = Regexp.quote(@config["page"])
      regex = /#{keyword} (\d+)(-\d+)?/i

      @lines[1][regex, 1].to_i
    end

    def time
      keyword = Regexp.quote(@config["time"])
      regex = /#{keyword} (.*)\r?\n$/i

      @lines[1][regex, 1]
    end

    def text
      @lines[3..-2].join.strip
    end

    def format_check
      raise "Entry is badly formatted" if @lines[0].strip.empty?
      raise "Entry is badly formatted" if @lines[1].strip.empty?
      raise "Entry is badly formatted" unless @lines[2].strip.empty?
    end

    def rm_zero_width_chars(str)
      str.gsub(/[\u200B-\u200D\uFEFF]/, '')
    end
  end
end
