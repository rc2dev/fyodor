#!/usr/bin/env ruby

require_relative "app/main"
require_relative "app/config_getter"
require_relative "entities/book"
require_relative "entities/entry"
require_relative "entities/library"
require_relative "output/md_writer"
require_relative "output/output_writer"
require_relative "parser/clippings_entry_parser"
require_relative "parser/clippings_parser"
require_relative "util/hash"
require_relative "util/util"
require "toml"
require "pathname"
require "set"

Main.new.main