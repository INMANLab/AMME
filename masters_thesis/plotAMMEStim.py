def plotBLAESStim(xyz, dPrime = None, roi_smoothing = 5, elec_size = 15, show_brain = True):
    """plotBLAESStim() uses the visbrain package (visbrain.org) to generate a 3D model of an brain w/ electrode contacts superimposed. Electrode locations (MNI XYZ coordinates) are defined in each patient's CSMap.mat file.

    Args:
        xyz (pd.DataFrame): X,Y,Z coordinates of electrodes (use MNI space if >1 patient).
        dPrime (pd.DataFrame, optional): dPrime values from behavioral testing; used to color electrodes.
        elec_size (float, optional): Marker size for electrode contact(s).
        roi_smoothing (int, optional): Amount of smoothing to apply to ROI voxels.
        
    Justin M. Campbell (justin.campbell@hsc.utah.edu)
    02/14/23
    """
        
    # Import libraries
    from visbrain.objects import BrainObj, ColorbarObj, SceneObj, SourceObj, RoiObj
    import numpy as np
    import seaborn as sns

    # Scene object
    scene_obj = SceneObj(bgcolor='white', size=(1000, 1000))
    
    # Brain object(s)
    if show_brain == False: #True means seeing the entire brain
        brain_obj = BrainObj('B3', translucent = True)
        scene_obj.add_to_subplot(brain_obj, row=0, col=0, use_this_cam=True)
    
    # ROI object(s)
    roiAMY = RoiObj('aal')
    #roiHC = RoiObj('aal')
    #roiEC = RoiObj('brodmann')
    #roiPRC = RoiObj('brodmann')
    #roiPHG = RoiObj('aal')
    roiAMY.select_roi(roiAMY.where_is('amygdala'), translucent = True, smooth = roi_smoothing, roi_to_color={41: 'purple', 42: 'purple'})
    #roiHC.select_roi(roiHC.where_is('hippocampus'), translucent = True, smooth = roi_smoothing, roi_to_color={37: 'green', 38: 'green'})
    #roiEC.select_roi(roiEC.where_is(['BA28', 'BA34']), translucent = True, smooth = roi_smoothing, roi_to_color= {28:'orange', 34:'orange'})
    #roiPRC.select_roi(roiPRC.where_is('BA35'), translucent = True, smooth = roi_smoothing, roi_to_color={35:'skyblue'})
    #roiPHG.select_roi(roiPHG.where_is('parahippocampal'), translucent = True, smooth = roi_smoothing, roi_to_color= {39:'blue', 40:'blue'})
    scene_obj.add_to_subplot(roiAMY, row=0, col=0)
    #scene_obj.add_to_subplot(roiHC, row=0, col=0)
    #scene_obj.add_to_subplot(roiEC, row=0, col=0)
    #scene_obj.add_to_subplot(roiPRC, row=0, col=0)
    #scene_obj.add_to_subplot(roiPHG, row=0, col=0)

    '''
    #Compare brain atlases for the same ROIs
    roiAMY1 = RoiObj('aal')
    #roiAMY2 = RoiObj('brodmann')
    #roiAMY3 = RoiObj('talairach')
    roiAMY4 = RoiObj('mist_ROI') #need to install this version of nibabel --> pip install nibabel==3.0.0
    #roiHPC4 = RoiObj('mist_ROI')
    #roiAMY5 = RoiObj()
    roiAMY1.select_roi(roiAMY1.where_is('amygdala'), translucent = True, smooth = roi_smoothing, roi_to_color={41: 'purple', 42: 'purple'})
    #roiAMY2.select_roi(roiAMY2.where_is(['BA34']), translucent = True, smooth = roi_smoothing, roi_to_color={34: 'yellow'})
    #roiAMY3.select_roi(roiAMY3.where_is('amygdala'), translucent = True, smooth = roi_smoothing, roi_to_color={180: 'yellow', 181: 'yellow'})
    roiAMY4.select_roi(roiAMY4.where_is('amygdala'), translucent = True, smooth = roi_smoothing, roi_to_color={124: 'yellow', 125: 'yellow'})
    #roiHPC4.select_roi(roiHPC4.where_is('hippocampus'), translucent = True, smooth = roi_smoothing)
    #roiAMY5.select_roi(roiAMY5.where_is('amygdala'), translucent = True, smooth = roi_smoothing)
    scene_obj.add_to_subplot(roiAMY1, row=0, col=0)
    #scene_obj.add_to_subplot(roiAMY2, row=0, col=0)
    #scene_obj.add_to_subplot(roiAMY3, row=0, col=0)
    scene_obj.add_to_subplot(roiAMY4, row=0, col=0)
    #scene_obj.add_to_subplot(roiHPC4, row=0, col=0)
    #scene_obj.add_to_subplot(roiAMY5, row=0, col=0)
    '''


    # Source object(s)
    #if dPrime is not None:
     #   iEEG_obj = SourceObj('iEEG', xyz, radius_min = elec_size, edge_color = 'black', edge_width = 0.5, symbol=exp_symbol)
      #  iEEG_obj.color_sources(data = dPrime, cmap = 'coolwarm')


    if responder is not None:
        iEEG_obj = SourceObj('iEEG', xyz, radius_min = elec_size, edge_color = 'black', edge_width = 0.5, symbol=exp_symbol)
        iEEG_obj.color_sources(data = responder, cmap = 'coolwarm')
    else:
       iEEG_obj = SourceObj('iEEG', xyz, color = (['#000000'] * len(xyz)), radius_min = elec_size) # All black
    scene_obj.add_to_subplot(iEEG_obj)


    # Colorbar
    CBAR_STATE = dict(cbtxtsz=15, txtsz=10, txtcolor = 'black', width=.1, cbtxtsh=3., rect=(-.3, -2., 1., 4.), clim = ([-1,1]))
    cbar_obj = ColorbarObj(iEEG_obj, cblabel="Responder Status", **CBAR_STATE)
    scene_obj.add_to_subplot(cbar_obj, row=0, col=1, width_max=200)
    #will need to add a legend here about the second variable we add in

    # Preview
    scene_obj.preview()

### IMPLEMENTATION
import pandas as pd
import pandas._libs.testing as _testing
datapath = '/Users/martinahollearn/Library/CloudStorage/Box-Box/AMME_Data_Emory/AMME_Data/Delay_and_Stim_Conditions-Martina/for3Dplot_responder_quartilebased.csv'       
AMMECoords = pd.read_csv(datapath)
AMMECoords = AMMECoords.dropna()
xyz = AMMECoords[['X', 'Y', 'Z']].to_numpy()
#dPrime= AMMECoords['avg_dprime_diff'].to_numpy()
responder = AMMECoords['responder_dummy'].to_numpy()
#responder_colors = AMMECoords['responder_color']
exp_symbol = AMMECoords['experiment_shape']
#shape_edge_color = AMMECoords['chan_color']
if __name__ == "__main__":
    plotBLAESStim(xyz, responder)

