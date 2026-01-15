# frozen_string_literal: true

require "optparse"

module Concat
  class CLI
    COMMENT = "#"

    def call(argv)
      extensions = ""

      parser = OptionParser.new do |parse|
        parse.banner = "Usage: concat FOLDERS... --extensions=rb,py,md"
        parse.on("--extensions=LIST", String, "File extensions to include") do |value|
          extensions = ".{#{value}}"
        end
      end

      parser.parse!(argv)

      if argv.empty?
        puts "ERROR!!!"
        puts "You need to pass in a file path."
        return 1
      end

      argv.each do |folder|
        Dir.glob("#{folder}/**/*#{extensions}").each do |path|
          if File.file?(path)
            puts "#{COMMENT} File path: #{path}"
            puts File.read(path)
            puts
          end
        end
      end

      0
    end
  end
end
