# frozen_string_literal: true

require 'open-uri'
require 'fileutils'

module Template
  class Writer
    private

    CONFIG_FILES_PATH = File.join(File.dirname(__FILE__), 'files/')
    REPO = 'https://raw.github.com/wscourge/rails-api-template/master/'

    def download(path, destination)
      repo_file = "#{REPO}#{path}"
      begin
        delete_file(destination)
        IO.copy_stream(open(repo_file), destination)
      rescue OpenURI::HTTPError
        puts "Unable to obtain #{source}"
      end
    end

    def delete_file(name)
      File.delete(name) if File.exist?(name)
    end

    def delete_directory(path)
      FileUtils.remove_dir(path) if File.directory?(path)
    end

    def create_directory(path)
      Dir.mkdir(path)
    end

    def read_file(path)
      File.readlines(path)
    end

    def write_file(path, content)
      File.write(path, content)
    end

    def read_config_file(path)
      read_file("#{CONFIG_FILES_PATH}#{path}")
    end
  end
end
