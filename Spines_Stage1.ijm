
//In the first part we start with Stage 1 segmentation. Be careful about the location of the ilp file!

waitForUser("Select folder", "Select folder that contains the .czi images");
directory = getDirectory("Choose a Directory");


filelist = getFileList(directory);
for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], ".czi")) { 

run("Bio-Formats Importer", "open=["+directory + File.separator + filelist[i]+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

OriginalTitle = getTitle();
CurrentFile = replace(OriginalTitle,".czi","_Stage1.tif");
rename("StartImage");
run("Duplicate...", "duplicate channels=3");
rename("Original");
close("StartImage");


run("Run Autocontext Prediction", "projectfilename=[D:\\RIN1 PKD images\\PKD_spines\\PKD_spines_stage1.ilp] inputimage=Original autocontextpredictiontype=Segmentation");
rename("Stage1");
Stack.setXUnit("micron");

selectImage("Original");
getPixelSize(unit, pixelWidth, pixelHeight);
selectImage("Stage1");

run("Properties...", "channels=1 slices=1 frames=1 pixel_width="+ pixelWidth +" pixel_height="+ pixelHeight + " voxel_depth=1 frame=[0 sec]");
setMinAndMax(0, 4);

save(directory + "\\" + CurrentFile);
close("*");

    }
}

waitForUser("Stage done", "Stage 1 is done. \nNext step is Stage1-correction");