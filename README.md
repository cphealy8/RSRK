# Rolling Signal-Based Ripley's K 
## Authors and Affiliations
Connor P. Healy (connor.p.healy@gmail.com) [1]
Frederick R. Adler (adler@math.utah.edu[2]
Tara L. Deans (tara.deans@utah.edu) [1]

[1] Department of Biomedical Engineering, University of Utah
[2] Department of Mathematics, University of Utah

## Summary
Rolling Signal-Based Ripley's K performs a rolling window analysis of spatial distribution between point processes and signals in images. The RSRK package includes code to generate point processes from images, to compute the RSRK statistic, and to visualize RSRK results. 

For a full description of RSRK please see our paper at 
[INSERT PAPER REFERENCE HERE]

## Required Software
RSRK requires the following software.
- MATLAB version 9.5 (https://www.mathworks.com)
- MATLAB Image Processing Toolbox version 10.3 (https://www.mathworks.com/products/image.html)
- RSRK Toolbox (This package).

## Recommended Software
We recommend the following additional software.
- FIJI, ImageJ 1.52p (https://fiji.sc/)
- Adobe Photoshop

## Recommended Hardware
We recommend the following minimum hardware specifications. 
- Processor: Intel(R) Core(TM) i7-6700 CPU @ 3.4 GHz
- RAM: 32.0 GB
- GPU: NVIDIA Quadro P2000
- Free Memory: At least 5GB. 

## How to use RSRK
RSRK requires several initial image processing steps in order to produce the inputs needed for RSRK analyses. The following flowchart outlines the overall process. 

![RSRK Flow Chart](https://github.com/cphealy8/RSRK/blob/master/RSRKFlowChart.PNG)

### Step by Step
1. Download and unzip the RSRK toolbox. We recommend working within default RSRK file structure to avoid reference errors. 

2. If starting with a confocal z-stack, prepare a flattened 2D image using ImageJ’s built-in projection tools. In ImageJ select Image>Stacks>Z-Project. Then specify slice range and projection type (Maximum Intensity). (See Projection and Masking). Save the flattened image in the directory ../data/images. 

3. Prepare binary masks to define the RSRK analysis regions. Open the flattened image from step 1 in Photoshop, create a new layer atop the original image where the mask will be defined. Lock the original image layer. Do not crop or resize the image at anytime to ensure that the mask and flattened image have consistent resolution. Using the selection, paintbrush, or pen tools define the boundary between the masked and unmasked areas. Next fill the areas to be analyzed (unmasked) with white using the paint bucket tool, and the areas to be excluded from the analysis (masked) with black. Merge all layers so that you only have the mask, then change the image mode to grayscale (Image>Mode>Grayscale), then to Bitmap (Image>Mode>Bitmap). Finally save the image as a .bmp file in the directory ../data/images.
 
4. Obtain the desired point process by applying MySegment.m to the flattened image from step 1. (See Segmentation and Feature Identification). When the GUI terminates it will automatically prompt you to save the point process and segmentation data. Save the point process under the directory ../data/FullPts. 
5. Isolate the signal image that you wish to analyze. This should be a grayscale image showing only the expression of one marker e.g. CXCL12. This can be easily accomplished by running ImageLoad.m, loading a desired full color image, selecting the channel that corresponds to your target signal, then finally saving the resulting image as a grayscale .png file in the directory ../data/images.

6. Open RSRK.m. The first few lines of this script define the parameters of the RSRK analysis including the downsampling percentage, image scale, image units, window overlap v, number of windows n_w, and the scale vector r. You can change these if you wish. 

7. If your application requires that you specify two masks, as we did with the CXCL12 to bone analysis, one in which RSRK is calculated and one in which points are randomly placed, use RSRK_TwoMask.

8. Run RSRK.m. The code will automatically prompt you to select a point process file, a signal image, and a mask to use in the RSRK analysis. It will then automatically begin performing the RSRK analysis and will display the progress of the RSRK calculation. 

9. Once the calculation is complete, the script will automatically save the results to ../data/MovingRK.
 
10. Optional: Pool RSRK results. Repeat steps 1 through 7 until you have computed all of the individual RSRK results that you wish to pool. Run PoolRK.m. The function will automatically prompt you to select an RSRK data file it will then ask if you wish to add more RSRK data to be pooled. Keep adding data until all of the data that you wish pool has been selected beforing selecting “No” the next time the code prompts you to add more data. The code will then automatically pool the data that you selected. Finally, the code will prompt you to save the pooled data. 

11. To plot and visualize the results of RSRK analysis, run RSRKPlot.m. The code will automatically prompt you to select the RSRK data you wish to visualize. MovingRKPlot.m will display the results and automatically save them as .eps files to ../results/MovingRKPlots. It will save two files, one that shows the actual RSRK values and one that shows the significance level of the RSRK values. The colors in the latter correspond to the following significance values and pattern types: Blue, significant uniformity/repulsion α=0.01; Green, significant uniformity/repulsion α=0.05; Light Yellow, not significant versus random; Orange, significant clustering/attraction α=0.05; Red, significant clustering/attraction α=0.01. 

