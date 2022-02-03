require "fyodor/strings"
require "erb"

module Fyodor
  class MdGenerator
    include Strings

    DEFAULT_TEMPLATE = %q{<%= "# #{@book.basename}" %>
      <% if regular_entries.size > 0 %>
        <%- 1 %><%= "## Highlights and notes" %>

        <%- 1 %><%= render_entries(regular_entries) %>
      <% end -%>
      <% if bookmarks.size > 0 %>
        <%- 1 %><%= "## Bookmarks" %>

        <%- 1 %><%= render_entries(bookmarks) %>
      <% end -%>
    }

    def initialize(book, config)
      @book = book
      @config = config
    end

    def content
      ERB.new(DEFAULT_TEMPLATE, nil, '-').result(binding)
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
      entries.each do |entry|
        output += "- #{item_text(entry)}\n\n"
        output += "  #{item_desc(entry)}\n\n"
      end
      output
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
