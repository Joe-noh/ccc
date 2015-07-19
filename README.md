# CCC

[![wercker status](https://app.wercker.com/status/c64a1546487124931d66163484b1c329/s/master "wercker status")](https://app.wercker.com/project/bykey/c64a1546487124931d66163484b1c329)

### What's this?

This is a library for converting character code.

### How to use?

```elixir
# CCC.convert(string, from, to)

iex> CCC.convert "概ねアグリー", "UTF-8", "EUC-JP"
<<179, 181, 164, 205, 165, 162, 165, 176, 165, 234, 161, 188>>

iex> CCC.convert "🍺", "UTF-8", "EUC-JP", discard_unsupported: true
""
```

CCC uses libiconv. Please refer to [the documents](http://www.gnu.org/software/libiconv/).

### Contribution

Bug reports, pull requests, whatever else will be welcomed.
