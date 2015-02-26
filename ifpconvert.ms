/*
 *	IFP Converter - Converts all the animations from a IFP file into another file format
 *	
 *	This script can convert all animations from an IFP to any format (split) that 3DS Max supports.
 *	Requires Kam's Max Scripts to perform I/O on GTA files (http://www.gtagarage.com/mods/show.php?id=9172)
 *	
 *		Usage:
 *			1. Go to the utilities panel and press Kam's  GTA Scripts "IFP IO" button.
 *			2. Click Import DFF on the animation panel and select a rigged dff file.
 *			3. Click Load IFP and select the ifp file you wish to convert.
 *			4. Select the entire model / skin / bones.
 *			5. At the topbar of 3DS Max select "MAXScript -> Run Script" and select this script.
 *			6. Choose a filename (extension is important to detect type to convert into) to output the animations to.
 *			7. ???
 *			8. Profit.
 *
 */

fn IFPConvert outfilepath shouldmoveroot = (

	/*
		Variables used here related to Kams IO
			ifpname		The path to the currently open IFP file
			animinfo		The information about the currently open IFP file
				animinfo[1]	List of the name of the animations in the ifp
				animinfo[2]	List of anim offsets of the animations in the ifp
				animinfo[3]    IFP magic number (ifp version)
	*/
	
	local moveroot = undefined
	
	if $selection.count == 0 then (
		MessageBox "Ped skin / bones must be selected"
		return false
	) else if animinfo == undefined or animinfo.count == 0 then (
		MessageBox "IFP data to export is empty or not open"
		return false
	)
	
	-- Output information
	local outdir     = GetFileNamePath(outfilepath)
	local outname = GetFileNameFile(outfilepath)
	local outtype   = GetfileNameType(outfilepath)
	
	-- Check if should move root
	if shouldmoveroot == true and $root != undefined do (
		moveroot = [0,0,-$selection.min.z]	-- move based on the bounding box, so the base/foot ends up at [0,0,0]
	)
	
	-- Save original skin pose
	for i = 1 to $selection.count do (
		setUserProp $selection[i] "OrgPos" $selection[i].pos
		setUserProp $selection[i] "OrgRot" [$selection[i].rotation.x,$selection[i].rotation.y,$selection[i].rotation.z]
		setUserProp $selection[i] "OrgRotW" $selection[i].rotation.w
		setUserProp $selection[i] "Orgscl" $selection[i].scale
	)
	
	-- Export the original skin without animations
	if moveroot != undefined then (move $root moveroot)
	ExportFile (outdir + outname + outtype) #noPrompt selectedOnly:true
	
	-- Then export the ifp animations with the skin
	fifp = fopen ifpname "rb"
	if fifp != undefined then (
		
		for i = 1 to animinfo[1].count do (
			
			-- Apply animation to skin
			slidertime = 0
			resetPost $selection slidertime
			fseek fifp animinfo[2][i] #seek_set
			ApplyAnim fifp ($selection as array) false slidertime animinfo[3]
			
			-- Export ifp animation
			if moveroot != undefined then (move $root moveroot)
			ExportFile (outdir + outname + "@" + animinfo[1][i] + outtype)  #noPrompt selectedOnly:true
			
			-- Reset to original skin pose
			slidertime = 0
			for i = 1 to $selection.count do (
				deletekeys $selection[i].pos.controller
				deletekeys $selection[i].rotation.controller
				deletekeys $selection[i].scale.controller
				
				tp  = readvalue ((getUserProp $selection[i] "OrgRot") as stringstream)
				tpW = getUserProp $selection[i] "OrgRotW"
				$selection[i].rotation = (quat tp.x tp.y tp.z tpW)
				$selection[i].scale	= readvalue ((getUserProp $selection[i] "Orgscl") as stringstream)
				$selection[i].pos	= readvalue ((getUserProp $selection[i] "OrgPos") as stringstream)
			)
		)
		
		fclose fifp
		gc()
		return true
		
	) else (
		MessageBox "Failed to open ifp file for reading"
		return false
	)
)


filename = GetSaveFileName caption:"Output Converted File"
if filename != undefined then (
	IFPConvert filename true
)
filename = undefined
