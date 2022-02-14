require "fyodor/core_extensions/hash/merging"
require "pathname"
require "toml"

module Fyodor
  class ConfigGetter
    DEFAULT_CONFIG_PATH = File.dirname(__FILE__) + "/../../share/fyodor.toml"
    DEFAULT_TEMPLATE_PATH = File.dirname(__FILE__) + "/../../share/template.erb"


    def config
      return @config if defined?(@config)

      Hash.include CoreExtensions::Hash::Merging
      config = default_config.deep_merge(user_config)
      config["output"]["template"] = template

      @config = config
    end


    private

    def config_dir
      @config_dir ||= Pathname.new(ENV["XDG_CONFIG_HOME"] || "~/.config").expand_path + "fyodor"
    end

    def user_config_path
      config_dir + "fyodor.toml"
    end

    def user_template_path
      config_dir + "template.erb"
    end

    def user_config
      if user_config_path.exist?
        puts "Using config at #{user_config_path}.\n"
        return TOML.load_file(user_config_path)
      end

      puts "No config found: using defaults.\n"
      {}
    end

    def default_config
      @default_config ||= TOML.load_file(DEFAULT_CONFIG_PATH)
    end

    def template
      if user_template_path.exist?
        puts "Using custom template at #{user_template_path}.\n\n"
        return File.read(user_template_path)
      end

      puts "No custom template found: using default.\n\n"
      File.read(DEFAULT_TEMPLATE_PATH)
    end
  end
end
