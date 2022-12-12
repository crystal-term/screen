lib LibC
  STDOUT_HANDLE = 0xFFFFFFF5

  struct Point
    x : UInt16
    y : UInt16
  end

  struct SmallRect
    left : UInt16
    top : UInt16
    right : UInt16
    bottom : UInt16
  end

  struct ScreenBufferInfo
    dwSize : Point
    dwCursorPosition : Point
    wAttributes : UInt16
    srWindow : SmallRect
    dwMaximumWindowSize : Point
  end

  alias Handle = Void*
  alias ScreenBufferInfoPtr = ScreenBufferInfo*

  fun GetConsoleScreenBufferInfo(handle : Handle, info : ScreenBufferInfoPtr) : Bool
  fun GetStdHandle(handle : UInt32) : Handle
end
