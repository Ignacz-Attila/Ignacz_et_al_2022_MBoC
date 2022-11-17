//In this macro we segment the skeletons of spines and the branch

waitForUser("Select folder", "Select folder that contains the _Stage1.tif images");
directory = getDirectory("Choose a Directory");
filelist = getFileList(directory);
for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], "_Stage1.tif")) { 
        open(directory + File.separator + filelist[i]);
        
OriginalTitle = getTitle();
CurrentFile = replace(OriginalTitle,"Stage1.tif","Skeleton.tif");

rename("Stage1");
getPixelSize(unit, pixelWidth, pixelHeight);

run("Run Autocontext Prediction", "projectfilename=[D:\\RIN1 PKD images\\PKD_spines\\PKD_spines_Skeleton.ilp] inputimage=Stage1 autocontextpredictiontype=Segmentation");

rename("Skeleton");
run("Properties...", "channels=1 slices=1 frames=1 pixel_width="+ pixelWidth +" pixel_height="+ pixelHeight + " voxel_depth=1 frame=[0 sec]");

setMinAndMax(0, 5);

save(directory + "\\" + CurrentFile);
close("*");
    }
}
waitForUser("Stage2 done", "Skeleton automatic phase done!");