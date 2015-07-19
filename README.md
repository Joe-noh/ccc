# CCC

[![Build Status](http://travis-ci.org/Joe-noh/ccc.svg?branch=master "Build Status")](https://travis-ci.org/Joe-noh/ccc)

### What's this?

This is a library for converting character code.

### How to use?

```elixir
# CCC.convert(string, from, to)

iex> CCC.convert "概ねアグリー", "UTF-8", "EUC-JP"
<<179, 181, 164, 205, 165, 162, 165, 176, 165, 234, 161, 188>>
```

CCC uses libiconv. Please refer to [the documents](http://www.gnu.org/software/libiconv/).

### Contribution

Bug reports, pull requests, whatever else will be welcomed.
