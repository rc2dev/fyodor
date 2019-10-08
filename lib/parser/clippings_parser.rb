require_relative "../entities/library"
require_relative "entry_parser"

class ClippingsParser
  SEPARATOR = /^==========\r?\n$/
  ENTRY_SIZE = 5

  def initialize(clippings_path, parser_config)
    @path = clippings_path
    @config = parser_config
    @library = Library.new
    @entry_lines = []
  end

  def library
    parse if @library.empty?
    @library
  end


  private

  def parse
    File.open(@path).each do |line|
      @entry_lines << line
      if end_entry?
        add_to_library
        @entry_lines.clear
      end
    end
    raise "MyClippings is badly formatted" if @entry_lines.size > 0
  end

  def end_entry?
    return false if @entry_lines.size < ENTRY_SIZE
    return true if @entry_lines.size == ENTRY_SIZE && @entry_lines.last =~ SEPARATOR
    raise "MyClippings is badly formatted"
  end

  def add_to_library
    parser = EntryParser.new(@entry_lines, @config)
    @library.add_entry(parser.title, parser.author, parser.entry)
  end
end