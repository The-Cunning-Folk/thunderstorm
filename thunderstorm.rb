require 'json'

def find_rot(element)
  splitter = element.split('r')
  if splitter.size > 1
    rot = splitter.last.to_i % 4
  else
    rot = 0
  end
end

def find_flip(element, axis)
  splitter = element.split(axis)
  if splitter.size > 1
    flip = true
  else
    flip = false
  end
end

def get_argument(request, arg)
  if !ARGV[arg]
    puts request
    file_name = gets.chomp
  else
    filename = ARGV[arg]
  end
end

def build_tiles
  input_file = get_argument('input txt file: ', 0)
  y = 0
  tile_count = 0
  tiles = []
  level_file = File.new(input_file, "r")
  level_file.readlines.each do |line|
    x = 0
    x -= 1
    rot = 0
    flipX = false
    flipY = false
    line.split('|').each do |coord|      
      if coord =~ /[[:digit:]]/
        rot = find_rot(coord)
        flipX = find_flip(coord, 'x')
        flipY = find_flip(coord, 'y')
        tiles.push(:x => x, :y => y, :tile => coord.to_i, :rot => rot, :flipX => flipX)
        if flipY
          tiles[tile_count][:flipX] = !flipX
          tiles[tile_count][:rot] = rot + 2
        end
        tile_count += 1
      end
      x += 1
    end
    y += 1
  end
  level_file.close
  tile_stripper(tiles)
end

def tile_stripper(tiles)
  tiles.each do |tile|
    if tile[:rot] == 0
      tile.delete(:rot)
    end
    if !tile[:flipX]
      tile.delete(:flipX)
    end
  end
end

def json_writer(tiles)
  output_file = get_argument('output json file: ',1)
  json_file = File.open(output_file,"w")
  tiles.each do |tile|
    json_file.puts(tile.to_json + ',')
  end
  json_file.close
end

tiles = build_tiles
json_writer(tiles)
