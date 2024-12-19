#  Loota

This is a small software that generates a link to boxes.py for a box with given parameters, and then generates an .svg file of a wrapper for that box, so that it completely envelopes it. The script supports multiple types of boxes through different subcommands. Currently supported boxes are:

 - **Avoloota**: A simple open topped box. 
 - **Huullos**: A box with a lid, that is help with pressure and friction of a lip.
 
 
 #General Arguments
 
 The software accept following arguments:
 
## Required Arguments

The software requires the following arguments in this order <width> <height> <depth>

 - **width**: The width of the box, as seen from the front.  
 - **height**: The height of the box, from bottom to top.
 - **depth**: The depth of the box.
 
 
## Output options

 - **--output-file-name** or **-o**: The prefix given to each output file. Used to prevent overwriting previous files and to recognize different project from each other. 
 
 - **--no-download**: The program will not download the files from boxes.py, but instead will just provide links to the terminal that you can use to download the files.
 
 
 ## Work options
 
 - **--kerf**: In millimeters, how much should the burn correction be for both the box and the fabric. The box will use the boxes.py value for burn correction, the cloth will (TBI) just expand the lines with given amount in all directions.
 
 - **--material-thickness**: How thick is the material the box will be cut from. (default: 3mm)
 
 - **--cloth-thickness**: How thick is the cloth used to wrap the box (default 0.5mm)
 
 - **--internal-dimensions**: This flag reads the given <width> <height> and <depth> arguments as internal dimensions of the box. Without this flag, the dimensions are read as outer dimensions.
  
 - **--square-corners**: This flags sets the cloth cutting pattern is such a way, that the corners, where the cloth wrap from the outer wall to the inner wall of the box, do overlap a bit. This makes it easier to place the fabric to the box, as the placement is not exact to a micrometer. This does mean, that you have to use a knife to cut the corners yourself, if you want them to loop pretty. 
   
 
 
 # Avoloota subcommand

This subcommand creates a simple open topped box.

## Options



# Huullos subcommand

This subcommand creates a box with a lid that is kept in place with friction from the lip on the bottom portion.

## Options

These options are specific to the huullos subcommand.

 - **--wall-wrap-cloth**: This flag will make sure that all cloth wraps use the wall wrapping pattern, that causes less material waste. The downsides of this option are:
   - The footprint of this pattern is wider than the normal wrap
   - Wall wrap requires an additional piece of cloth for the top part of the box.
 
 - **--lid-height**: How high the lip for the lid is, measured from the top of the lid to the cutting point.
  
 - **--lip-height**: How high the lip that protrudes from the bottom portion of the box.

