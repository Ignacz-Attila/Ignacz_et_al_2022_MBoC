IlastikFile = File.openDialog("Select Ilastik model");
directory = getDirectory("Folder with the images");
filelist = getFileList(directory);


for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], ".tif")) { 
        open(directory + File.separator + filelist[i]);
    Currentfile = getTitle();
	Savedfile = replace(Currentfile, ".tif", "_segmented.tif");

	run("Duplicate...", "title=mCh duplicate channels=2");

	selectImage("mCh");
	getDimensions(width, height, channels, slices, frames);
	getPixelSize(unit, pixelWidth, pixelHeight);
	FrameInterval = Stack.getFrameInterval();
	setOption("ScaleConversions", true);
	run("8-bit");
	
	run("Run Autocontext Prediction", "projectfilename=["+IlastikFile+"] inputimage=mCh autocontextpredictiontype=Segmentation");
    rename("VirtualPrediction");
	run("Duplicate...", "title=Prediction duplicate");
    close("VirtualPrediction");
    selectImage("Prediction");
    
    
	setAutoThreshold("Default dark");
	//run("Threshold...");
	setThreshold(1, 2);
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=Default background=Dark black");
	
	
	run("Properties...", "channels="+channels+" slices="+slices+" frames="+frames+" pixel_width="+ pixelWidth +" pixel_height="+ pixelHeight + " voxel_depth=1 frame="+FrameInterval+"");
	Stack.setXUnit(unit);
	
	save(directory + File.separator + Savedfile);
	close("*");
    }
}