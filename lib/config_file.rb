# frozen_string_literal: true

module Template
  class ConfigFile
    CONFIG_FILES_PATH = File.join(File.dirname(__FILE__), 'files/')

    def initialize(path)
      @path = path
      @lines = File.readlines("#{CONFIG_FILES_PATH}#{@path}")
    end

    def drop!(*filters)
      @lines = @lines.select { |line| filters.none? { |filter| line.include?(filter) } }
    end

    def replace!(part_of_old, updated)
      index = @lines.index { |line| line.include?(part_of_old) }
      @lines[index] = "#{updated}\n"
    end

    def gsub!(old, updated)
      regex = Regexp.quote(old)
      @lines.map! { |line| line.gsub(/#{regex}/, updated) }
    end

    def cleanup(*comments)
      regex = /#{comments.map { |comment| " #\\srat-#{comment}" }.join('|')}/
      @lines = @lines.map! { |line| line.gsub(regex, '') }
    end

    def to_s
      @lines.join('')
    end

    def write!(path = @path)
      File.write(path, @lines.join(''))
    end
  end
end
