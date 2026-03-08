# frozen_string_literal: true

require "test_helper"
require "stringio"

class CLITest < Minitest::Test
  def setup
    @cli = Concat::CLI.new
    @tmpdir = Dir.mktmpdir
  end

  def teardown
    FileUtils.rm_rf(@tmpdir)
  end

  def test_single_file
    file = File.join(@tmpdir, "example.md")
    File.write(file, "hello world")

    output = capture_stdout { @cli.call([file]) }

    assert_includes output, "# File path: #{file}"
    assert_includes output, "hello world"
  end

  def test_multiple_files
    file1 = File.join(@tmpdir, "a.rb")
    file2 = File.join(@tmpdir, "b.rb")
    File.write(file1, "puts 'a'")
    File.write(file2, "puts 'b'")

    output = capture_stdout { @cli.call([file1, file2]) }

    assert_includes output, "# File path: #{file1}"
    assert_includes output, "puts 'a'"
    assert_includes output, "# File path: #{file2}"
    assert_includes output, "puts 'b'"
  end

  def test_directory
    subdir = File.join(@tmpdir, "src")
    FileUtils.mkdir_p(subdir)
    File.write(File.join(subdir, "foo.rb"), "class Foo; end")

    output = capture_stdout { @cli.call([@tmpdir]) }

    assert_includes output, "# File path: #{subdir}/foo.rb"
    assert_includes output, "class Foo; end"
  end

  def test_mixed_files_and_directories
    file = File.join(@tmpdir, "standalone.md")
    File.write(file, "# Readme")

    subdir = File.join(@tmpdir, "lib")
    FileUtils.mkdir_p(subdir)
    File.write(File.join(subdir, "app.rb"), "module App; end")

    output = capture_stdout { @cli.call([file, subdir]) }

    assert_includes output, "# File path: #{file}"
    assert_includes output, "# Readme"
    assert_includes output, "# File path: #{subdir}/app.rb"
    assert_includes output, "module App; end"
  end

  def test_nonexistent_path_returns_nonzero
    stderr_output = capture_stderr do
      result = @cli.call(["nonexistent_path_xyz"])
      assert_equal 1, result
    end

    assert_includes stderr_output, "nonexistent_path_xyz: No such file or directory"
  end

  def test_no_arguments_returns_nonzero
    result = capture_stdout { @cli.call([]) }
    # call returns 1 when no args given; stdout has the error message
    # re-run to check return value
    assert_equal 1, @cli.call([])
  end

  def test_file_skips_extensions_filter
    file = File.join(@tmpdir, "notes.txt")
    File.write(file, "some notes")

    output = capture_stdout { @cli.call(["--extensions=rb", file]) }

    assert_includes output, "# File path: #{file}"
    assert_includes output, "some notes"
  end

  def test_directory_respects_extensions_filter
    FileUtils.mkdir_p(File.join(@tmpdir, "src"))
    File.write(File.join(@tmpdir, "src", "app.rb"), "module App; end")
    File.write(File.join(@tmpdir, "src", "notes.txt"), "some notes")

    output = capture_stdout { @cli.call(["--extensions=rb", @tmpdir]) }

    assert_includes output, "app.rb"
    refute_includes output, "notes.txt"
  end

  def test_binary_file_skipped
    file = File.join(@tmpdir, "binary.bin")
    File.write(file, "hello\x00world")

    output = capture_stdout { @cli.call([file]) }

    refute_includes output, "binary.bin"
  end

  private

  def capture_stdout
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end

  def capture_stderr
    old_stderr = $stderr
    $stderr = StringIO.new
    yield
    $stderr.string
  ensure
    $stderr = old_stderr
  end
end
