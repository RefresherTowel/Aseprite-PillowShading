# Aseprite-PillowShading
Allows you to pillow shade a selection from the foreground colour to the background colour.

## How to use it
Simply make a selection, select a foreground colour and a background colour and run the script. The dialog options are:
* Max Iterations
  * Sets a limit to the number of iterations will be filled. For example, a maximum of 5 iterations means that the pillow shading will have 5 shades between your foreground and background colour, each shade will be separated by the iteration size you pick. 0 means that it will either expand or shrink to the maximum amount of iterations that are possible with the size of the selection.
* Iteration size
  * Determines how far apart in pixels each interpolated shade will be. A value of 3 would mean that the selection expands or contracts by 3 pixels before the next intermediary shade is applied.
* Selection settings
  * Circle
    * This will perform the selection contraction or expansion using a circular brush.
  * Square
    * This will perform the selection contraction or expansion using a square brush.
  * Shrink
    * This will perform the pillow shading by shrinking the current selection. The selected area will be set to the foreground colour, and then the selection will be progressively contracted, filling in with intermediary shades towards the background colour.
  * Expand
    * This will perform the pillow shading by expanding the current selection. The selected area will be filled with the background colour, and then the selection will be progressively expanded, with each expanded area being filled with intermediary shades towards the foreground colour.
* Interpolate in
  * The four checkmarks (H, S, V and A) correspond to the Hue, Value, Saturation and Alpha of the interpolation between the foreground and background colours. Turning them off will disable interpolation for that field (meaning if you turn off Hue, for instance, and then pillow shade between red and blue colours, the interpolated colour will maintain the red hue of the foreground colour, while the saturation, value and alpha will interpolate between the foreground and background colours).

## How it works
The script takes the current selection and determines how many contractions of the selection it will take until the selection is empty. It then fills the selection, starting from the foreground colour and interlopating towards the background colour in over however many iterations you selected.

## Why pillow shading?
Whilst pillow shading isn't considered a great look for pixel art, it can be useful for a lot of things. I use it most to make basic heightmaps from a 2D image. Make the foreground black (or the lowest lightness you want your heightmap to have), the background white (or the highest lightness you want the heightmap to have) and make a selection of the sprite. Then run the script and you'll get a nice gradient for the heightmap getting higher as it approaches the center of the selection. Here's an example:

Base Image

![Flat ship image](https://refreshertowelgames.wordpress.com/wp-content/uploads/2024/10/ship_diffuse-1.png)

Heightmap generated from the script (different sections separated into different layers, with a black background layer)

![Heightmap ship image](https://refreshertowelgames.wordpress.com/wp-content/uploads/2024/10/ship_pillow_shaded.png)

After using the base image and the heightmap image to generate a normal map

![Normal mapped image](https://refreshertowelgames.wordpress.com/wp-content/uploads/2024/10/ship_normalised-1.png)

Obviously, it doesn't do _all_ the work for you, you'll still have to do some manual editing to flatten out parts that don't fit with the pillow shading coming in from the edge of the sprite, but it speeds up the process considerably.
