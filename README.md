<div align="center">
  <img src="./assets/term-logo.png" alt="term logo">
</div>

# Term::Cursor

![spec status](https://github.com/crystal-term/screen/workflows/specs/badge.svg)

> Terminal screen size detection which works on Linux, OS X and Windows/Cygwin platforms (or will once Windows is supported by Crystal)

**Term::Screen** provides independent terminal screen size detection component for crystal-term.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     term-screen:
       github: crystal-term/screen
   ```

2. Run `shards install`

## Usage

```crystal
require "term-screen"
```

**Term::Screen** allows you to detect terminal screen size by calling size method which returns {height, width} tuple.

```crystal
Term::Screen.size     # => {51, 280}
```

To read terminal width do:

```crystal
Term::Screen.width    # => 280
Term::Screen.columns  # => 280
Term::Screen.cols     # => 280
```

Similarly, to read terminal height do:

```crystal
Term::Screen.height   # => 51
Term::Screen.rows     # => 51
Term::Screen.lines    # => 51
```

## Contributing

1. Fork it (<https://github.com/crystal-term/cursor/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer
