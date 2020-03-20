require "./screen/version"
require "./screen/libs/libc"

module Term
  module Screen
    extend self

    # Default terminal size
    DEFAULT_SIZE = { 27, 80 }

    class_property env : Hash(String, String) = ENV.to_h
    class_property output : IO = STDERR

    # Get terminal dimensions (rows, columns)
    def size
      # check_size(size_from_win_api) || # TODO
      result = size_from_ioctl ||
        # check_size(size_from_readline) || # TODO maybe
        size_from_tput ||
        size_from_stty ||
        size_from_env ||
        size_from_ansicon ||
        size_from_default

      result || {0, 0}
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
    # TODO
    def size_from_win_api
      size_from_default
    end

    TIOCGWINSZ = 0x5413 # linux
    TIOCGWINSZ_PPC = 0x40087468 # macos, freedbsd, netbsd, openbsd
    TIOCGWINSZ_SOL = 0x5468 # solaris

    # Read terminal size from Unix ioctl
    def size_from_ioctl
      buffer = uninitialized LibC::Winsize
      {% if flag?(:linux) %}
        LibC.ioctl(1, TIOCGWINSZ, pointerof(buffer))
      {% elsif flag?(:solaris) %}
        LibC.ioctl(1, TIOCGWINSZ, pointerof(buffer))
      {% else %}
        LibC.ioctl(1, TIOCGWINSZ, pointerof(buffer))
        {% end %}

      if buffer
        buffer.empty? ? nil : {buffer.ws_row.to_i, buffer.ws_col.to_i}
      else
        nil
      end
    end

    # Detect screen size using Readline
    # TODO
    def size_from_readline
      size_from_default
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
  end
end
