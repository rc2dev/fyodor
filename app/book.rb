class Book
  attr_accessor :entries
  attr_reader :title, :author, :num_notes, :num_highlights, :num_na

  def initialize(title, author)
    raise "Book title can't be empty" if title.to_s.empty?

    @title = title
    @author = author
    @entries = []
  end

  def finish
    rm_empty_entries
    rm_dup_entries
    set_counters
  end

  def basename
    base = @author.to_s.empty? ? @title : "#{@author} - #{@title}"
    base.strip.gsub(/[?*:|\/"<>]/,"_")
  end


  private

  def rm_empty_entries
    @entries.select! { |entry| ! entry.empty? }
  end

  def rm_dup_entries
    @entries.uniq! { |entry| entry.uniq_info }
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
