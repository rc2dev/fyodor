require_relative "entry_parser"

module Fyodor
  class ClippingsParser
    SEPARATOR = /^==========\r?\n$/
    ENTRY_SIZE = 5

    def initialize(clippings_path, parser_config)
      @path = clippings_path
      @config = parser_config
    end

    def parse(library)
      lines = []
      File.open(@path).each do |line|
        lines << line
        if end_entry?(lines)
          library << parse_entry(lines)
          lines.clear
        end
      end
      raise "MyClippings is badly formatted" if lines.size > 0
    end

    private

    def end_entry?(lines)
      return false if lines.size < ENTRY_SIZE
      return true if lines.size == ENTRY_SIZE && lines.last =~ SEPARATOR
      raise "MyClippings is badly formatted"
    end

    def parse_entry(lines)
      EntryParser.new(lines, @config).entry
    end
  end
end
