{% skip_file unless flag?(:win32) || flag?(:windows) %}

@[Link("kernel32")]
lib LibC
  STDOUT_HANDLE = 0xFFFF_FFF5_u32

  struct Coord
    x : Int16
    y : Int16
  end

  struct SmallRect
    left : Int16
    top : Int16
    right : Int16
    bottom : Int16
  end

  struct ConsoleScreenBufferInfo
    dwSize : Coord
    dwCursorPosition : Coord
    wAttributes : UInt16
    srWindow : SmallRect
    dwMaximumWindowSize : Coord
  end

  alias Handle = Void*
  alias WinBool = Int32

  fun GetConsoleScreenBufferInfo(handle : Handle, info : ConsoleScreenBufferInfo*) : WinBool
  fun GetStdHandle(handle : UInt32) : Handle
end
