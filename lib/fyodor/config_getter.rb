require_relative "core_extensions/hash/merging"
require "pathname"
require "toml"

module Fyodor
  class ConfigGetter
    DEFAULT = {
      "parser" => {
        "highlight" => "Your Highlight",
        "note" => "Your Note",
        "bookmark" => "Your Bookmark",
        "clip" => "Clip This Article",
        "loc" => "Location",
        "page" => "page",
        "time" => "Added on"
      },
      "output" => {
        "time" => false
      }
    }

    def config
      @config ||= get_config
    end


    private

    def get_config
      Hash.include CoreExtensions::Hash::Merging
      print_path

      user_config = path.nil? ? {} : TOML.load_file(path)
      DEFAULT.deep_merge(user_config)
    end

    def path
      @path ||= paths.find { |path| path.exist? }
    end

    def paths
      return @paths unless @paths.nil?

      @paths = []
      @paths << Pathname.new(ENV["XDG_CONFIG_HOME"]) + "fyodor.toml" unless ENV["XDG_CONFIG_HOME"].nil?
      @paths << Pathname.new("~/.config/fyodor.toml").expand_path
    end

    def print_path
      if path.nil?
        puts "No config found: using defaults.\n\n"
      else
        puts "Using config at #{path}\n\n"
      end
    end
  end
end
