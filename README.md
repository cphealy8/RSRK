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
### Overall Workflow
RSRK requires several initial image processing steps in order to produce the inputs needed for RSRK analyses. The following outlines the overall workflow. Additional details for each step are listed later.

1. Download and unzip the RSRK toolbox. We recommend working within the RSRK file structure to avoid reference errors.

2. Perform initial image processing to obtain 2D image of the signal point process to be analyzed.

3. Generate masks to define analysis regions. 

4. Obtain point process via manual or automatic image segmentation (Repeat for each point process to be analyzed). 

5. Apply RRK or RSRK. 

6. Generate RRK or RSRK Plots. 

### Initial Image Processing

3-dimensional images (z stacks, confocal images) should be converted into 2-dimensional images before being used as inputs for RRK and RSRK. In this study, raw z-stacks were first converted (at maximum resolution) to 2D images using ImageJ’s built-in maximum intensity projection utility using the full width of the stack (Image>Stacks>Z project). 
Images should be contrasted to remove background fluorescence and pixel intensities should be normalized (between 0 and 255) before further processing. In this study, the 2D images from the previous step were contrasted using Photoshops built-in leveling utility (Image>Adjustments>Levels). In the Levels menu, the background of each image was sampled and set to the blackpoint of the image.

Finally, multi-channel images (where each channel corresponds to a unique antigen or marker) the channels should be isolated and converted to a grayscale image that is saved separately from the full color image. Both Photoshop and ImageJ have built-in utilities that can perform this function. Including the prefix 'signal' in the filename of these images will enable automatic detection by RRK and RSRK. 

### Mask Generation

To permit analysis of geometrically complex regions RRK and RSRK require a second image input that defines the regions to be analyzed in the image. The second image, or mask, is a black and white binary image that labels analyzed pixels as white and ignored pixels as black. Masks can be generated using image segmentation or manually using an image processing utility such as ImageJ or Photoshop. In some instances it may be desirable to define separate masks for the analysis region and the region in which point processes are simulated. In this study this was done to include bone in an RSRK analysis but restrict cells (during random simulation) to only regions in which they’d be expected to localize (non-bone areas). In these instances two separate masks can be defined (one for each scenario) and provided to RRK/RSRK. Regardless of how they are generated, masks should be supplied to RRK/RSRK as black and white .bmp images of the same size and resolution as immunofluorescent images passed to RRK/RSRK.

### Image Segmentation and Point Process Acquisition

Numerous tools exist to segment images and most image processing software (e.g. ImageJ) has built in functions to segment features in an image. In manual segmentation, the target features are manually marked, usually using software to aid in the process. For example a researcher, might manually click on cells in an image to mark them or trace a region of interest in an image. In this study, Photoshop was used to manually segment different regions of the bone marrow to define the masks used in RSRK analysis.  The simplest and most common means of automatically segmenting an image starts with thresholding to approximately select a target feature followed by morphological operations (e.g., morphological opening, closing, etc…) to refine that selection. In this study we developed MATLAB code to threshold, denoise, and refine the selection of CXCL12+ cells and Megkaryocytes in immunofluorescent images. Examples of the operations used to segment CXCL12+ cells and Megakaryocytes, can be found in *CXCL12Segmenter.m* and *MKSegmenter.m* in the RSRK toolset.

### Rolling Signal-based Ripley's K (RSRK)
#### Analysis
*RSRK_Analysis.m* performs RSRK analysis given the following inputs. 

1.	Signal Image(s): A signal image or images. As indicated previously, these images should be grayscale and saved as .png files. These images should have ‘signal’ in their name followed by a unique identifier to be recognized by *RSRK_Analysis.m*, e.g. signal_CD31.png.

2.	Point Process(es): Target point process(es) (usually obtained via segmentation) containing the coordinates of the point process in the same units as the signal image(s) (usually pixels). These coordinates should be specified as a 2-column matrix (x-coordinates in one column, y coordinates in the other) named ‘pts’ and saved as a .mat file. Each unique point process should be saved as a separate file and these files should include ‘PP’ in their name followed by a unique identifier to be correctly identified by *RSRK_Analysis.m*, e.g. PP_MK.mat

3.	Mask: A mask to specify the analysis region. As indicated previously, masks should be specified as black and white images saved as .bmp files. The resolution of the mask should exactly match the resolution of the input signal images. The mask file should include ‘ppmask’ in its name to be correctly identified by RSRK_Analysis.m e.g. ppmask.bmp. 

4.	Image Scale: A txt file that specifies the scale and units of the image e.g. ‘1.5 px/um’. This file should be named imscale.txt. 

Each of these inputs should be saved together in a folder within the analysis directory specified in the USER INPUT section of RSRK_Analysis.m along with parameters for the analysis e.g. number of frames, frame overlap, and scales to be analyzed. This folder defines a single RSRK analysis set. When run, RSRK_Analysis.m will compute RSRK for every point process and signal pair contained in the analysis folder. The results of this analysis will be stored within the same folder and will contain the suffix RSRKDat in their filename followed by the unique IDs for the signal and point process that went into the analysis and the time at which the analysis was completed (YYYYMMDD-HHMM) e.g. RSRKDat_CD31-to-MK_20210211-0139.mat

#### Plotting
*RSRK_Plots.m*  generates plots from RSRK results.

The RSRK data file (e.g. RSRKDat_CD31-to-MK_20210211-0139.mat) should be saved in a folder within the directory specified in the first few lines of the script. If you, followed the instructions for RSRK_Analysis.m the data file will already be accessible to RSRK_Plots.m. If data files are accessible, running RSRK_Plots.m will read the data files, generate RSRK plots, then save those plots as .pdf and .eps files to the Save Directory indicated in the first few lines of the script. 

### Rolling Ripley's K (RRK)
*RRK_AnalysisAndPlot.m* performs RRK analysis and generates RRK plots given the following inputs.

1.	Point Process(es)

2.	Mask

3.	Image Scale.

Note the naming and filetype requirements for these inputs are the same as the requirements for the inputs to RSRK_Analysis.m. Each of these inputs should be saved together in a folder within the analysis directory specified in the USER INPUT section of RRK_AnalysisAndPlot.m along with parameters for the analysis e.g. number of frames, frame overlap, and scales to be analyzed. This folder defines a single analysis set. This script, when run, will import these inputs, perform RRK analysis, then generate plots of the results. These plots and the results of the analysis are then saved within the folder of the same analysis set.

## Citation
To cite RSRK and the RSRK package please use [INSERT PAPER REFERENCE HERE]
