# Aseprite-PillowShading
Allows you to pillow shade a selection from the foreground colour to the background colour.

## How to use it
Simply make a selection, select a foreground colour and a background coluor and run the script.

## How it works
The script takes the current selection and determines how many contractions of the selection it will take until the selection is empty. It then fills the selection, starting from the foreground colour and interlopating towards the background colour in steps of 1 contraction.

## Why pillow shading?
Whilst pillow shading isn't considered a great look for pixel art, it can be useful for a lot of things. I use it most to make basic heightmaps from a 2D image. Make the foreground black (or the lowest lightness you want your heightmap to have), the background white (or the highest lightness you want the heightmap to have) and make a selection of the sprite. Then run the script and you'll get a nice gradient for the heightmap getting higher as it approaches the center of the selection. Here's an example:

Base Image
![Flat ship image](https://refreshertowelgames.wordpress.com/wp-content/uploads/2024/10/ship_diffuse.png)

Heightmap generated from the script (with a black background layer)
![Heightmap ship image](https://refreshertowelgames.wordpress.com/wp-content/uploads/2024/10/ship_height3.png)

After using the base image and the heightmap image to generate a normal map
![Normal mapped image](https://refreshertowelgames.wordpress.com/wp-content/uploads/2024/10/ship_normalised.png)

Obviously, it doesn't do _all_ the work for you, you'll still have to do some manual editing to flatten out parts and adjust things as needed, but it speeds up the process considerably.
