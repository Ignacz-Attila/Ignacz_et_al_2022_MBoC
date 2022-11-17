# Ignacz_et_al_2022
Code repository for the FIJI macros used in Ignácz et al. 2022.
The files contain the different steps of evaluation as FIJI macros. Stage1 is generated from raw images, so they import the .czi file format of Zeiss images, then extract the EGFP signal. They run the Stage1 Ilastik model on it, to segment the spines.
For subspine segmentation, Stage2 and Skeleton are needed. It works similarly to Stage1 but it imports the segmented Stage1 images, so you need to have them before you can start this. The order in which you process Stage2 and Skeleton
Analysis needs Stage1, Stage2 and Skeleton segmentations ready and the spine ROI-s as well.
