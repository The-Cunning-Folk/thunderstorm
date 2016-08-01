require 'json'
require 'neatjson'

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

def get_file_name(request, arg)
  if !ARGV[arg]
    puts request
    file_name = gets.chomp
  else
    filename = ARGV[arg]
  end
end

def get_ground_or_ceil(request)
  if !ARGV[2]
    puts request
    ground_or_ceil = gets.chomp
  else
    ground_or_ceil = ARGV[2]
  end
  if ground_or_ceil.chomp != "ground" && ground_or_ceil.chomp != "ceiling"
    puts "Error! You supplied: '" + ground_or_ceil + "'"
    puts "Please supply 'ground' or 'ceiling'"
    return nil
  end
  ground_or_ceil
end

def get_layer(request)
  if !ARGV[3]
    puts request
    layer = gets.chomp.to_i
  else
    layer = ARGV[3].to_i
  end
  if !Integer(layer)  
    puts "Error! Please supply a layer number"
    return nil
  end
  layer
end

def build_tiles
  input_file = get_file_name('input txt file: ', 0)
  y = -8
  tile_count = 0
  tiles = []
  level_file = File.new(input_file, "r")
  level_file.readlines.each do |line|
    x = -15
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
  tiles
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

def write_to_level(tiles)
  level_file = get_file_name('output json file: ',1)
  ground_or_ceil = get_ground_or_ceil('ground or ceiling: ').to_s
  if !ground_or_ceil then return end
  layer = get_layer('layer: ')
  if !layer then return end
  file = File.read(level_file)
  data_hash = JSON.parse(file)
  data_hash[ground_or_ceil]['layers'][layer]['map'] = tiles
  overwrite_file = File.open(level_file,'w')
  overwrite_file.write(JSON.neat_generate(data_hash))
  overwrite_file.close
end

def convert_pyxel()
  pyxel_file  = get_file_name('pyxel json file: ',0)


  file = File.read(pyxel_file)
  new_data = JSON.parse(file)

  level_file = get_file_name('output json file: ',1)
  ground_or_ceil = get_ground_or_ceil('ground or ceiling: ').to_s
  if !ground_or_ceil then return end
  layer = get_layer('layer: ')
  if !layer then return end

  master_file = File.read(level_file)
  master_hash = JSON.parse(master_file)


  new_data['layers'].each do |layer|
    if layer == nil
      new_data['layers'] -= [layer]
    end
  end

  layer_count = 0
  new_data['layers'].each do |layer|
    if layer == nil
      new_data['layers'] -= [layer]
    end
    new_data['layers'][layer_count]['tiles'].each do |tile|
      if tile["tile"] == -1
        new_data['layers'][layer_count]['tiles'] -= [tile]
      end
    end
    layer_count +=1
  end

  master_hash[ground_or_ceil]['layers'] = new_data['layers']  


  overwrite_file = File.open(level_file,'w')
  overwrite_file.write(JSON.neat_generate(master_hash))
  overwrite_file.close
end


#tiles = build_tiles
#write_to_level(tiles)

convert_pyxel()