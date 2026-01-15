# concat.rb

Concatenate files from directories into a single output, with the ability to reverse the process.

## Install

```bash
gem install concat.rb
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

Example output:

```
# File path: ./lib/concat.rb
# frozen_string_literal: true

require_relative "concat/version"

module Concat
end

# File path: ./lib/concat/version.rb
# frozen_string_literal: true

module Concat
  VERSION = "1.0.0"
end
```

### deconcat

Restore files from concatenated output. Reads from stdin and writes files to their original paths.

```bash
# Restore from a file
cat backup.txt | deconcat

# Pipe directly
concat lib/ --extensions=rb | deconcat
```

### Clipboard integration

Use [clip.rb](https://github.com/n-at-han-k/clip.rb) to copy concatenated output to your clipboard:

```bash
# Copy to clipboard
concat lib/ --extensions=rb | clip

# Append to clipboard
concat src/ | clip --append

# Restore from clipboard
clip | deconcat
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
