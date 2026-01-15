# frozen_string_literal: true

require "fileutils"

module Concat
  class DeconcatCLI
    def call(argv)
      if argv.empty?
        puts "ERROR!!!"
        puts "You need to pass in a target directory."
        return 1
      end

      target_dir = argv.first
      current_path = nil
      content = []

      $stdin.each_line do |line|
        if line.start_with?("# File path: ")
          write_file(target_dir, current_path, content) if current_path && !content.empty?
          current_path = line.sub("# File path: ", "").strip
          content = []
        else
          content << line
        end
      end

      write_file(target_dir, current_path, content) if current_path && !content.empty?

      0
    end

    private

    def write_file(target_dir, path, content)
      full_path = File.join(target_dir, path)
      FileUtils.mkdir_p(File.dirname(full_path))
      File.write(full_path, content.join)
    end
  end
end
