# frozen_string_literal: true

require "fileutils"

module Concat
  class DeconcatCLI
    def call(argv)
      current_path = nil
      content = []

      ARGF.each_line do |line|
        if line.start_with?("# File path: ")
          File.write(current_path, content.join) if current_path && !content.empty?
          current_path = line.sub("# File path: ", "").strip
          content = []
          FileUtils.mkdir_p(File.dirname(current_path))
        else
          content << line
        end
      end

      File.write(current_path, content.join) if current_path && !content.empty?

      0
    end
  end
end

