# frozen_string_literal: true

require "optparse"

module Concat
  class CLI
    COMMENT = "#"

    def call(argv)
      extensions = ""

      parser = OptionParser.new do |parse|
        parse.banner = "Usage: concat PATHS... --extensions=rb,py,md"
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

      argv.each do |arg|
        if File.file?(arg)
          next if binary_file?(arg)
          puts "#{COMMENT} File path: #{arg}"
          puts File.read(arg)
          puts
        elsif File.directory?(arg)
          Dir.glob("#{arg}/**/*#{extensions}").each do |path|
            if File.file?(path) && !binary_file?(path)
              puts "#{COMMENT} File path: #{path}"
              puts File.read(path)
              puts
            end
          end
        else
          warn "concat: #{arg}: No such file or directory"
          return 1
        end
      end

      0
    end

    private

    def binary_file?(path)
      File.open(path, "rb") do |file|
        chunk = file.read(8192)
        return false if chunk.nil?
        chunk.include?("\x00")
      end
    end
  end
end

