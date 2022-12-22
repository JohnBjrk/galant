# galant

[![Package Version](https://img.shields.io/hexpm/v/galant)](https://hex.pm/packages/galant)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/galant/)

 A Gleam library for creating colored and decorated strings for the terminal using ANSI Escape Sequences

## Installation

To install from Hex

```sh
gleam add galant
```

Documentation can be found at <https://hexdocs.pm/galant>.

## Overview

galant is a Gleam library that creates colored and decorated strings for the terminal. It has a fluent API which can be composed for matching various use-cases. Here is a simple example of how a styled string can be created.

```gleam
open()
|> text("Basic ")
|> start_bold()
|> magenta("galant")
|> end_bold()
|> text(" example")
|> to_string()
|> io.println()
```

><span style="color:white">Basic </span><span style="color:magenta">galant</span><span style="color:white"> example</span>

## Usage

galant supports some different options for coloring and styling text for the terminal using `ANSI Escape Sequences`. The most direct way is to use the various text-styling functions to create a styling sequence that can be transformed into a styled string. This method introduces the basic api and is the basic building block which can be used to compose reusable element later on.

The `open()` function can be used to start a new styling sequence and is followed by one or more styling functions. The sequence can be terminated with a call to `to_string()` which will produce a string with the relevant `ANSI Escape Sequences`.

```gleam
  open()
  |> green("I'm the mighty frog")
  |> to_string()
  |> io.println()
```
> <span style="color:green">I'm the mighty frog</span>

To add color and decoration to a piece of text the `start_{color/decoration}` functions can be used. For decorations there also exists a corresponding `end_{decoration}` function which is useful for decorating only parts of a text. These functions can be used in conjunction with the `text(String)` function which will insert a piece of text in the styling sequence.

```gleam
open()
|> start_yellow()
|> start_bold()
|> text("I'm a very bold lemon ")
|> end_bold()
|> text("and I'm normal banana")
|> to_string()
|> io.println()
```

> <span style="color:yellow;font-weight:bold">I'm a very bold lemon <span style="font-weight:normal">and I'm a normal banana</span></span>

Furthermore styling sequences can be captured by replacing the `to_string()` with the `save()` function and utilizing the `placeholder()` function somewhere in the sequence. This will return a style-function that takes one `String` argument and can then be used in other styling sequences to style a string accordingly.

```gleam
let party_style =
  open()
  |> start_magenta()
  |> start_italic()
  |> start_underline()
  |> placeholder()
  |> save()

open()
|> text("Welcome to ")
|> party_style("the party!!")
|> to_string()
|> io.println()
```

> Welcome to <span style="color:magenta;font-style:italic;text-decoration:underline">the party!!</span>

Finally the same principle as with `save()` can be used but with `to_string_styler()` on a sequence with a placeholder. This will create a function that can be applied to a string to directly style it without the need to include it in another styling sequence.

```gleam
I'm not very good at " <> correction("speling") <> " all the " <> correction("wurds")
```

> I'm not very good at <span style="color:red;text-decoration:line-through">speling</span> all the <span style="color:red;text-decoration:line-through">wurds</span>

## Colors
The 8 standard colors black, white, red, green, blue, magenta and cyan all have their corresponding named functions.

If you target terminal supports 256 colors or RGB (Truecolor) colors can be applied with the same principles using the `color_256` (for 256 colors) and `color_rgb`/`color_hex` functions.

```gleam
open()
|> text("In Xterm this color is called ")
|> color_256("DarkOrange3", 166)
|> to_string()
|> io.println()
```

> In Xterm this color is called> <span style="color:rgb(175,95,0)">DarkOrange3</span>

```gleam
open()
|> text("A pastel palette\n")
|> color_bg_rgb("     ", 231, 231, 238)
|> color_bg_hex("     ", 0xE9FAE3)
|> color_bg_hex("     ", 0xDEE8D5)
|> color_bg_hex("     ", 0xD5C7BC)
|> color_bg_rgb("     ", 172, 146, 166)
|> to_string()
|> io.println()
```

> A pastel palette
>
> <span style="background-color:rgb(231,231,238)">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="background-color:#E9FAE3">&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="background-color:#DEE8D5">&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="background-color:#D5C7BC">&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="background-color:rgb(172,146,166)">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>

## Text decoration
Text decorations have their own named functions, like `bold` and `italic` and few more. Beware that not all decorations may be supported in all terminals.