# concat

Concatenate files from directories into a single output, with the ability to reverse the process.

## Install

```bash
gem install concat
```

## Usage

### concat

Recursively read files from directories and output their contents with file path comments.

```bash
# Concatenate all files in a directory
concat src/

# Filter by file extensions
concat lib/ --extensions=rb,py

# Multiple directories
concat src/ lib/ --extensions=js,ts

# Save to a file
concat app/ --extensions=rb > backup.txt
```

### deconcat

Restore files from concatenated output. Reads from stdin and writes files to their original paths.

```bash
# Restore from a file
cat backup.txt | deconcat

# Pipe directly
concat lib/ --extensions=rb | deconcat
```

## Contributing

Bug reports and pull requests are welcome on GitHub.

## Development

After checking out the repo:

```bash
bin/setup
bundle exec rake test
```

Generate documentation:

```bash
bundle exec yard doc
bundle exec yard server  # Browse at http://localhost:8808
```

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).
