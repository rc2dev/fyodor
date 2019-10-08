require_relative "../entities/entry"

module Util
  PLURAL = { Entry::TYPE[:highlight] => "highlights",
             Entry::TYPE[:note] => "notes",
             Entry::TYPE[:bookmark] => "bookmarks",
             Entry::TYPE[:clip] => "clips",
             nil => "unrecognized" }

  SINGULAR = { Entry::TYPE[:highlight] => "highlight",
               Entry::TYPE[:note] => "note",
               Entry::TYPE[:bookmark] => "bookmark",
               Entry::TYPE[:clip] => "clip",
               nil=> "unrecognized" }
end