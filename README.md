# Detecting Repeating Objects using Patch Correlation Analysis

This is the CPU implementation code of the paper: **Detecting Repeating Objects using Patch Correlation Analysis** presented in CVPR 2016.

### Abstract
In this paper we describe a new method for detecting and counting a repeating object in an image. While the method relies on a fairly sophisticated deformable part model, unlike existing techniques it estimates the model parameters in an unsupervised fashion thus alleviating the need for a user-annotated training data and avoiding the associated specificity. This automatic fitting process is carried out by exploiting the recurrence of small image patches associated with the repeating object and analyzing their spatial correlation. The analysis allows us to reject outlier patches, recover the visual and shape parameters of the part model, and detect the object instances efficiently. In order to achieve a practical system which is able to cope with diverse images, we describe a simple and intuitive active-learning procedure that updates the object classification by querying the user on very few carefully chosen marginal classifications. Evaluation of the new method against the state-of-the-art techniques demonstrates its ability to achieve higher accuracy through a better user experience.

### Running the code

##### The main script

The main file is countCells.m and it requires:
- **Image_name**. The name of the input image without any postfix (i.e., no `.png`,`.jpg`). It should be appeared in `images` directory. You can add your own image to this directory and run the code with its name. The code will load `[images/Image_name]` with several options for postfix.
- **Participant_name**. The results are saved in a dedicated results folder: `[res/Image_name_Participant_nameSequential_number]`. In case there are several runs for one participant or you have more than one paritcpant with the same name, the folder name contains a sequential number.

Examples for running the code: 
     - countCells('Cells1', 'Inbar')
     - countCells('cars', 'Inbar')
     - countCells('beers', 'Jonathan')

##### User Interaction

The algorithm can be divided into two parts as follows (the user interaction is marked in *Italic*): 

- Finding the DMP parameters automatically and extracing the features of the potintial locations (more information about the features can be found in the paper).
   - You are presented with the input image and *you need to mark a circle around the repeating object as accurate as possible*. This step is important for rescaling the image. Then, the algorithm automatically fits the DPM parameters and saves the features in the result folder.

- Interactive session where the user fine-tune the classifier of the potential locations by correcting the marginal classifications that are shown.
   - You will then be presented with the input image, 20 potiential locations with their classifications and a slider. *You should play with the slider to find the best classifications of the presented locations.*
*Press the start button.*
Next, we present 20 clusters of potential locations at every iteration where *you need to mark the wrong classifications*. *Press Enter at the end of every iteration* (when you think corrected al the worng classification in a ceratin iteration).

**Do not close any window during the run**

Pay attention that you should need to be consistant with your corrections. For example, if you have two potential locations in one repeated object (i.e., the top and the button of a bottle cap), be sure to mark the top **or** the button points as the repated object and do not mix across repated objects. Moreover, do not mark a potential locations as a repeated object if the center dot does around the center of the repated object.

The classifications are conveyed by rendering a red or green frame around each of 20 objects.

### The output
- X_forCheck.mat - Xs are the features extracted at the first part
- res.txt - saving the current state of every iteartion: the number of reapeting objects, number of user clicks and the total time. The first line is related to the first step.
- final_resY.png - the localization of the repeating object of each itearion (Y) overlayed on the input image.

More information can be found in the paper. If you have any questions, you can find me in: inbarhub@gmail.com
