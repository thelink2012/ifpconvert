IFP Converter
=============================

This Maxscript for 3DS Max converts an [IFP](http://www.gtamodding.com/wiki/IFP) file _(GTA III era animation container)_ into a serie of other files each containing one animation.

Since this is an simple script that automates some human hard work, it relies on [Kam's Max Scripts](http://www.gtagarage.com/mods/show.php?id=9172) to do the GTA related I/O.

Supports converting to any file format that 3DS Max support for animations such as `.fbx`.

Usage
------------------

1. Install [Kam's Max Scripts](http://www.gtagarage.com/mods/show.php?id=9172) plugin for 3DS Max _(see it's own install instructions in `Must_Read.txt`)_.
2. Go to the 3DS Max utilities panel and press the _IFP IO_ button added by _Kam's Max Scripts_.
3. Click _Load IFP_ and select the `.ifp` file you wish to convert.
4. Click _Import DFF_ on the animation panel and select a rigged `.dff` file.
5. Select the entire model/skin/bones.
6. At the topbar of 3DS Max select _MAXScript -> Run Script_ and select `ifpconvert.ms`.
7. Choose a base filename to output the animations to _(the filename extension is important to detect format to convert into)_ .
8. ???
9. Profit.

Notes
------------------

+ `player.dff` doesn't seem to work as a base dff as it has no skinned mesh in it.
+ Due to gta peds having it's center position at _[0,0,0]_ rather than it's foot position, the script automatically makes the ped foot position be at _[0,0,0]_  since most modern application requires a foot-based-root for animations.



