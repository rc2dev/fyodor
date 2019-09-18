class ClippingsParser

  REGEX_ID_SEPARATOR = /^==========\r?\n$/

  def initialize(clippings_path, parser_config, library)
    @path = clippings_path
    @config = parser_config
    @library = library
  end

  def parse
    entry_lines = []
    File.open(@path).each do |line|
      if end_entry?(line)
        parse_entry(entry_lines)
        entry_lines = []
      else
        entry_lines << line
      end
    end
  end


  private

  def end_entry?(line)
    line =~ REGEX_ID_SEPARATOR
  end

  def parse_entry(entry_lines)
    ClippingsEntryParser.new(entry_lines, @config, @library).parse
  end
end