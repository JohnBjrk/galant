import gleeunit
import galant.{
  blue, bold, color_256, color_bg_hex, color_bg_rgb, color_rgb, end_bold,
  end_strikethrough, green, magenta, open, placeholder, save, start_bg_color_hex,
  start_bold, start_color_hex, start_inverse, start_italic, start_magenta,
  start_red, start_strikethrough, start_underline, start_yellow, text, to_string,
  to_string_styler,
}
import gleam/list.{index_map, repeat}
import gleam/io
import gleam/int
import gleam/erlang.{start_arguments}

pub fn main() {
  case start_arguments() {
    [] -> gleeunit.main()
    ["demo"] -> glow_test()
    _ -> {
      io.println("Unexpected argument(s)!")
      io.println("Usage:")
      io.println("gleam run test (to run normal tests")
      io.println("gleam run test demo (to run demo)")
    }
  }
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn glow_test() {
  repeat("lorem ipsum", 256)
  |> index_map(fn(index, text) {
    let colored_text =
      open()
      |> color_256(int.to_string(index) <> " " <> text, index)
      |> to_string()
    io.println(colored_text)
  })

  let style_template =
    open()
    |> start_bold()
    |> start_strikethrough()
    |> start_color_hex(0xE6F14A)
    |> placeholder()
    |> end_strikethrough()
    |> end_bold()

  let my_style =
    style_template
    |> save()

  let auto_style =
    style_template
    |> to_string_styler()

  let sample =
    open()
    |> blue("blue text ")
    |> color_rgb("RBG text ", 215, 144, 123)
    |> bold("RGB bold ")
    |> color_256("other color ", 219)
    |> bold("other color bold text\n")
    |> green("green text non bold ")
    |> my_style("my styled text ")
    |> blue("some blue non bold ")
    |> start_bold()
    |> green("bold green text ")
    |> blue("blue bold ")
    |> end_bold()
    |> text("blue non bold ")
    |> to_string()
  io.println(sample)
  io.println(auto_style("Auto styled text") <> " and some normal text")

  let inverse_text =
    open()
    |> start_color_hex(0x3F826D)
    |> start_bg_color_hex(0xC03221)
    |> start_inverse()
    |> text("Inverse")
    |> to_string()
  io.println(inverse_text)

  open()
  |> green("I'm the mighty frog")
  |> to_string()
  |> io.println()

  open()
  |> start_yellow()
  |> start_bold()
  |> text("I'm a very bold lemon ")
  |> end_bold()
  |> text("I'm normal banana")
  |> to_string()
  |> io.println()

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

  let correction =
    open()
    |> start_strikethrough()
    |> start_red()
    |> placeholder()
    |> to_string_styler()

  "I'm not very good at " <> correction("speling") <> " all the " <> correction(
    "wurds",
  )
  |> io.println()

  open()
  |> text("Basic ")
  |> start_bold()
  |> magenta("galant")
  |> end_bold()
  |> text(" example")
  |> to_string()
  |> io.println()

  open()
  |> text("In Xterm this color is called ")
  |> color_256("DarkOrange3", 166)
  |> to_string()
  |> io.println()

  open()
  |> text("A pastel palette\n")
  |> color_bg_rgb("     ", 231, 231, 238)
  |> color_bg_hex("     ", 0xE9FAE3)
  |> color_bg_hex("     ", 0xDEE8D5)
  |> color_bg_hex("     ", 0xD5C7BC)
  |> color_bg_rgb("     ", 172, 146, 166)
  |> to_string()
  |> io.println()
}
