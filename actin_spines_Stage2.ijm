
// This is the second part of the spine segmentation algorythm
//Segmentation of intra-spine segments: base, neck, head

waitForUser("Select folder", "Select folder that contains the _Stage1.tif images");
directory = getDirectory("Choose a Directory");

filelist = getFileList(directory);
for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], "_Stage1.tif")) { 
        open(directory + File.separator + filelist[i]);
        
OriginalTitle = getTitle();
CurrentFile = replace(OriginalTitle,"Stage1.tif","Stage2.tif");

rename("Stage1");
getPixelSize(unit, pixelWidth, pixelHeight);

run("Run Autocontext Prediction", "projectfilename=[D:\\actin labeling comparison\\actin-Ilastik models\\actin_spines_stage2.ilp] inputimage=Stage1 autocontextpredictiontype=Segmentation");

rename("Stage2");

run("Properties...", "channels=1 slices=1 frames=1 pixel_width="+ pixelWidth +" pixel_height="+ pixelHeight + " voxel_depth=1 frame=[0 sec]");

setMinAndMax(0, 5);

save(directory + "\\" + CurrentFile);
close("*");
    }
}
waitForUser("Stage2 done", "Stage2 automatic phase done!");