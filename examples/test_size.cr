require "../src/term-screen"

puts "=== Terminal Size Detection Test ==="
puts "Using Term::Screen library"
puts

# Get size using the main method
size = Term::Screen.size
puts "Terminal size: #{size[1]}x#{size[0]} (width x height)"
puts "Width: #{Term::Screen.width}"
puts "Height: #{Term::Screen.height}"
puts

# Test individual detection methods
puts "=== Individual Detection Methods ==="

# Test ioctl
{% unless flag?(:windows) %}
  [STDIN, STDOUT, STDERR].each do |io|
    if size = Term::Screen.size_from_ioctl(io)
      puts "ioctl (#{io.class}): #{size[1]}x#{size[0]}"
    else
      puts "ioctl (#{io.class}): failed"
    end
  end
{% end %}

# Test tput
if size = Term::Screen.size_from_tput
  puts "tput: #{size[1]}x#{size[0]}"
else
  puts "tput: failed"
end

# Test stty
if size = Term::Screen.size_from_stty
  puts "stty: #{size[1]}x#{size[0]}"
else
  puts "stty: failed"
end

# Test environment
if size = Term::Screen.size_from_env
  puts "env: #{size[1]}x#{size[0]}"
else
  puts "env: not set"
end

# Test default
size = Term::Screen.size_from_default
puts "default: #{size[1]}x#{size[0]}"