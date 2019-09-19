class ClippingsParser

  SEPARATOR = /^==========\r?\n$/
  ENTRY_LEN = 5

  def initialize(clippings_path, parser_config)
    @path = clippings_path
    @config = parser_config
    @library = Library.new
  end

  def library
    parse if @library.empty?
    @library
  end


  private

  def parse
    entry = []
    File.open(@path).each do |line|
      entry << line
      if end_entry?(entry)
        add_to_library(entry)
        entry = []
      end
    end
    raise "MyClippings is badly formatted." if entry.size > 0
  end

  def end_entry?(entry)
    return false if entry.size < ENTRY_LEN
    return true if entry.size == ENTRY_LEN && entry.last =~ SEPARATOR
    raise "MyClippings is badly formatted."
  end

  def add_to_library(entry)
    parser = EntryParser.new(entry, @config)
    @library.add_entry(parser.title, parser.author, parser.entry)
  end
end