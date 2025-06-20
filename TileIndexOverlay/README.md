
![minimedia_banner_v2](https://github.com/user-attachments/assets/ed833be9-1260-4799-86e2-856174dc00c5)

 <br/>
 
## Tile Index Overlay Extension | Summary

The Tile Index Overlay extension creates a new layer(s) on your currently open sprite. Based on user defied tile size (width and height) it will place a 4 digit index number in the upper left corner of each tile. This index number "map" is meant to assist in quickly finding the position of sprites/tiles without having to check their coordinates individually.

Use Cases:
* locating existing textures in large spritesheets/tilesheets (SDV modding community will be familiar with the challange of springobjects!)
* noting tile index numbers needed for object placement code
* debugging objects displaying incorrect textures - loading spritesheets/tilesheets with the index map visible will quickly help identify which tile numbers may not be displaying intended textures
   <br/> <br/>
  
![index-example](https://github.com/user-attachments/assets/50404bbe-de2a-48a2-9028-d92626196662)


<br/>

## Tile Index Overlay Extension | Important Notes

> [!WARNING]
> Sprite / Canvas width and height MUST be divisble by your tile dimensions!

You need to make sure that your canvas/sprite size can be divided by your tile size, i.e. if your tile size is 16x16 your canvas/sprite dimensions have to be multiples of 16 (160x256, 512x1024 and so on) - the extension will check for this and alert if your canvas size does not match your provided tile size.

The extension will also not activate (the New Tile Index Overlay Layer button will be greyed out) unless there is at least one currently active sprite.

<br/>

## Tile Index Overlay Extension | How To

There are two ways to use the extension:

* Via Menu : Layer >> New... > New Tile Index Overlay Layer
  
* Via Keyboard Shortcut = Defualt: SPACE + i (you can change it to your preferred shortcut by going to Menu : Edit >> Keyboard Shortcut and search for "Tile Index")

<br/>

## Available Options
When you activate the extension you will see a popup with below options:

* Tile Width (pixels) : positive number (default 16)
* Tile Height (pixels) : positive number (default 16)
* Index Color : color picker (default : white | this is the color of the index number)
* Include a Contrast Background layer : tickbox (if ticked: will create an additional layer below index with coloured background to make index numbers more readable)
* Contrast Color : color picker (default : semi-transparent black | this is the color of the background contrast rectangle)

Click OK to generate the layer(s) <br/>
![tileindexoverlay_options_v4](https://github.com/user-attachments/assets/5d72e5b3-14f7-409e-bfc9-a8acb614344e)

<br/> <br/>
## Demo
You can watch a quick demo of the extension in action on YouTube

[![media_banner_v_4](https://github.com/user-attachments/assets/da15b316-2f4e-416a-aebd-87330527e67e "Aseprite Extension demo thumbnail link image")](https://youtu.be/SQJzuqcKaF4?si=KVwtO6VCr8Rl2McC)

