import gleam/bit_string.{to_string}
import gleam/result
import gleam/int
import gleam/list.{fold, map, reverse, sized_chunk}
import gleam/string_builder.{StringBuilder, append, new}
import gleam/option.{None, Option, Some, unwrap}

const black_code = "[30m"

const black_bg_code = "[40m"

const red_code = "[31m"

const red_bg_code = "[41m"

const green_code = "[32m"

const green_bg_code = "[42m"

const yellow_code = "[33m"

const yellow_bg_code = "[43m"

const blue_code = "[34m"

const blue_bg_code = "[44m"

const magenta_code = "[35m"

const magenta_bg_code = "[45m"

const cyan_code = "[36m"

const cyan_bg_code = "[46m"

const white_code = "[37m"

const white_bg_code = "[47m"

const default_code = "[39m"

const default_bg_code = "[49m"

const reset_code = "[0m"

const start_bold_code = "[1m"

const end_bold_code = "[22m"

const start_dim_code = "[2m"

const end_dim_code = "[22m"

const start_italic_code = "[3m"

const end_italic_code = "[23m"

const start_underline_code = "[4m"

const end_underline_code = "[24m"

const start_blinking_code = "[5m"

const end_blinking_code = "[25m"

const start_reverse_code = "[7m"

const end_reverse_code = "[27m"

const start_hidden_code = "[8m"

const end_hidden_code = "[28m"

const start_strikethrough_code = "[9m"

const end_strikethrough_code = "[29m"

const rgb_code = "[38;2;"

const rgb_bg_code = "[48;2;"

/// Styling used to build the StylingSequence
pub opaque type Styling {
  Text(text: String)
  Black(text: String)
  BlackBg(text: String)
  StartBlack
  StartBlackBg
  Red(text: String)
  RedBg(text: String)
  StartRed
  StartRedBg
  Green(text: String)
  GreenBg(text: String)
  StartGreen
  StartGreenBg
  Yellow(text: String)
  YellowBg(text: String)
  StartYellow
  StartYellowBg
  Blue(text: String)
  BlueBg(text: String)
  StartBlue
  StartBlueBg
  Magenta(text: String)
  MagentaBg(text: String)
  StartMagenta
  StartMagentaBg
  Cyan(text: String)
  CyanBg(text: String)
  StartCyan
  StartCyanBg
  White(text: String)
  WhiteBg(text: String)
  StartWhite
  StartWhiteBg
  StopColor
  StopBgColor
  Default(text: String)
  DefaultBg(text: String)
  Color256(text: String, color: Int)
  ColorRGB(text: String, red: Int, green: Int, blue: Int)
  ColorBgRGB(text: String, red: Int, green: Int, blue: Int)
  StartColorRGB(red: Int, green: Int, blue: Int)
  StartColorBgRGB(red: Int, green: Int, blue: Int)
  Bold(text: String)
  StartBold
  EndBold
  Dim(text: String)
  StartDim
  EndDim
  Italic(text: String)
  StartItalic
  EndItalic
  Underline(text: String)
  StartUnderline
  EndUnderline
  Blinking(text: String)
  StartBlinking
  EndBlinking
  Reverse(text: String)
  StartReverse
  EndReverse
  Hidden(text: String)
  StartHidden
  EndHidden
  Strikethrough(text: String)
  StartStrikethrough
  EndStrikethrough
  Reset
  PlaceHolder
}

type StylingSequence =
  List(Styling)

fn color256_code(code: Int) {
  "[38;5;" <> int.to_string(code) <> "m"
}

fn color_rgb_code(code: String, red: Int, green: Int, blue: Int) {
  new()
  |> append(code)
  |> append(int.to_string(red))
  |> append(";")
  |> append(int.to_string(green))
  |> append(";")
  |> append(int.to_string(blue))
  |> append("m")
  |> string_builder.to_string()
}

fn esc() -> String {
  assert Ok(escape) =
    <<0x1b>>
    |> bit_string.to_string()
  escape
}

fn code(style_code: String) {
  esc() <> style_code
}

fn style_text(
  builder: StringBuilder,
  text: String,
  style: String,
  reset_style: Option(String),
) -> StringBuilder {
  builder
  |> append(code(style))
  |> append(text)
  |> append(unwrap(option.map(reset_style, code), ""))
}

fn hex_to_rgb(color: Int) {
  assert Ok([Ok(red), Ok(green), Ok(blue)]) =
    int.digits(color, 16)
    |> result.map(sized_chunk(_, into: 2))
    |> result.map(map(_, int.undigits(_, 16)))
  #(red, green, blue)
}

/// Start a new styled sequence
pub fn open() -> StylingSequence {
  []
}

// Style the text in black
pub fn black(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Black(text), ..styled_text]
}

// Style the background of the text in black
pub fn bg_black(styled_text: StylingSequence, text: String) -> StylingSequence {
  [BlackBg(text), ..styled_text]
}

// Use black for subsequent pars of the styling sequence
pub fn start_black(styled_text: StylingSequence) -> StylingSequence {
  [StartBlack, ..styled_text]
}

pub fn start_bg_black(styled_text: StylingSequence) -> StylingSequence {
  [StartBlackBg, ..styled_text]
}

pub fn red(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Red(text), ..styled_text]
}

pub fn bg_red(styled_text: StylingSequence, text: String) -> StylingSequence {
  [RedBg(text), ..styled_text]
}

pub fn start_red(styled_text: StylingSequence) -> StylingSequence {
  [StartRed, ..styled_text]
}

pub fn start_bg_red(styled_text: StylingSequence) -> StylingSequence {
  [StartRedBg, ..styled_text]
}

pub fn yellow(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Yellow(text), ..styled_text]
}

pub fn bg_yellow(styled_text: StylingSequence, text: String) -> StylingSequence {
  [YellowBg(text), ..styled_text]
}

pub fn start_yellow(styled_text: StylingSequence) -> StylingSequence {
  [StartYellow, ..styled_text]
}

pub fn start_bg_yellow(styled_text: StylingSequence) -> StylingSequence {
  [StartYellowBg, ..styled_text]
}

pub fn magenta(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Magenta(text), ..styled_text]
}

pub fn bg_magenta(styled_text: StylingSequence, text: String) -> StylingSequence {
  [MagentaBg(text), ..styled_text]
}

pub fn start_magenta(styled_text: StylingSequence) -> StylingSequence {
  [StartMagenta, ..styled_text]
}

pub fn start_bg_magenta(styled_text: StylingSequence) -> StylingSequence {
  [StartMagentaBg, ..styled_text]
}

pub fn cyan(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Cyan(text), ..styled_text]
}

pub fn bg_cyan(styled_text: StylingSequence, text: String) -> StylingSequence {
  [CyanBg(text), ..styled_text]
}

pub fn start_cyan(styled_text: StylingSequence) -> StylingSequence {
  [StartCyan, ..styled_text]
}

pub fn start_bg_cyan(styled_text: StylingSequence) -> StylingSequence {
  [StartCyanBg, ..styled_text]
}

pub fn white(styled_text: StylingSequence, text: String) -> StylingSequence {
  [White(text), ..styled_text]
}

pub fn bg_white(styled_text: StylingSequence, text: String) -> StylingSequence {
  [WhiteBg(text), ..styled_text]
}

pub fn start_white(styled_text: StylingSequence) -> StylingSequence {
  [StartWhite, ..styled_text]
}

pub fn start_bg_white(styled_text: StylingSequence) -> StylingSequence {
  [StartWhiteBg, ..styled_text]
}

pub fn default(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Default(text), ..styled_text]
}

pub fn bg_default(styled_text: StylingSequence, text: String) -> StylingSequence {
  [DefaultBg(text), ..styled_text]
}

pub fn blue(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Blue(text), ..styled_text]
}

pub fn bg_blue(styled_text: StylingSequence, text: String) -> StylingSequence {
  [BlueBg(text), ..styled_text]
}

pub fn start_blue(styled_text: StylingSequence) -> StylingSequence {
  [StartBlue, ..styled_text]
}

pub fn start_bg_blue(styled_text: StylingSequence) -> StylingSequence {
  [StartBlueBg, ..styled_text]
}

pub fn green(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Green(text), ..styled_text]
}

pub fn bg_green(styled_text: StylingSequence, text: String) -> StylingSequence {
  [GreenBg(text), ..styled_text]
}

pub fn start_green(styled_text: StylingSequence) -> StylingSequence {
  [StartGreen, ..styled_text]
}

pub fn start_bg_green(styled_text: StylingSequence) -> StylingSequence {
  [StartGreenBg, ..styled_text]
}

pub fn stop_color(styled_text: StylingSequence) -> StylingSequence {
  [StopColor, ..styled_text]
}

pub fn stop_bg_color(styled_text: StylingSequence) -> StylingSequence {
  [StopBgColor, ..styled_text]
}

pub fn color_256(
  styled_text: StylingSequence,
  text: String,
  color: Int,
) -> StylingSequence {
  [Color256(text, color), ..styled_text]
}

pub fn color_rgb(
  styled_text: StylingSequence,
  text: String,
  red: Int,
  green: Int,
  blue: Int,
) -> StylingSequence {
  [ColorRGB(text, red, green, blue), ..styled_text]
}

pub fn color_bg_rgb(
  styled_text: StylingSequence,
  text: String,
  red: Int,
  green: Int,
  blue: Int,
) -> StylingSequence {
  [ColorBgRGB(text, red, green, blue), ..styled_text]
}

pub fn start_color_rgb(
  styled_text: StylingSequence,
  red: Int,
  green: Int,
  blue: Int,
) -> StylingSequence {
  [StartColorRGB(red, green, blue), ..styled_text]
}

pub fn start_bg_color_rgb(
  styled_text: StylingSequence,
  red: Int,
  green: Int,
  blue: Int,
) -> StylingSequence {
  [StartColorBgRGB(red, green, blue), ..styled_text]
}

pub fn color_hex(
  styled_text: StylingSequence,
  text: String,
  color: Int,
) -> StylingSequence {
  let #(red, green, blue) = hex_to_rgb(color)
  [ColorRGB(text, red, green, blue), ..styled_text]
}

pub fn color_bg_hex(
  styled_text: StylingSequence,
  text: String,
  color: Int,
) -> StylingSequence {
  let #(red, green, blue) = hex_to_rgb(color)
  [ColorBgRGB(text, red, green, blue), ..styled_text]
}

pub fn start_color_hex(
  styled_text: StylingSequence,
  color: Int,
) -> StylingSequence {
  let #(red, green, blue) = hex_to_rgb(color)
  [StartColorRGB(red, green, blue), ..styled_text]
}

pub fn start_bg_color_hex(
  styled_text: StylingSequence,
  color: Int,
) -> StylingSequence {
  let #(red, green, blue) = hex_to_rgb(color)
  [StartColorBgRGB(red, green, blue), ..styled_text]
}

pub fn text(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Text(text), ..styled_text]
}

pub fn placeholder(styled_text: StylingSequence) -> StylingSequence {
  [PlaceHolder, ..styled_text]
}

pub fn bold(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Bold(text), ..styled_text]
}

pub fn start_bold(styled_text: StylingSequence) -> StylingSequence {
  [StartBold, ..styled_text]
}

pub fn end_bold(styled_text: StylingSequence) -> StylingSequence {
  [EndBold, ..styled_text]
}

pub fn dim(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Dim(text), ..styled_text]
}

pub fn start_dim(styled_text: StylingSequence) -> StylingSequence {
  [StartDim, ..styled_text]
}

pub fn end_dim(styled_text: StylingSequence) -> StylingSequence {
  [EndDim, ..styled_text]
}

pub fn italic(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Italic(text), ..styled_text]
}

pub fn start_italic(styled_text: StylingSequence) -> StylingSequence {
  [StartItalic, ..styled_text]
}

pub fn end_italic(styled_text: StylingSequence) -> StylingSequence {
  [EndItalic, ..styled_text]
}

pub fn underline(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Underline(text), ..styled_text]
}

pub fn start_underline(styled_text: StylingSequence) -> StylingSequence {
  [StartUnderline, ..styled_text]
}

pub fn end_underline(styled_text: StylingSequence) -> StylingSequence {
  [EndUnderline, ..styled_text]
}

pub fn blinking(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Blinking(text), ..styled_text]
}

pub fn start_blinking(styled_text: StylingSequence) -> StylingSequence {
  [StartBlinking, ..styled_text]
}

pub fn end_blinking(styled_text: StylingSequence) -> StylingSequence {
  [EndBlinking, ..styled_text]
}

pub fn inverse(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Reverse(text), ..styled_text]
}

pub fn start_inverse(styled_text: StylingSequence) -> StylingSequence {
  [StartReverse, ..styled_text]
}

pub fn end_inverse(styled_text: StylingSequence) -> StylingSequence {
  [EndReverse, ..styled_text]
}

pub fn hidden(styled_text: StylingSequence, text: String) -> StylingSequence {
  [Hidden(text), ..styled_text]
}

pub fn start_hidden(styled_text: StylingSequence) -> StylingSequence {
  [StartHidden, ..styled_text]
}

pub fn end_hidden(styled_text: StylingSequence) -> StylingSequence {
  [EndHidden, ..styled_text]
}

pub fn strikethrough(
  styled_text: StylingSequence,
  text: String,
) -> StylingSequence {
  [Strikethrough(text), ..styled_text]
}

pub fn start_strikethrough(styled_text: StylingSequence) -> StylingSequence {
  [StartStrikethrough, ..styled_text]
}

pub fn end_strikethrough(styled_text: StylingSequence) -> StylingSequence {
  [EndStrikethrough, ..styled_text]
}

pub fn reset(styled_text: StylingSequence) -> StylingSequence {
  [Reset, ..styled_text]
}

pub fn to_string(styled_text: StylingSequence) -> String {
  let parts =
    styled_text
    |> reset()
    |> reverse()
  parts
  |> fold(
    new(),
    fn(builder, part) {
      case part {
        Black(text) ->
          builder
          |> style_text(text, black_code, Some(default_code))
        BlackBg(text) ->
          builder
          |> style_text(text, black_bg_code, None)
        StartBlack ->
          builder
          |> append(code(black_code))
        StartBlackBg ->
          builder
          |> append(code(black_bg_code))
        StartRed ->
          builder
          |> append(code(red_code))
        StartRedBg ->
          builder
          |> append(code(red_bg_code))
        Red(text) ->
          builder
          |> style_text(text, red_code, Some(default_code))
        RedBg(text) ->
          builder
          |> style_text(text, red_bg_code, None)
        Yellow(text) ->
          builder
          |> style_text(text, yellow_code, Some(default_code))
        YellowBg(text) ->
          builder
          |> style_text(text, yellow_bg_code, None)
        StartYellow ->
          builder
          |> append(code(yellow_code))
        StartYellowBg ->
          builder
          |> append(code(yellow_bg_code))
        Magenta(text) ->
          builder
          |> style_text(text, magenta_code, Some(default_code))
        MagentaBg(text) ->
          builder
          |> style_text(text, magenta_bg_code, None)
        StartMagenta ->
          builder
          |> append(code(magenta_code))
        StartMagentaBg ->
          builder
          |> append(code(magenta_bg_code))
        Cyan(text) ->
          builder
          |> style_text(text, cyan_code, Some(default_code))
        CyanBg(text) ->
          builder
          |> style_text(text, cyan_bg_code, None)
        StartCyan ->
          builder
          |> append(code(cyan_code))
        StartCyanBg ->
          builder
          |> append(code(cyan_bg_code))
        White(text) ->
          builder
          |> style_text(text, white_code, Some(default_code))
        WhiteBg(text) ->
          builder
          |> style_text(text, white_bg_code, None)
        StartWhite ->
          builder
          |> append(code(white_code))
        StartWhiteBg ->
          builder
          |> append(code(white_bg_code))
        Blue(text) ->
          builder
          |> style_text(text, blue_code, Some(default_code))
        BlueBg(text) ->
          builder
          |> style_text(text, blue_bg_code, None)
        StartBlue ->
          builder
          |> append(code(blue_code))
        StartBlueBg ->
          builder
          |> append(code(blue_bg_code))
        Green(text) ->
          builder
          |> style_text(text, green_code, Some(default_code))
        GreenBg(text) ->
          builder
          |> style_text(text, green_bg_code, None)
        StartGreen ->
          builder
          |> append(code(green_code))
        StartGreenBg ->
          builder
          |> append(code(green_bg_code))
        StopColor ->
          builder
          |> append(code(default_code))
        StopBgColor ->
          builder
          |> append(code(default_bg_code))
        Default(text) ->
          builder
          |> style_text(text, default_code, None)
        DefaultBg(text) ->
          builder
          |> style_text(text, default_bg_code, None)
        Color256(text, color) ->
          builder
          |> append(code(color256_code(color)))
          |> append(text)
        ColorRGB(text, red, green, blue) ->
          builder
          |> append(code(color_rgb_code(rgb_code, red, green, blue)))
          |> append(text)
        ColorBgRGB(text, red, green, blue) ->
          builder
          |> append(code(color_rgb_code(rgb_bg_code, red, green, blue)))
          |> append(text)
        StartColorRGB(red, green, blue) ->
          builder
          |> append(code(color_rgb_code(rgb_code, red, green, blue)))
        StartColorBgRGB(red, green, blue) ->
          builder
          |> append(code(color_rgb_code(rgb_bg_code, red, green, blue)))
        Bold(text) ->
          builder
          |> style_text(text, start_bold_code, Some(end_bold_code))
        StartBold ->
          builder
          |> append(code(start_bold_code))
        EndBold ->
          builder
          |> append(code(end_bold_code))
        Dim(text) ->
          builder
          |> style_text(text, start_dim_code, Some(end_dim_code))
        StartDim ->
          builder
          |> append(code(start_dim_code))
        EndDim ->
          builder
          |> append(code(end_dim_code))
        Italic(text) ->
          builder
          |> style_text(text, start_italic_code, Some(end_italic_code))
        StartItalic ->
          builder
          |> append(code(start_italic_code))
        EndItalic ->
          builder
          |> append(code(end_italic_code))
        Underline(text) ->
          builder
          |> style_text(text, start_underline_code, Some(end_underline_code))
        StartUnderline ->
          builder
          |> append(code(start_underline_code))
        EndUnderline ->
          builder
          |> append(code(end_underline_code))
        Blinking(text) ->
          builder
          |> style_text(text, start_blinking_code, Some(end_blinking_code))
        StartBlinking ->
          builder
          |> append(code(start_blinking_code))
        EndBlinking ->
          builder
          |> append(code(end_blinking_code))
        Reverse(text) ->
          builder
          |> style_text(text, start_reverse_code, Some(end_reverse_code))
        StartReverse ->
          builder
          |> append(code(start_reverse_code))
        EndReverse ->
          builder
          |> append(code(end_reverse_code))
        Hidden(text) ->
          builder
          |> style_text(text, start_hidden_code, Some(end_hidden_code))
        StartHidden ->
          builder
          |> append(code(start_hidden_code))
        EndHidden ->
          builder
          |> append(code(end_hidden_code))
        Strikethrough(text) ->
          builder
          |> style_text(
            text,
            start_strikethrough_code,
            Some(end_strikethrough_code),
          )
        StartStrikethrough ->
          builder
          |> append(code(start_strikethrough_code))
        EndStrikethrough ->
          builder
          |> append(code(end_strikethrough_code))
        Reset ->
          builder
          |> append(code(reset_code))
        Text(text) ->
          builder
          |> append(text)
        PlaceHolder -> builder
      }
    },
  )
  |> string_builder.to_string()
}

pub fn save(
  this_styled_text: StylingSequence,
) -> fn(StylingSequence, String) -> StylingSequence {
  fn(styled_text: StylingSequence, text: String) {
    this_styled_text
    |> map(fn(part) {
      case part {
        PlaceHolder -> Text(text)
        other -> other
      }
    })
    |> list.append(styled_text)
  }
}

pub fn to_string_styler(
  this_styled_text: StylingSequence,
) -> fn(String) -> String {
  fn(text: String) {
    this_styled_text
    |> map(fn(part) {
      case part {
        PlaceHolder -> Text(text)
        other -> other
      }
    })
    |> to_string()
  }
}
