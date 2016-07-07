# thunderstorm

Thunderstorm is a rudimentary level editor that maps a text file table into a json output file.

## Input format
Thunderstorm accepts a level map in the following format (provided as [`example_level.txt`](example_level.txt)):
```
| 1   | 2   | 3   | 4      |
| 5r1 | 6r6 |     |        |
| 7x  | 8y  | 9xy | 10r2xy |
```
Each element of the table will be given x and y coordinates, where (0,0) is the top left element of the table.

The number within each element should correspond to the tile on the sprite tilesheet.

If you wish to rotate the tile, include the letter `r` and the number of 90° angles you wish to step through in a clockwise direction.
For example `5r1` will rotate tile 5 by 90° once. `6r6` will rotate tile 6 by 90° only six times.

If you wish to flip a tile in x and/or in y, include `x` and/or `y` after the tile number and any rotation (if desired).

If you leave an element in the table blank, no corresponding line will be written to the output json file, and the script will simply move on to the next non-empty coordinate.

The output json for the above table is as follows:
```
{"x":0,"y":0,"tile":1,"rot":0,"flipX":false,"flipY":false},
{"x":0,"y":1,"tile":2,"rot":0,"flipX":false,"flipY":false},
{"x":0,"y":2,"tile":3,"rot":0,"flipX":false,"flipY":false},
{"x":0,"y":3,"tile":4,"rot":0,"flipX":false,"flipY":false},
{"x":1,"y":0,"tile":5,"rot":1,"flipX":false,"flipY":false},
{"x":1,"y":1,"tile":6,"rot":2,"flipX":false,"flipY":false},
{"x":2,"y":0,"tile":7,"rot":0,"flipX":true,"flipY":false},
{"x":2,"y":1,"tile":8,"rot":0,"flipX":false,"flipY":true},
{"x":2,"y":2,"tile":9,"rot":0,"flipX":true,"flipY":true},
{"x":2,"y":3,"tile":10,"rot":2,"flipX":true,"flipY":true},
```

##Running the Script

To run the script, you can either provide command line arguments:
```
ruby thunderstorm.rb example_level.txt output_file.json
```
or run the script without arguments, after which you will be prompted for your file names:
```
ruby thunderstorm.rb
```
