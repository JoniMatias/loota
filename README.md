#  Loota

This is a small software that generates a link to boxes.py for a box with given parameters, and then generates an .svg file of a wrapper for that box, so that it completely envelopes it. The script supports multiple types of boxes through different subcommands. Currently supported boxes are:

 - **Avoloota**: A simple open topped box. 
 - **Huullos**: A box with a lid, that is help with pressure and friction of a lip.
 
 
 ##Arguments
 
 The software accept following arguments:
 
### Required Arguments

The software requires the following arguments in this order <width> <height> <depth>

 - **width**: The width of the box, as seen from the front.  
 - **height**: The height of the box, from bottom to top.
 - **depth**: The depth of the box.
 
 
### Output options

 - **output-file-name**: The prefix given to each output file. Used to prevent overwriting previous files and to recognize different project from each other. 
 
