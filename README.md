# AhoCorasick

A Julia implementation of the Aho-Corasick algorithm for fast string
searching.

## Example

```julia
using AhoCorasick
ac = Automaton()
add(ac, "alpha")
add(ac, "beta", "mykey")
build(ac) 
search(ac, "alpha and beta")
```

## Features

- Can be run in case-sensitive or case-insensitive mode
- Optional keys can be attached to each word in the automaton

## License

GNU GPLv3
