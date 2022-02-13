require "fyodor/strings"
require "erb"

module Fyodor
  class OutputGenerator
    include Strings

    def initialize(book, config)
      @book = book
      @config = config
    end

    def content
      ERB.new(@config["template"], trim_mode: '-').result(binding)
    end


    private

    def regular_entries
      @book.reject { |entry| entry.type == Entry::TYPE[:bookmark] }
    end

    def bookmarks
      @book.select { |entry| entry.type == Entry::TYPE[:bookmark] }
    end

    def render_entries(entries)
      output = ""
      entries.sort.each do |entry|
        output += "- #{item_text(entry)}\n\n"
        output += "  #{item_desc(entry)}\n\n" unless item_desc(entry).empty?
      end
      output.strip
    end

    def item_text(entry)
      case entry.type
      when Entry::TYPE[:bookmark]
        "#{page(entry)}"
      when Entry::TYPE[:note]
        "_Note:_ #{entry.text.strip}"
      else
        "#{entry.text.strip}"
      end
    end

    def item_desc(entry)
      return entry.desc unless entry.desc_parsed?

      case entry.type
      when Entry::TYPE[:bookmark]
        time(entry)
      else
        (type(entry) + " @ " + page(entry) + " " + time(entry)).strip
      end
    end

    def page(entry)
      ((entry.page.nil? ? "" : "page #{entry.page}, ") +
        (entry.loc.nil? ? "" : "loc. #{entry.loc}")).delete_suffix(", ")
    end

    def time(entry)
      @config["time"] ? "[#{entry.time}]" : ""
    end

    def type(entry)
      SINGULAR[entry.type]
    end
  end
end
