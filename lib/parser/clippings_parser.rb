class ClippingsParser

  SEPARATOR = /^==========\r?\n$/
  ENTRY_LEN = 5

  def initialize(clippings_path, parser_config, library)
    @path = clippings_path
    @config = parser_config
    @library = library
  end

  def parse
    entry = []
    File.open(@path).each do |line|
      entry << line
      if end_entry?(entry)
        parse_entry(entry)
        entry = []
      end
    end
    raise "MyClippings is badly formatted" if entry.count > 0
  end


  private

  def end_entry?(entry)
    return false if entry.count < ENTRY_LEN
    return true if entry.count == ENTRY_LEN && entry.last =~ SEPARATOR
    raise "MyClippings is badly formatted"
  end

  def parse_entry(entry)
    ClippingsEntryParser.new(entry, @config, @library).parse
  end
end