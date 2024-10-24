# Aseprite-PillowShading
Allows you to pillow shade a selection from the foreground colour to the background colour

## How to use it
Simply make a selection, select a foreground colour and a background coluor and run the script.

## How it works
The script takes the current selection and determines how many contractions of the selection it will take until the selection is empty. It then fills the selection, starting from the foreground colour and interlopating towards the background colour in steps of 1 contraction.

## Why pillow shading?
Whilst pillow shading isn't considered a great look for pixel art, it can be useful for a lot of things. I use it most to make basic heightmaps from a 2D image. Make the foreground black (or the lowest lightness you want your heightmap to have), the background white (or the highest lightness you want the heightmap to have) and make a selection of the sprite. Then run the script and you'll get a nice gradient for the heightmap getting higher as it approaches the center of the selection.
