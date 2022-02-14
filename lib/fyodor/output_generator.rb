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
      @regular_entries ||= @book.reject { |entry| entry.type == Entry::TYPE[:bookmark] }.sort
    end

    def bookmarks
      @bookmarks ||= @book.select { |entry| entry.type == Entry::TYPE[:bookmark] }.sort
    end

    def place(entry)
      raise "Description is not parsed." unless entry.desc_parsed?

      ((entry.page.nil? ? "" : "page #{entry.page}, ") +
        (entry.loc.nil? ? "" : "loc. #{entry.loc}")).delete_suffix(", ")
    end
  end
end
