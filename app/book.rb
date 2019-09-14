class Book
  attr_accessor :entries, :num_notes, :num_highlights, :num_na
  attr_reader :title, :author, :filename

  def initialize(title, author)
    @title = title
    @author = author
    set_filename
    @entries = []
  end

  def clean_book
    rm_empty_entries
    rm_dup_entries
  end


  private

  def set_filename
    filename = "#{@author} - #{@title}"
    filename.strip!
    filename.gsub!(/[?*:|\/"<>]/,"_")
    @filename = filename + ".md"
  end

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
end
