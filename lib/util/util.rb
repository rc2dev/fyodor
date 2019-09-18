module Util

  PLURAL = { Entry::TYPE[:highlight] => "highlights",
    Entry::TYPE[:note] => "notes",
    Entry::TYPE[:bookmark] => "bookmarks",
    Entry::TYPE[:clip] => "clips",
    Entry::TYPE[:na] => "unrecognized" }

  SINGULAR = { Entry::TYPE[:highlight] => "highlight",
      Entry::TYPE[:note] => "note",
      Entry::TYPE[:bookmark] => "bookmark",
      Entry::TYPE[:clip] => "clip",
      Entry::TYPE[:na] => "unrecognized" }
end