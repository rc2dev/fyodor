class Book
  attr_reader :title, :author, :entries, :num_notes, :num_highlights, :num_na

  def initialize(book_info, book_entries)
    @title = book_info[:title]
    @author = book_info[:author]
    @entries = book_entries
  end

  def finish
    rm_empty_entries
    rm_dup_entries
    set_counters
  end

  def filename
    "#{@author} - #{@title}".strip.gsub(/[?*:|\/"<>]/,"_") + ".md"
  end


  private

  def rm_empty_entries
    @entries.select! { |entry| entry.text.strip != "" }
  end

  def rm_dup_entries
    # We shouldn't remove notes with equal text, as they can be desired
    # Eg: TODO reminders on a document
    # Duplicate highlights, on the other hand, are probably useless
    @entries.uniq! do |entry|
      [entry.text, entry.type != Entry::TYPE_NOTE || entry.desc]
    end
  end

  def set_counters
    @entries_by_type = @entries.group_by { |entry| entry.type }

    set_counter("@num_notes", Entry::TYPE_NOTE)
    set_counter("@num_highlights", Entry::TYPE_HIGHLIGHT)
    set_counter("@num_na", Entry::TYPE_NA)
  end

  def set_counter(var_name, type)
    counter = @entries_by_type.key?(type) ? @entries_by_type[type].count : 0
    instance_variable_set(var_name, counter)
  end
end
