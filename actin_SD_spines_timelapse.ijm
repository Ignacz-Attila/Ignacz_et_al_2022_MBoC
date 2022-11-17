waitForUser("Select folder", "Select folder that contains the .czi images");
directory = getDirectory("Choose a Directory");


filelist = getFileList(directory);
for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], ".czi")) {

run("Bio-Formats Importer", "open=["+directory + File.separator + filelist[i]+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

OriginalTitle = getTitle();
CurrentFile = replace(OriginalTitle,".czi","_segmentation.tif");
rename("StartImage");
run("Duplicate...", "duplicate channels=2");
rename("mCherry");

run("Run Autocontext Prediction", "projectfilename=[D:\\actin labeling comparison\\halvany_nincsrendesvisszateres\\mCherry_timelapse.ilp] inputimage=mCherry autocontextpredictiontype=Segmentation");
selectImage(3);
rename("Segmentation");

run("Duplicate...", "duplicate");
rename("SpineAndShaft");

run("Duplicate...", "duplicate");
rename("Spine");

close("mCherry");

selectImage("Segmentation");
save(directory + File.separator + CurrentFile);

SpineValueArray = newArray(0);
ReferenceValueArray = newArray(0);
BackgroundValueArray = newArray(0);

RoiFile = replace(OriginalTitle,".czi",".zip");

roiManager("open", directory + File.separator + RoiFile);
roiManager("Select", newArray(0,1,2));
roiManager("Remove Channel Info");
roiManager("Remove Slice Info");
roiManager("Remove Frame Info");

roiManager("deselect");

roiManager("Select", 0);
roiManager("rename", "Spine");

roiManager("Select", 1);
roiManager("rename", "Reference");

roiManager("Select", 2);
roiManager("rename", "Background");

selectImage("Spine");
getDimensions(width, height, channels, slices, frames);
    
for (j = 1; j <= frames; j++) {
   
    selectImage("Spine");
    Stack.setFrame(j);

	setThreshold(1, 1);
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=Default background=Dark only black");
	
	roiManager("Select", 0);
	run("Clear Outside", "slice");
	roiManager("Deselect");
	
	run("Create Selection");

	if (selectionType() < 0) {
	waitForUser("Correct image", "Please draw spine manually, \nthen press OK");
	}
	
	roiManager("add");

	roiManager("Select", 3);
	roiManager("Remove Channel Info");
	roiManager("Remove Slice Info");
	roiManager("Remove Frame Info");
	roiManager("rename", "SpineActual");
	roiManager("Deselect");
	run("Select None");

	selectImage("StartImage");
	Stack.setFrame(j);
	Stack.setChannel(1);
	roiManager("Select", 3);
	SpineValue = getValue("Mean");
	SpineValueArray = Array.concat(SpineValueArray,SpineValue);
	roiManager("delete");
	run("Select None");

	roiManager("Select", 2);
	BackgroundValue = getValue("Mean");
	BackgroundValueArray = Array.concat(BackgroundValueArray,BackgroundValue);	
	roiManager("deselect");
	run("Select None");

	selectImage("SpineAndShaft");
	Stack.setFrame(j);
	setThreshold(1, 2);
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=Default background=Dark only black");	

	roiManager("Select", 1);
	run("Clear Outside", "slice");
	run("Create Selection");
	roiManager("add");
	roiManager("Select", 3);
	roiManager("Remove Channel Info");
	roiManager("Remove Slice Info");
	roiManager("Remove Frame Info");
	roiManager("rename", "ReferenceActual");
	roiManager("deselect");
	run("Select None");

	selectImage("StartImage");
	Stack.setFrame(j);
	Stack.setChannel(1);
	roiManager("Select", 3);
	ReferenceValue = getValue("Mean");
	ReferenceValueArray = Array.concat(ReferenceValueArray,ReferenceValue);
	roiManager("delete");
	run("Select None");
	
}


roiManager("reset");
close("*");

TableTitle = replace(OriginalTitle,".czi",".csv");
Table.create(TableTitle);
Table.setColumn("Spine intensity", SpineValueArray);
Table.setColumn("Reference intensity", ReferenceValueArray);
Table.setColumn("Background intensity", BackgroundValueArray);

Table.save(directory + File.separator + TableTitle);
close(TableTitle);

}
}
