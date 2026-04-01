require "option_parser"
require "stumpy_png"

width = 0
height = 0
prime_color = "white"

OptionParser.parse do |parser|
  parser.banner = "Usage: ulam_spiral [options]"

  parser.on "-w WIDTH", "--width=WIDTH", "Image width in pixels" do |w|
    width = w.to_i
  end

  parser.on "-h HEIGHT", "--height=HEIGHT", "Image height in pixels" do |h|
    height = h.to_i
  end

  parser.on "-c COLOR", "--color=COLOR", "Prime color as hex (default: white)" do |c|
    prime_color = c
  end

  parser.on "--help", "Show this help" do
    puts parser
    exit
  end
end

if width == 0 || height == 0
  puts "Please provide both width and height."
  exit(1)
end

def prime?(n)
  return false if n <= 1
  (2..Math.sqrt(n).to_i).each do |i|
    return false if n % i == 0
  end
  true
end

canvas = StumpyPNG::Canvas.new(width, height)
center_color = StumpyPNG::RGBA.from_hex("#FFFF00")
background_color = StumpyPNG::RGBA.from_hex("#000000")
prime_color_rgba = StumpyPNG::RGBA.from_hex(prime_color)

canvas.pixels.fill(background_color)
canvas[width // 2, height // 2] = center_color

x, y = width // 2, height // 2
dx, dy = 1, 0
step = 0
turn = 0
max_steps = width * height

(1..max_steps).each do |i|
  canvas[x, y] = prime_color_rgba if prime?(i)

  x += dx
  y += dy
  step += 1

  if step == turn // 2 + 1
    step = 0
    turn += 1
    dx, dy = dy, -dx
  end

  break if x < 0 || x >= width || y < 0 || y >= height
end

filename = "ulam_spiral_#{width}x#{height}.png"
StumpyPNG.write(canvas, filename)
puts "Saved #{filename}"
