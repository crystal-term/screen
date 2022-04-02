require "./screen/version"
require "./screen/libs/libreadline"
require "ioctl"

module Term
  module Screen
    extend self

    # Default terminal size
    DEFAULT_SIZE = { 27, 80 }

    class_property env : Hash(String, String) = ENV.to_h
    class_property output : IO = STDERR

    # Get terminal dimensions (rows, columns)
    def size
      size_from_ioctl(STDIN) ||
        size_from_ioctl(STDOUT) ||
        size_from_ioctl(STDERR) ||
        # check_size(size_from_win_api) || # TODO
        check_size(size_from_tput) ||
        check_size(size_from_readline) ||
        check_size(size_from_stty) ||
        check_size(size_from_env) ||
        check_size(size_from_ansicon) ||
        check_size(size_from_default) ||
        size_from_default
    end

    def width
      size[1]
    end

    def columns
      width
    end

    def cols
      width
    end

    def height
      size[0]
    end

    def rows
      height
    end

    def lines
      height
    end

    # Default terminal size
    def size_from_default
      DEFAULT_SIZE
    end

    STDOUT_HANDLE = 0xFFFFFFF5

    # Determine terminal size with a Windows native API
    def size_from_win_api
      size_from_default
    end

    TIOCGWINSZ = 0x5413 # linux
    TIOCGWINSZ_PPC = 0x40087468 # macos, freedbsd, netbsd, openbsd
    TIOCGWINSZ_SOL = 0x5468 # solaris

    # Read terminal size from Unix ioctl
    def size_from_ioctl(file)
      buffer = uninitialized LibC::Winsize
      IOCTL.ioctl(file.fd, IOCTL::TIOCGWINSZ, pointerof(buffer))
      {buffer.ws_row.to_i, buffer.ws_col.to_i}
    rescue
      nil
    end

    # Detect screen size using Readline
    def size_from_readline
      init_readline
      LibReadline.get_screen_size(out rows, out cols)
      {rows, cols}
    end

    # Detect terminal size from tput utility
    def size_from_tput
      return unless output.tty?

      lines = `tput lines`.to_i?
      cols = `tput cols`.to_i?

      if lines && cols
        {lines, cols}
      else
        nil
      end
    end

    # Detect terminal size from stty utility
    def size_from_stty
      return unless output.tty?

      parts = `stty size`.split(/\s+/)
      return unless parts.size > 1
      lines, cols = parts.map(&.to_i?)
      return unless lines && cols

      if lines && cols
        {lines, cols}
      else
        nil
      end
    end

    # Detect terminal size from environment
    #
    # After executing Crystal code if the user changes terminal
    # dimensions during code runtime, the code won't be notified,
    # and hence won't see the new dimensions reflected in its copy
    # of LINES and COLUMNS environment variables.
    def size_from_env
      return unless env["COLUMNS"]?.to_s =~ /^\d+$/
      rows = env["LINES"]? || env["ROWS"]?
      cols = env["COLUMNS"]?
      if (rows && rows.to_i?) && (cols && cols.to_i?)
        size = {rows.to_i, cols.to_i}
      else
        nil
      end
    end

    # Detect terminal size from Windows ANSICON
    def size_from_ansicon
      return unless env["ANSICON"]?.to_s =~ /\((.*)x(.*)\)/

      rows, cols = [$2, $1].map(&.to_i)
      {rows, cols}
    end

    private def check_size(size)
      if (size) && size[0] != 0 && size[1] != 0
        return size
      end
    end

    @@rl_initialized = false
    private def init_readline
      if !@@rl_initialized
        LibReadline.rl_initialize
      end
    end
  end
end
