require "fyodor/entry"

module Fyodor
  module Strings
    PLURAL = { Entry::TYPE[:highlight] => "highlights",
               Entry::TYPE[:note] => "notes",
               Entry::TYPE[:bookmark] => "bookmarks",
               Entry::TYPE[:clip] => "clips",
               nil => "unrecognized" }

    SINGULAR = { Entry::TYPE[:highlight] => "highlight",
                 Entry::TYPE[:note] => "note",
                 Entry::TYPE[:bookmark] => "bookmark",
                 Entry::TYPE[:clip] => "clip",
                 nil => "unrecognized",
                 :AUTHOR_NA => "Author Not Available"}
  end
end
