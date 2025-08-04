%% Initialization
clear;
clc;
%-----------Raw Data Path
RDD = "Z:\Data\AMME_Data_Emory\AMME_Data\";
%-----------Read Processed Data from:
RD = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";
%-----------Write Processed Data to:
WR = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                  AMME ORIGINAL PATIENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
pID = 1;
patient(pID).exp = 'Original';
patient(pID).name  = 'amyg001';
patient(pID).syncfn = 'day1_lfp_095.mat';
patient(pID).samprate = 499.70714;%samp rate day1 - based on EDFbrowser
patient(pID).ipsi_region(1).lfpnum = [124,125];%per Jon: 124 is CA1, next to ventricle; ...124 = CA1/3; 125 is likely in white matter near CA fields per DARPA
patient(pID).ipsi_region(2).lfpnum = [];%probably no gray matter contact
patient(pID).ipsi_region(3).lfpnum = [];%probably no gray matter contact
patient(pID).ipsi_region(4).lfpnum = 128;%stimulated channels = 128 (monopolar)
patient(pID).ipsi_region(5).lfpnum = [124,125];%region 5 = all possible hippocampus electrodes; see above for notes
patient(pID).ipsi_region(6).lfpnum = [];%entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 124;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = [];%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = [];%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 128;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'RIFTFd8', 'RM1Cd7', 'RM1Cd8', 'RS1Id7', 'RM1ISd10', 'LMTGAd', 'RS1Id8', 'RS1Id1', 'RM1Id10'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'RIFTFd8', 'RM1Cd7', 'RM1Cd8', 'RS1Id7', 'RM1ISd10', 'LMTGAd', 'RS1Id8', 'RS1Id1', 'RM1Id10'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'RIFTFd8', 'RM1Cd8','RS1Cd1', 'RS1Id8', 'RS1Id1', 'RM1Id10', 'RM1ISd10','RFPd5','LMTGAd'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];
patient(pID).contra_region(2).lfpnum = [];
patient(pID).contra_region(3).lfpnum = [];
patient(pID).contra_region(4).lfpnum = [];
patient(pID).contra_region(5).lfpnum = [];
patient(pID).contra_region(6).lfpnum = [];
patient(pID).contra_region(7).lfpnum = [];
patient(pID).stimchan(1).num = 128;%only one--monopolar
patient(pID).stimchan(2).num = [];
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];

pID = pID+1;
patient(pID).exp = 'Original';
patient(pID).name  = 'amyg002';
patient(pID).syncfn  = 'day1_lfp_018.mat';
patient(pID).samprate = 499.70714;
patient(pID).ipsi_region(1).lfpnum = [];%update 10/10/16--no ipsi hip electrodes; DARPA lists 117 as both CA and DG
patient(pID).ipsi_region(2).lfpnum = [];
patient(pID).ipsi_region(3).lfpnum = 116;%per both Jon and DARPA
patient(pID).ipsi_region(4).lfpnum = [127, 128];%stimulated channels = 127 & 128
patient(pID).ipsi_region(5).lfpnum = [];%region 5 = all possible hippocampus electrodes; see above for notes
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = [];% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = [];%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = [];%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = [];%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'2LpRd8', 'LSMACd2', 'LSMACd1', 'LSPFs6', 'LPTs5', '5RpRd8', 'RSTGId7', 'RpHGd7', '6RpRd10', 'Lamyd3', 'LAmyd2'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'2LpRd8', 'LSMACd2', 'LSMACd1', 'LSPFs6', 'LPTs5', '5RpRd8', 'RSTGId7', 'RpHGd7', '6RpRd10', 'Lamyd3', 'LAmyd2'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'LSMACd1', 'LSPFs6', 'LPTs5', '2LpRd8', '2RpRd4', '2RpRd2', '2RpRd5', 'RSTGId7', 'RpHGd7', '5RpRd8', '5RpRd7'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];
patient(pID).contra_region(2).lfpnum = [];
patient(pID).contra_region(3).lfpnum = [];
patient(pID).contra_region(4).lfpnum = [];
patient(pID).contra_region(5).lfpnum = [];
patient(pID).contra_region(6).lfpnum = [];
patient(pID).contra_region(7).lfpnum = [];
patient(pID).stimchan(1).num = 127;
patient(pID).stimchan(2).num = 128;
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];

pID = pID+1;
patient(pID).exp = 'Original';
patient(pID).name  = 'amyg003';
patient(pID).syncfn  = 'day1_lfp_128.mat';
patient(pID).samprate = 999.41211;
patient(pID).ipsi_region(1).lfpnum = 32;%32=CA2/DG per Jon; 31=CA3/DG per Jon (noisy); 30=SUB per Jon (though it is noisy)
patient(pID).ipsi_region(2).lfpnum = [];
patient(pID).ipsi_region(3).lfpnum = [];%33 = parahippocampal (peri/para border) white matter near collateral eminence per Jon; 34 = PH cortex white matter near collateral sulcus per Jon
patient(pID).ipsi_region(4).lfpnum = [21,20];%stimulated channels = 20 & 21
patient(pID).ipsi_region(5).lfpnum = 32;%region 5 = all possible hippocampus electrodes; see above for notes
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = 33;%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 32;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = [];%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 33;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 21;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'L1d9', 'L13d7', 'L15d6', 'L1d7', 'L3d4', 'L13d2', 'L13d1', 'L15d9', 'L19d1', 'LSFs3', 'RSRCH', 'R2d5', 'R2d1', 'LSFs1', 'LATs7', 'R4d1', 'R14d1', 'R12d7', 'R14d8', 'R14d4', 'R20d1', 'R18d7', 'RPTs5', 'R20d10', 'R14d10', 'R16d4'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'L1d9', 'L13d7', 'L15d6', 'L1d7', 'L3d4', 'L13d2', 'L13d1', 'L15d9', 'L19d1', 'LSFs3', 'RSRCH', 'R2d5', 'R2d1', 'LSFs1', 'LATs7', 'R4d1', 'R14d1', 'R12d7', 'R14d8', 'R14d4', 'R20d1', 'R18d7', 'RPTs5', 'R20d10', 'R14d10', 'R16d4'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'L15d2', 'R10d3', 'R12d7', 'R14d1', 'R14d8', 'R16d4', 'R20d10', 'R4d1', 'R2d1', 'R2d5', 'LATs7', 'LATs5', 'RPTs5', 'R18d7', 'R14d10', 'R14d4', 'L13d7', 'L1d9', 'L1d7', 'L15d9', 'L15d6', 'L3d4', 'LSFs3', 'LSFs1', 'L19d1'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];
patient(pID).contra_region(2).lfpnum = [];
patient(pID).contra_region(3).lfpnum = [];
patient(pID).contra_region(4).lfpnum = [];
patient(pID).contra_region(5).lfpnum = [];
patient(pID).contra_region(6).lfpnum = [];
patient(pID).contra_region(7).lfpnum = [];
patient(pID).stimchan(1).num = 20;
patient(pID).stimchan(2).num = 21;
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];

pID = pID+1;
patient(pID).exp = 'Original';
patient(pID).name  = 'amyg005';%pervious contralateral lateral temporal lobe resection from TBI
patient(pID).syncfn  = 'day1_lfp_096.mat';
patient(pID).samprate = 999.41211;
patient(pID).ipsi_region(1).lfpnum = [];%no CA1/CA3 ipsi
patient(pID).ipsi_region(2).lfpnum = [];%no DG ipsi
patient(pID).ipsi_region(3).lfpnum = 107;%border of perirhinal ctx and adjacent white matter per Jon; 108 is same per Jon
patient(pID).ipsi_region(4).lfpnum = [102,103];%stimulated channels = 102 & 103
patient(pID).ipsi_region(5).lfpnum = [];%region 5 = all possible hippocampus electrodes; see above for notes
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = 107;%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = [];% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = [];%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 107;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 103;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'R2Od7', 'C127', 'C128', 'C126', 'O1', 'T5', 'T3', 'F7', 'Fp1', 'C120', 'C119', 'C118', 'C117', 'C116', 'C115', 'C114', 'R2Od9', 'LAmyd1', 'LAmyd3', 'RAHd1', 'R2FOpd7', 'RPTrid7'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'R2Od7', 'C127', 'C128', 'C126', 'O1', 'T5', 'T3', 'F7', 'Fp1', 'C120', 'C119', 'C118', 'C117', 'C116', 'C115', 'C114', 'R2Od9', 'LAmyd1', 'LAmyd3', 'RAHd1', 'R2FOpd7', 'RPTrid7'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'C128', 'C127', 'C126', 'O1', 'T5', 'T3', 'F7', 'Fp1', 'C120', 'C119', 'C118', 'C117', 'C116', 'C115', 'C114', 'R2Od7', 'RAHd1', 'R2FOpd7', 'RPTrid7'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];
patient(pID).contra_region(2).lfpnum = [];
patient(pID).contra_region(3).lfpnum = [];
patient(pID).contra_region(4).lfpnum = [];
patient(pID).contra_region(5).lfpnum = [];
patient(pID).contra_region(6).lfpnum = [];
patient(pID).contra_region(7).lfpnum = [];
patient(pID).stimchan(1).num = 102;
patient(pID).stimchan(2).num = 103;
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];

pID = pID+1;
patient(pID).exp = 'Original';
patient(pID).name  = 'amyg007';
patient(pID).syncfn  = 'day1_lfp_102.mat';
patient(pID).samprate = 999.41211;%based on EDFbrowser and feedback from EMU director (via Cory) to use this rather than 1000
patient(pID).ipsi_region(1).lfpnum = 23;%23=CA1/CA2 per Jon; 27 = ventricle adjacent to hippocampus; 26 = subiculum per Jon per Joe via ROSA: 23* = very anterior (but still body of hip); 26 = mid S-T
patient(pID).ipsi_region(2).lfpnum = [];%no DG per Jon
patient(pID).ipsi_region(3).lfpnum = [];%no PHG per Jon
patient(pID).ipsi_region(4).lfpnum = 19;%stimulated channels = 19 & 48--19 is noisy, but it doesn't look like we can risk #48
patient(pID).ipsi_region(5).lfpnum = [23,26];%region 5 = all possible hippocampus electrodes; see above for notes
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 23;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = [];%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = [];%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 19;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'LAmyd1', 'LAmyd3', 'LAmyd7', 'LAmyd2', 'LAHd1', 'RPHd2', 'RPHd4', 'RSMAd7'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'LAmyd1', 'LAmyd3', 'LAmyd7', 'LAmyd2', 'LAHd1', 'RPHd2', 'RPHd4', 'RSMAd7'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'LAmyd7', 'LAmyd1', 'RPHd4', 'RACind1', 'RSMAd7', 'RACind3', 'RAHd2', 'RAmyd3', 'LpHGd3', 'LAHd2'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];
patient(pID).contra_region(2).lfpnum = [];
patient(pID).contra_region(3).lfpnum = [];
patient(pID).contra_region(4).lfpnum = [];
patient(pID).contra_region(5).lfpnum = [];
patient(pID).contra_region(6).lfpnum = [];
patient(pID).contra_region(7).lfpnum = [];
patient(pID).stimchan(1).num = 19;
patient(pID).stimchan(2).num = 48;%per Cory--electrode 48 was stimulated on day one, but might not have been plugged into BLA on day 2
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];

pID = pID+1;
patient(pID).exp = 'Original';
patient(pID).name  = 'amyg008';
patient(pID).syncfn  = 'day1_lfp_078.mat';
patient(pID).samprate = 999.41211;%based on EDFbrowser and feedback from EMU director (via Cory) to use this rather than 1000
patient(pID).ipsi_region(1).lfpnum = [27,24];%Per Jon: 24 & 25 = CA1(head/uncal apex); 26 = fimbria near CA3; 27 = CA2/CA3; 28 = CA2; 31 = CA1/2/3 (though noisy) per Joe via ROSA: 24,25 both in head; 27* @ anterior 1/3 S-T, 28 mid S-T
patient(pID).ipsi_region(2).lfpnum = [];
patient(pID).ipsi_region(3).lfpnum = [];%Per Jon: 49, 50, 51 = entorhinal cortex; 52, 55, 56, 57 = parahip/entorhinal, 52 is close to PHC/PRC while 55,56,57 are in perirhinal
patient(pID).ipsi_region(4).lfpnum = [];%stimulated channels = 53 & 54--53 was noisy - Martina: 53 and 54 are both noisy at day2
patient(pID).ipsi_region(5).lfpnum = [27,24,25,28];%region 5 = all possible hippocampus electrodes; see above for notes
patient(pID).ipsi_region(6).lfpnum = [49,50,51]; %entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = 52;%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 27;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = [];%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 52;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 54;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'RAHcd3', 'RPHcd8', 'RMTGd8', 'RROI6d9', 'RROI6d7', 'RROI6d5', 'RROI6d3', 'RROI6d1', 'RROI4d10', 'RROI4d3', 'RPHcd5', 'REntd5', 'REntd6', 'LPHcd1', 'LPHcd4', 'LPHcd2', 'RAHcd2', 'RPHcd4', 'RPHcd3', 'RPHcd2', 'RAHcd5', 'RAHcd4', 'RAHcd1'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'RAHcd3', 'RPHcd8', 'RMTGd8', 'RROI6d9', 'RROI6d7', 'RROI6d5', 'RROI6d3', 'RROI6d1', 'RROI4d10', 'RROI4d3', 'RPHcd5', 'REntd5', 'REntd6', 'LPHcd1', 'LPHcd4', 'LPHcd2', 'RAHcd2', 'RPHcd4', 'RPHcd3', 'RPHcd2', 'RAHcd5', 'RAHcd4', 'RAHcd1'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'RAHcd3', 'REntd6', 'RROI4d3', 'RROI6d9', 'RROI6d7', 'RROI6d5', 'RROI6d3', 'RROI6d1', 'LPHcd1', 'LPHcd2', 'RPHcd4', 'RPHcd5', 'RPHcd8', 'RMTGd8', 'RROI4d10'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];
patient(pID).contra_region(2).lfpnum = [];
patient(pID).contra_region(3).lfpnum = [];
patient(pID).contra_region(4).lfpnum = [];
patient(pID).contra_region(5).lfpnum = [];
patient(pID).contra_region(6).lfpnum = [];
patient(pID).contra_region(7).lfpnum = [];
patient(pID).stimchan(1).num = 53;
patient(pID).stimchan(2).num = 54;
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];

pID = pID+1;
patient(pID).exp = 'Original';
patient(pID).name  = 'amyg009';
patient(pID).syncfn  = 'day1_lfp_070.mat';
patient(pID).samprate = 999.41211;
patient(pID).ipsi_region(1).lfpnum = 31;%per Jon: 21=uncinate gyrus/head; 31,32,42=CA3/fimbria;33=CA2/CA3; 34 = CA2/CA1 per Joe via ROSA: 21=head; 31=anterior in hip*; 32=fimbria; 33=mid S-T; 34 = mid S-T; 42 = post 1/3 S-T per DARPA:22-25 are CA1/CA3; 34 and 43 are also CA1/CA3 per DARPA
patient(pID).ipsi_region(2).lfpnum = [];%per Jon: no DG; per DARPA 32, 33, 41, 42 are all DG
patient(pID).ipsi_region(3).lfpnum = [];%no ipsi phg per Jon and per DARPA
patient(pID).ipsi_region(4).lfpnum = [12,13];%stimulated channels = 12 & 13
patient(pID).ipsi_region(5).lfpnum = [31,21,33,34,42];%region 5 = all possible hippocampus electrodes; see above for notes
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 31;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = [];%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = [];%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 12;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'R4MHd10', 'C128', 'C127', 'C126', 'C125', 'C124', 'C123', 'C122', 'C121', 'C120', 'C119', 'C118', 'C117', 'C116', 'C115', 'C114', 'C113', 'C112', 'C111', 'C110', 'C109', 'C108', 'C107', 'C106', 'C105', 'C103', 'C104', 'C102', 'C100', 'C101', 'C99', 'C98', 'C97', 'C96', 'C93', 'C94', 'C95', 'C92', 'C91', 'C90', 'C89', 'C87', 'C88', 'C86', 'C85', 'C84', 'C83', 'C82', 'C80', 'C81', 'C79', 'C78', 'C77', 'C76', 'C74', 'C75', 'C73', 'C72', 'C71', 'L3Amyd3', 'L3Amyd2', 'L5AHd1', 'L5AHd2', 'L7MHd3', 'L7MHd2', 'L7MHd1', 'L5AHd4', 'L5AHd3', 'L1TPol1', 'L1TPol2', 'L9PHd1', 'L9PHd2', 'L7MHd4'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'R4MHd10', 'C128', 'C127', 'C126', 'C125', 'C124', 'C123', 'C122', 'C121', 'C120', 'C119', 'C118', 'C117', 'C116', 'C115', 'C114', 'C113', 'C112', 'C111', 'C110', 'C109', 'C108', 'C107', 'C106', 'C105', 'C103', 'C104', 'C102', 'C100', 'C101', 'C99', 'C98', 'C97', 'C96', 'C93', 'C94', 'C95', 'C92', 'C91', 'C90', 'C89', 'C87', 'C88', 'C86', 'C85', 'C84', 'C83', 'C82', 'C80', 'C81', 'C79', 'C78', 'C77', 'C76', 'C74', 'C75', 'C73', 'C72', 'C71', 'L3Amyd3', 'L3Amyd2', 'L5AHd1', 'L5AHd2', 'L7MHd3', 'L7MHd2', 'L7MHd1', 'L5AHd4', 'L5AHd3', 'L1TPol1', 'L1TPol2', 'L9PHd1', 'L9PHd2', 'L7MHd4'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'C118', 'C117', 'C116', 'C115', 'C114', 'C113', 'C112', 'C111', 'C110', 'C108', 'C109', 'C107', 'C106', 'C105', 'C104', 'C103', 'C102', 'C101', 'C100', 'C98', 'C99', 'C97', 'C96', 'C95', 'C94', 'C93', 'C92', 'C91', 'C90', 'C89', 'C88', 'C87', 'C86', 'C85', 'C84', 'C83', 'C82', 'C81', 'C79', 'C80', 'C78', 'C77', 'C76', 'C75', 'C74', 'C73', 'C72', 'C71', 'R4MHd10', 'L5AHd1', 'L5AHd3', 'L5AHd2', 'L5AHd4', 'L7MHd3', 'L7MHd2', 'L7MHd1', 'L9PHd2', 'L9PHd1', 'L1TPol2', 'L1TPol1', 'L1TPol4', 'L1TPol3'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];
patient(pID).contra_region(2).lfpnum = [];
patient(pID).contra_region(3).lfpnum = [];
patient(pID).contra_region(4).lfpnum = [];
patient(pID).contra_region(5).lfpnum = [];
patient(pID).contra_region(6).lfpnum = [];
patient(pID).contra_region(7).lfpnum = [];
patient(pID).stimchan(1).num = 12;
patient(pID).stimchan(2).num = 13;
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];

pID = pID+1;
patient(pID).exp = 'Original';
patient(pID).name  = 'amyg010';
patient(pID).syncfn  = 'day1_lfp_068.mat';
patient(pID).samprate = 499.70714;
patient(pID).ipsi_region(1).lfpnum = [31,32,53];%per Jon: 31=CA1@head; 32=CA1; 41=CA3/fimbria; 42=CA2/3; 43=CA2; 52=CA3; 53=CA1/2; 51=sub, per Joe via ROSA: 31,32=head; 33*=anterior body; 41=fimbria; 42=mid S-T; 43,51=mid S-T, but close to ventricle; 52=posterior 1/3; 53=post 1/3 but close to ventricle, per DARPA: 31, 34, 53 are CA1/CA3 ;  42, 43 are subiculum per DARPA
patient(pID).ipsi_region(2).lfpnum = 33;%per Jon: 33 = DG per DARPA: 32, 33, 52 are DG; 
patient(pID).ipsi_region(3).lfpnum = [];%per Jon: 35 = Parahip gyrus/fusiform gyrus/perirhinal per DARPA: 35 and 36 are perirhinal
patient(pID).ipsi_region(4).lfpnum = [22,23];%stimulated channels = 22 & 23
patient(pID).ipsi_region(5).lfpnum = [33,31,32,42,43,51,52,53];%region 5 = all possible hippocampus electrodes; see above for notes
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = 35;%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 33;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 33;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 35;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 23;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'L5Amyd3', 'L13OF1d9', 'L13OF1d8', 'C128', 'C127', 'C126', 'C124', 'C125', 'C123', 'C122', 'C121', 'C120', 'C119', 'C118', 'C117', 'C116', 'C115', 'C114', 'C113', 'C112', 'C111', 'C110', 'C109', 'C108', 'C107', 'C106', 'C105', 'C104', 'C103', 'C102', 'C101', 'C100', 'C99', 'C98', 'C97', 'C96', 'C95', 'C94', 'C93', 'C92', 'C91', 'C89', 'C90', 'C88', 'C87', 'C86', 'C85', 'C84', 'C83', 'C82', 'C81', 'L5Amyd2'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'L5Amyd3', 'L13OF1d9', 'L13OF1d8', 'C128', 'C127', 'C126', 'C124', 'C125', 'C123', 'C122', 'C121', 'C120', 'C119', 'C118', 'C117', 'C116', 'C115', 'C114', 'C113', 'C112', 'C111', 'C110', 'C109', 'C108', 'C107', 'C106', 'C105', 'C104', 'C103', 'C102', 'C101', 'C100', 'C99', 'C98', 'C97', 'C96', 'C95', 'C94', 'C93', 'C92', 'C91', 'C89', 'C90', 'C88', 'C87', 'C86', 'C85', 'C84', 'C83', 'C82', 'C81', 'L5Amyd2'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'C127', 'C128', 'C126', 'C125', 'C124', 'C123', 'C122', 'C121', 'C120', 'C119', 'C118', 'C117', 'C116', 'C115', 'C113', 'C114', 'C112', 'C111', 'C110', 'C109', 'C108', 'C107', 'C106', 'C105', 'C103', 'C104', 'C102', 'C101', 'C100', 'C97', 'C99', 'C98', 'C96', 'C95', 'C94', 'C93', 'C92', 'C91', 'C90', 'C89', 'C87', 'C88', 'C81', 'C83', 'C84', 'C85', 'C86', 'C82', 'L13OF1d8', 'L11PHd8'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];
patient(pID).contra_region(2).lfpnum = [];
patient(pID).contra_region(3).lfpnum = [];
patient(pID).contra_region(4).lfpnum = [];
patient(pID).contra_region(5).lfpnum = [];
patient(pID).contra_region(6).lfpnum = [];
patient(pID).contra_region(7).lfpnum = [];
patient(pID).stimchan(1).num = 22;
patient(pID).stimchan(2).num = 23;
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];

pID = pID+1;
patient(pID).exp = 'Original';
patient(pID).name  = 'amyg011';
patient(pID).syncfn  = 'day1_lfp_043.mat';
patient(pID).samprate = 999.41211;
patient(pID).ipsi_region(1).lfpnum = 35;%per Jon: 35 = CA1, 40 = CA2/3,  %per Jon and DARPA 39 = subiculum (noisy)per Joe via ROSA: 34=head; 35*=anterior hip body; 40 = post 1/3 S-T
patient(pID).ipsi_region(2).lfpnum = 34;%per Jon: 34 = DG at head of hip; per DARPA 40 = DG (Jon said 40 was CA2/3)
patient(pID).ipsi_region(3).lfpnum = [];%none per Jon or DARPA
patient(pID).ipsi_region(4).lfpnum = 30;%stimulated channels = 29 & 30, 29 not in day2 EDF file
patient(pID).ipsi_region(5).lfpnum = [35,34,40];%region 5 = all possible hippocampus electrodes; see above for notes
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 35;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 34;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = [];%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 29;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'LHcd9', 'RAmyd1', 'RPHcd1', 'C127', 'RSupPs1', 'RSupPs3', 'RSupPs5', 'RSupPs7', 'RSupPs9', 'C128', 'RAntTs9', 'RPosTs3', 'RAntTs3', 'RAntTs5', 'RPHcd9', 'RAmyd3', 'RPHcd5', 'RPHcd7'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'LHcd9', 'RAmyd1', 'RPHcd1', 'C127', 'RSupPs1', 'RSupPs3', 'RSupPs5', 'RSupPs7', 'RSupPs9', 'C128', 'RAntTs9', 'RPosTs3', 'RAntTs3', 'RAntTs5', 'RPHcd9', 'RAmyd3', 'RPHcd5', 'RPHcd7'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'LHcd9', 'RPHcd1', 'RPHcd9', 'RPHcd3', 'RAHcd3', 'RAmyd9', 'RAmyd7', 'RSupPs9', 'RSupPs7', 'RSupPs5', 'RSupPs3', 'RSupPs1', 'RPosTs3'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];
patient(pID).contra_region(2).lfpnum = [];
patient(pID).contra_region(3).lfpnum = [];
patient(pID).contra_region(4).lfpnum = [];
patient(pID).contra_region(5).lfpnum = [];
patient(pID).contra_region(6).lfpnum = [];
patient(pID).contra_region(7).lfpnum = [];
patient(pID).stimchan(1).num = 29;
patient(pID).stimchan(2).num = 30;
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];

pID = pID+1;
patient(pID).exp = 'Original';
patient(pID).name = 'amyg013';
patient(pID).syncfn  = 'day1_lfp_101.mat';
patient(pID).samprate =  499.70714;
patient(pID).ipsi_region(1).lfpnum = 25;%per Jon: 12 = CA1/DG, 22 = uncal apex CA2, 25 = CA1/white matter, 33 = CA1 (posterior); 24, 31, 32=subiculum,per Joe via ROSA: 11,22=head;12=head/body? 13,23,24*=ant body; 25=ant 1/2 but near white; 31=ant body but near ventricle; 32=mid S-T; 33=post 1/3...per DARPA: 12, 14, 24, 25, 33 = CA1/CA3 (12 is noisy); 23, 31, 32 = subiculum
patient(pID).ipsi_region(2).lfpnum = [];%per Jon: 11 =uncal apex DG, 13, 23 = DG; per DARPA: 13 = DG - Martina: 13 very epileptic
patient(pID).ipsi_region(3).lfpnum = 35;%per Jon: 34, 35 = PHG/white matter (Jon said 22= uncal apex CA2, 26 = white matter)...per DARPA: 22 = Entorhinal; 26, 34, 35 = parahippocampal
patient(pID).ipsi_region(4).lfpnum = 3;%stimulated channels = 2 & 3, Martina: 2 is very epileptic on day2 files
patient(pID).ipsi_region(5).lfpnum = [13,25];%region 5 = all possible hippocampus electrodes; Martina: all other channels are very epileptic
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels - Martina: 22 EC but super epileptic
patient(pID).ipsi_region(7).lfpnum = 34;%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 24;% PNAS_CA - Martina: 24 is very epileptic, removed but PNAS used this
patient(pID).ipsi_region(9).lfpnum = 13;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 35;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'LAmyd2', 'C126', 'C128', 'C127', 'C125', 'C124', 'C123', 'C122', 'C121', 'C120', 'C119', 'C118', 'C117', 'C114', 'C115', 'C116', 'C112', 'C113', 'C111', 'C110', 'C109', 'C108', 'C105', 'C104', 'C103', 'C102', 'C101', 'C107', 'C106', 'LAHd2', 'LAHd1', 'LAHd3', 'LMHd4', 'LPHd2', 'LAmyd3'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'LAmyd2', 'C126', 'C128', 'C127', 'C125', 'C124', 'C123', 'C122', 'C121', 'C120', 'C119', 'C118', 'C117', 'C114', 'C115', 'C116', 'C112', 'C113', 'C111', 'C110', 'C109', 'C108', 'C105', 'C104', 'C103', 'C102', 'C101', 'C107', 'C106', 'LAHd2', 'LAHd1', 'LAHd3', 'LMHd4', 'LPHd2', 'LAmyd3'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'LAHd3', 'LAHd2', 'C128', 'C127', 'C125', 'C126', 'C124', 'C121', 'C123', 'C122', 'C120', 'C119', 'C118', 'C117', 'C116', 'C114', 'C115', 'C113', 'C112', 'C111', 'C110', 'C107', 'C109', 'C108', 'C106', 'C105', 'C104', 'C103', 'RSRCH2', 'RSRCH1', 'RMHd3'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];
patient(pID).contra_region(2).lfpnum = [];
patient(pID).contra_region(3).lfpnum = [];
patient(pID).contra_region(4).lfpnum = [];
patient(pID).contra_region(5).lfpnum = [];
patient(pID).contra_region(6).lfpnum = [];
patient(pID).contra_region(7).lfpnum = [];
patient(pID).stimchan(1).num = 2;
patient(pID).stimchan(2).num = 3;
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];

pID = pID+1;
patient(pID).exp = 'Original';
patient(pID).name = 'amyg014';
patient(pID).syncfn  = 'day1_lfp_054.mat';
patient(pID).samprate =  499.70714;
patient(pID).ipsi_region(1).lfpnum = 21;%per Jon: 10=uncinate gyrus/head; 20=CA3/fimbria; 21=CA2; 32=CA1/2; 30,31=sub, per Joe via ROSA: 10 = head near both white matter and ventricle; 20=mid ST; 21*=mid ST; 30,31,32 = posterior 1/3 S-T...per DARPA: 10, 11, 12 = CA1/CA2; 21, 31, 32, 33 = CA1/CA3
patient(pID).ipsi_region(2).lfpnum = [];%per Jon: no DG...per DARPA: 20 = DG
patient(pID).ipsi_region(3).lfpnum = [];%per Jon: no PHG
patient(pID).ipsi_region(4).lfpnum = [1,2];%stimulated channels = 1 & 2
patient(pID).ipsi_region(5).lfpnum = [21,10,20,30,31,32];%region 5 = all possible hippocampus electrodes; see above for notes
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 21;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = [];%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = [];%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'LOFMed7', 'LOFLd9', 'LOFMid1', 'LMHd4', 'LAmyd2', 'LAmyd1', 'LMHd2', 'LAHd2', 'LAHd1', 'LMHd1', 'LPHd3', 'LPHd2'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'LOFMed7', 'LOFLd9', 'LOFMid1', 'LMHd4', 'LAmyd2', 'LAmyd1', 'LMHd2', 'LAHd2', 'LAHd1', 'LMHd1', 'LPHd3', 'LPHd2'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'LOFLd9', 'LMHd1', 'LMHd2', 'LAHd1', 'LAHd2', 'LAmyd1', 'LPHd3', 'LPHd2', 'RAmyd1'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];
patient(pID).contra_region(2).lfpnum = [];
patient(pID).contra_region(3).lfpnum = [];
patient(pID).contra_region(4).lfpnum = [];
patient(pID).contra_region(5).lfpnum = [];
patient(pID).contra_region(6).lfpnum = [];
patient(pID).contra_region(7).lfpnum = [];
patient(pID).stimchan(1).num = 1;
patient(pID).stimchan(2).num = 2;
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];

%%% day2 edf file doesn't exist for this patient
pID = pID+1;
patient(pID).exp = 'Original';
patient(pID).name = 'amyg015';
patient(pID).syncfn  = 'day1_lfp_010.mat';
patient(pID).samprate =  499.70714;%based on EDFbrowser and feedback from EMU director (via Cory) to use this rather than 500
patient(pID).ipsi_region(1).lfpnum = 14;%per Jon: 14 = CA1, 13 = CA3/DG, 22=subiculum;per DARPA: 14 =  CA1; 12=subiculum, per Joe via ROSA: 12 = ant body; 13* = ant body; 14 = ant body close to ventricle; 22 = mid S-T
patient(pID).ipsi_region(2).lfpnum = 12;%per Jon: 12 = DG, 13 = CA3/DG, per DARPA: 13 = DG
patient(pID).ipsi_region(3).lfpnum = 31;%per Jon:11=parasubiculum/entorhinal, 21=presubiculum,  23=PHG white matter near CA1, 31=PHG, 33,34=PHG/white matter, ...per DARPA: 23 = perirhinal ctx; 31, 34 = parahippocampal ctx; 11 = entorhinal cortex
patient(pID).ipsi_region(4).lfpnum = 2;%stimulated channels = 1 [a] & 2 [c]
patient(pID).ipsi_region(5).lfpnum = [13,12,14,22];%region 5 = all possible hippocampus electrodes; see above for note
patient(pID).ipsi_region(6).lfpnum = 11; %entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = 23;%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'LAmyd10', 'LATs1', 'LAmyd9', 'LAmyd2', 'LAmyd3', 'LAHd3', 'LAHd2', 'LAmyd1', 'LAHd1', 'LAHd4', 'LMHd3', 'LMHd2', 'LMHd1', 'RAHd9', 'LMHd7'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'LAmyd10', 'LATs1', 'LAmyd9', 'LAmyd2', 'LAmyd3', 'LAHd3', 'LAHd2', 'LAmyd1', 'LAHd1', 'LAHd4', 'LMHd3', 'LMHd2', 'LMHd1', 'RAHd9', 'LMHd7'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];
patient(pID).contra_region(2).lfpnum = [];
patient(pID).contra_region(3).lfpnum = [];
patient(pID).contra_region(4).lfpnum = [];
patient(pID).contra_region(5).lfpnum = [];
patient(pID).contra_region(6).lfpnum = [];
patient(pID).contra_region(7).lfpnum = [];
patient(pID).stimchan(1).num = 1;
patient(pID).stimchan(2).num = 2;
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];

pID = pID+1;
patient(pID).exp = 'Original';
patient(pID).name = 'amyg016';
patient(pID).syncfn  = 'day1_lfp_060.mat';
patient(pID).samprate =  999.41211;
patient(pID).ipsi_region(1).lfpnum = [];%per Jon: no ipsi hippocampus, DG, PHG; 
patient(pID).ipsi_region(2).lfpnum = [];
patient(pID).ipsi_region(3).lfpnum = [];
patient(pID).ipsi_region(4).lfpnum = [66,67];%stimulated channels = 66 [c] & 67 [a]
patient(pID).ipsi_region(5).lfpnum = [];%region 5 = all possible hippocampus electrodes; see above for notes
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = [];% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = [];%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = [];%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 66;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'L1d1', 'L1d5', 'L3d1', 'L5d9', 'L7d3', 'L7d7', 'L17d1', 'L13d5', 'R4d1', 'L17d7', 'L19d5', 'LSPs7', 'RFPs5', 'C128', 'C127', 'C126', 'C125', 'C124', 'C123', 'C122', 'C121', 'C120', 'C119', 'R4d3', 'L25d9'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'L1d1', 'L1d5', 'L3d1', 'L5d9', 'L7d3', 'L7d7', 'L17d1', 'L13d5', 'R4d1', 'L17d7', 'L19d5', 'LSPs7', 'RFPs5', 'C128', 'C127', 'C126', 'C125', 'C124', 'C123', 'C122', 'C121', 'C120', 'C119', 'R4d3', 'L25d9'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'L11d9', 'L17d1', 'L13d5', 'LSPs7', 'LSPs5', 'C128', 'C127', 'C126', 'C125', 'C124', 'C123', 'C122', 'C121', 'C120', 'C119', 'L25d9'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];
patient(pID).contra_region(2).lfpnum = [];
patient(pID).contra_region(3).lfpnum = [];
patient(pID).contra_region(4).lfpnum = [];
patient(pID).contra_region(5).lfpnum = [];
patient(pID).contra_region(6).lfpnum = [];
patient(pID).contra_region(7).lfpnum = [];
patient(pID).stimchan(1).num = 66;
patient(pID).stimchan(2).num = 67;
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];

pID = pID+1;
patient(pID).exp = 'Original';
patient(pID).name = 'amyg017';
patient(pID).syncfn  = 'day1_lfp_017.mat';
patient(pID).samprate =  499.70714;
patient(pID).ipsi_region(1).lfpnum = [];%per Jon: 1=ambient gyrus of uncus; 21=ventricle near head of hip; 22=ventricle above CA2...per DARPA: 11, 12, 13, 21, 22, 23 = CA1; 11 is noisy
patient(pID).ipsi_region(2).lfpnum = [];%per Jon: no DG
patient(pID).ipsi_region(3).lfpnum = [];%per Jon:  PHG...per DARPA: 1 = entorhinal cortex; 25 = perirhinal cortex
patient(pID).ipsi_region(4).lfpnum = [2,3];%stimulated channels = 2[a] & 3 [c] -- put cathode here!
patient(pID).ipsi_region(5).lfpnum = 1;%region 5 = all possible hippocampus electrodes; see above for notes
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = 25;%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 1;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = [];%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 25;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 3;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'L1d3', 'L3d1', 'L3d7', 'L3d8', 'C128', 'C127', 'C126', 'C125', 'C124', 'C123', 'C122', 'C121', 'C120', 'C119', 'C118', 'C116', 'C117', 'C113', 'C115', 'C114', 'C112', 'C111', 'C105', 'C106', 'C107', 'C108', 'C109', 'C110', 'R4d8', 'R10d5', 'RFs6', 'R4d1', 'R10d10', 'L1d10', 'L1d2', 'R2d9'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'L1d3', 'L3d1', 'L3d7', 'L3d8', 'C128', 'C127', 'C126', 'C125', 'C124', 'C123', 'C122', 'C121', 'C120', 'C119', 'C118', 'C116', 'C117', 'C113', 'C115', 'C114', 'C112', 'C111', 'C105', 'C106', 'C107', 'C108', 'C109', 'C110', 'R4d8', 'R10d5', 'RFs6', 'R4d1', 'R10d10', 'L1d10', 'L1d2', 'R2d9'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'L3d7', 'L3d8', 'C128', 'C127', 'C126', 'C125', 'C124', 'C123', 'C122', 'C121', 'C120', 'C119', 'C118', 'C115', 'C117', 'C116', 'C112', 'C114', 'C113', 'C111', 'C110', 'C109', 'C108', 'C107', 'C106', 'C105', 'R10d5', 'R6d1', 'R10d10', 'R4d1', 'R2d9', 'RFs6', 'R4d8', 'R10d3', 'R10d4', 'L3d1', 'L1d10', 'R2d1', 'R2d2'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];
patient(pID).contra_region(2).lfpnum = [];
patient(pID).contra_region(3).lfpnum = [];
patient(pID).contra_region(4).lfpnum = [];
patient(pID).contra_region(5).lfpnum = [];
patient(pID).contra_region(6).lfpnum = [];
patient(pID).contra_region(7).lfpnum = [];
patient(pID).stimchan(1).num = 2;
patient(pID).stimchan(2).num = 3;
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                  AMME DURATION PATIENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%Martina's method choosing lfp channels for patients:
%  in the patient_anat_labels file edited by Griffin we have the lfp channels for each electrode according to EDF browser
%  Lou's segmentation is the 'fs_aparcaseg' column where he looked for signal in that 5mm radius sphere around the electrode
% 'fs_aparaseg_proper' is freesurfer-based exact location of the electrode
%  based on these info, Martina double checked every MTL channel location in the raw MRI files. 
%  for CA1, DG, etc Martina used a combination of Mai atlas, ASHS, and FS60 MTL segmentations

%bilateral stimulation - taking the left side only?
pID = pID+1;
patient(pID).exp = 'Duration';
patient(pID).name = 'amyg030'; % log filename stays this way, because the unilateral (R) is marked as 'unilateral'
patient(pID).syncfn = 'day1bilateral_lfp_106.mat';
patient(pID).samprate = 1023.999;
patient(pID).ipsi_region(1).lfpnum = 99; %hippocampal CA fields - Martina: 3 (2Rd2) in CA1, maybe 4 (2Rd4) but mainly in wm, 99 (3Ld2)in CA1/CA3 (possibly DG too)
patient(pID).ipsi_region(2).lfpnum = 100; % dentate gyrus - Martina: 100 (3Ld3) DG
patient(pID).ipsi_region(3).lfpnum = []; %parahippocampal gyrus 
patient(pID).ipsi_region(4).lfpnum = [88,89]; % bilateral stim: stimulated channels 1Ld1 (88) [a], 1Ld2 (89) [c]
patient(pID).ipsi_region(5).lfpnum = [10, 40, 41, 98, 101];%all hippocampal regions - Martina: 98 (3Ld1) subiculum, 101 (3Ld4) CA1/DG boundary 
patient(pID).ipsi_region(6).lfpnum = [];%entorhinal cortex channels - Martina: NAN
patient(pID).ipsi_region(7).lfpnum = [];%perirhinal cortex channels - Martina: NAN
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'6Rd4', 'C122', 'OSAT', 'C121', 'C119', 'C123', 'C120', 'C118', 'C117', 'C127', 'C126', 'C128', 'C124', 'C125', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'DC16', 'DC15', 'DC14', 'DC13', 'DC12', 'DC11', 'DC10', 'DC9', 'DC8', 'DC7', 'DC6', 'Pleth', 'PR', 'TRIG', '3Ld10', '1Ld3', '1Ld2', '1Ld1', '8Rd8', '8Rd9', '8Rd10', '8Rd7', '12Rd3', '12Rd2', '18Rd10', '2Rd1', '2Rd2', '2Rd3', '2Rd4', '2Rd6', '2Rd5', '2Rd7', '2Rd8', '4Rd7'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'6Rd4', 'C122', 'OSAT', 'C121', 'C119', 'C123', 'C120', 'C118', 'C117', 'C127', 'C126', 'C128', 'C124', 'C125', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'DC16', 'DC15', 'DC14', 'DC13', 'DC12', 'DC11', 'DC10', 'DC9', 'DC8', 'DC7', 'DC6', 'Pleth', 'PR', 'TRIG', '3Ld10', '1Ld3', '1Ld2', '1Ld1', '8Rd8', '8Rd9', '8Rd10', '8Rd7', '12Rd3', '12Rd2', '18Rd10', '2Rd1', '2Rd2', '2Rd3', '2Rd4', '2Rd6', '2Rd5', '2Rd7', '2Rd8', '4Rd7'}; % Channels that has to be removed before computing the median for phase = 2(Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'2Rd1', 'Pleth', 'PR', 'TRIG', 'OSAT', 'DC16', 'DC15', 'DC14', 'DC13', 'DC12', 'DC11', 'DC10', 'DC7', 'DC6', 'DC9', 'DC8', 'DC5', 'DC4', 'DC1', 'DC3', 'C127', 'C126', 'DC2', 'C128', 'C125', 'C123', 'C124', 'C121', 'C120', 'C119', 'C118', 'C117', 'C122', '3Ld10', '5Ld8', '8Rd7', '4Rd8', '4Rd7', '4Rd6', '4Rd5', '4Rd4', '4Rd3', '4Rd1', '2Rd8', '4Rd2', '2Rd7', '2Rd6', '2Rd5', '2Rd4', '2Rd3', '2Rd2'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [3,11];%hippocampal CA fields - Martina: 3 (2Rd2) in CA1, maybe 4 (2Rd4) but mainly in wm,
patient(pID).contra_region(2).lfpnum = 2;% dentate gyrus - Martina: 2 (Rd1)DG
patient(pID).contra_region(3).lfpnum = 38;%parahippocampal gyrus - Martina: 38 (10Rd1) in PHC gray matter, 39 (10Rd2) in cingulum wm
patient(pID).contra_region(4).lfpnum = [48,49]; % bilateral stim: stimulated channels 12Rd2 (48) [c], 12Rd3 (49) [a]
patient(pID).contra_region(5).lfpnum = []; %all hippocampal regions - Martina: 10 (4Rd1) subiculum/CA1, 12 (4Rd3) in wm close to CA1, 40 (10Rd3) posterior CA1/subiculum boundary, 41 (10Rd4) posterior CA1/DG boundary
patient(pID).contra_region(6).lfpnum = [];%entorhinal cortex channels - Martina: NAN
patient(pID).contra_region(7).lfpnum = [];%perirhinal cortex channels - Martina: NAN
patient(pID).stimchan(1).num = 88; %1Ld1 [a]
patient(pID).stimchan(2).num = 89; %1Ld2 [c]
patient(pID).stimchan(3).num = 48; %12Rd2 [c]
patient(pID).stimchan(4).num = 49; %12Rd3 [a]

pID = pID+1;
patient(pID).exp = 'Duration'; %no imm test on any recording
patient(pID).name = 'amyg033';
patient(pID).syncfn = 'day1_lfp_100.mat';
patient(pID).samprate = 1024.004;
patient(pID).ipsi_region(1).lfpnum = [23,14]; %hippocampal CA fields - Martina: 14 (4Rd3) CA1/DG, 23 (6Rd2) CA1
patient(pID).ipsi_region(2).lfpnum= []; %dentate gyrus
patient(pID).ipsi_region(3).lfpnum = []; %parahippocampal gyrus
patient(pID).ipsi_region(4).lfpnum = [2,3]; %stimulated channels 2 [c] and 3 [a]
patient(pID).ipsi_region(5).lfpnum= [13,14,22,23,62]; %all hippocampal regions - Martina: 13 (4Rd2) subiculum, 22 (6Rd1) subiculum, 62 (14Rd1) subiculum, 171 (36Rd1) cingulum wm/parasubiculum/ERC, 172 (36Rd2) cingulum wm/CA1
patient(pID).ipsi_region(6).lfpnum = 12; %entorhinal cortex channels - Martina: 12 (4Rd1) ERC and presubiculum boundary
patient(pID).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'4Rd8', '6Rd6', '8Rd10', '20Rd10', '24Rd10', '22Rd6', '26Rd10', '30Rd1', '22Rd1', '20Rd8', '20Rd7', '32Rd9', '34Rd1', '34Rd10', '34Rd7', 'C240', 'C239', 'C238', 'C237', 'C236', 'C235', 'C234', 'C232', 'C231', 'C233', 'C230', 'C228', 'C229', 'C227', 'C226', 'C225', 'C223', 'C222', 'C224', 'C221', 'C220', 'C219', 'C218', 'C217', 'C216', 'C215', 'C214', 'C213', 'C211', 'C210', 'C212', 'C209', 'C208', 'C205', 'C207', 'C206', 'C204', 'C203', 'C202', 'C201', 'C200', 'Pleth', 'PR', 'TRIG', 'DC15', 'DC14', 'DC16', 'DC13', 'DC11', 'DC10', 'DC9', 'DC8', 'DC12', 'OSAT', 'DC7', 'DC6', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'C255', 'C256', 'C254', 'C253', 'C252', 'C251', 'C250', 'C247', 'C246', 'C245', 'C244', 'C243', 'C242', 'C241', 'C249', 'C248', '36Rd8', '36Rd9', '36Rd7', '28Rd10', '28Rd9', '28Rd8', '2Rd3', '2Rd2', '2Rd4'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'4Rd8', '6Rd6', '8Rd10', '20Rd10', '24Rd10', '22Rd6', '26Rd10', '30Rd1', '22Rd1', '20Rd8', '20Rd7', '32Rd9', '34Rd1', '34Rd10', '34Rd7', 'C240', 'C239', 'C238', 'C237', 'C236', 'C235', 'C234', 'C232', 'C231', 'C233', 'C230', 'C228', 'C229', 'C227', 'C226', 'C225', 'C223', 'C222', 'C224', 'C221', 'C220', 'C219', 'C218', 'C217', 'C216', 'C215', 'C214', 'C213', 'C211', 'C210', 'C212', 'C209', 'C208', 'C205', 'C207', 'C206', 'C204', 'C203', 'C202', 'C201', 'C200', 'Pleth', 'PR', 'TRIG', 'DC15', 'DC14', 'DC16', 'DC13', 'DC11', 'DC10', 'DC9', 'DC8', 'DC12', 'OSAT', 'DC7', 'DC6', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'C255', 'C256', 'C254', 'C253', 'C252', 'C251', 'C250', 'C247', 'C246', 'C245', 'C244', 'C243', 'C242', 'C241', 'C249', 'C248', '36Rd8', '36Rd9', '36Rd7', '28Rd10', '28Rd9', '28Rd8', '2Rd3', '2Rd2', '2Rd4'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'2Rd4', '4Rd8', '8Rd10', '20Rd10', '22Rd1', '16Rd9', '22Rd6', '24Rd10', '26Rd10', 'Pleth', 'PR', 'OSAT', 'TRIG', 'DC16', 'DC14', 'DC15', 'DC13', 'DC12', 'DC10', 'DC11', 'DC9', 'DC8', 'DC7', 'DC6', 'DC5', 'DC3', 'DC4', 'DC2', 'DC1', 'C256', 'C255', 'C254', 'C253', 'C251', 'C250', 'C252', 'C249', 'C248', 'C247', 'C246', 'C245', 'C244', 'C243', 'C242', 'C241', 'C240', 'C239', 'C238', 'C237', 'C236', 'C235', 'C233', 'C234', 'C231', 'C230', 'C232', 'C229', 'C228', 'C227', 'C226', 'C225', 'C224', 'C223', 'C222', 'C221', 'C220', 'C219', 'C218', 'C217', 'C216', 'C215', 'C214', 'C213', 'C212', 'C211', 'C210', 'C209', 'C208', 'C207', 'C206', 'C205', 'C204', 'C203', 'C201', 'C200', 'C202', '34Rd1', '32Rd9', '34Rd7', '34Rd10', '30Rd1', '28Rd10', '28Rd9', '28Rd8', '36Rd9', '36Rd8', '20Rd7', '20Rd8', '18Rd8', '18Rd7', '18Rd10', '18Rd9', '6Rd6', '14Rd7'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];
patient(pID).contra_region(2).lfpnum = [];
patient(pID).contra_region(3).lfpnum = [];
patient(pID).contra_region(4).lfpnum = [];
patient(pID).contra_region(5).lfpnum = [];
patient(pID).contra_region(6).lfpnum = [];
patient(pID).contra_region(7).lfpnum = [];
patient(pID).stimchan(1).num = 2;%2Rd1 [c]
patient(pID).stimchan(2).num = 3;%2Rd2 [a]
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = []; 


%multiple runs, taking the novel session (L)
%LFP channels extracted from L stim session? not sure
%no imm test on any recording
pID = pID+1;
patient(pID).exp = 'Duration';
patient(pID).name = 'amyg034' ;%log file name stays this as the other stim hemi (R) is marked as 'Ramyg'
patient(pID).syncfn = 'day1_lfp_055.mat';
patient(pID).samprate = 1024.004;
patient(pID).ipsi_region(1).lfpnum = [11,19,20]; %hippocampal CA fields - Martina: 11 (3Ld3) CA1/DG boundary, 17 (5Ld1) CA3/ventricle, 18 (5Ld2) CA3/DG, 19 (5Ld3) CA2/CA1/DG, 20 (5Ld4) CA1/ventricle,
patient(pID).ipsi_region(2).lfpnum = 10; %dentate gyrus - Martina: 10 (3Ld2)
patient(pID).ipsi_region(3).lfpnum = []; %parahippocampal gyrus
patient(pID).ipsi_region(4).lfpnum = [2,3]; %stimulated channels 2 [c] and 3[a]
patient(pID).ipsi_region(5).lfpnum = [9,19,37]; %all hippocampal regions - Martina: 9 (3Ld1) subiculum, 
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = []; %perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'1Ld2', '3Ld3', '3Ld6', '6Rd10', '10Rd6', '12Rd4', '22Rd10', '20Rd9', 'DC10', 'DC8', 'DC7', 'DC9', 'DC6', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'C256', 'C255', 'C253', 'C252', 'C254', 'C250', 'C251', 'C248', 'C249', 'C247', 'C246', 'C245', 'C244', 'C243', 'C242', 'C241', 'C240', 'C239', 'C238', 'C237', 'C236', 'C235', 'C234', 'C233', 'C232', 'C231', 'C230', 'C229', 'C227', 'C226', 'C225', 'C228', 'C224', 'C223', 'C222', 'C221', 'C220', 'C219', 'C218', 'C217', 'C216', 'C215', 'C214', 'C212', 'C211', 'C210', 'C208', 'C207', 'C209', 'C213', 'C206', 'C205', 'C204', 'C203', 'C202', 'C201', 'C198', 'C200', 'C197', 'C199', 'C196', 'C195', '30Rd5', '30Rd4', '10Rd8', '10Rd7', '2Rd4', '1Ld7', '1Ld3'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'1Ld2', '3Ld3', '3Ld6', '6Rd10', '10Rd6', '12Rd4', '22Rd10', '20Rd9', 'DC10', 'DC8', 'DC7', 'DC9', 'DC6', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'C256', 'C255', 'C253', 'C252', 'C254', 'C250', 'C251', 'C248', 'C249', 'C247', 'C246', 'C245', 'C244', 'C243', 'C242', 'C241', 'C240', 'C239', 'C238', 'C237', 'C236', 'C235', 'C234', 'C233', 'C232', 'C231', 'C230', 'C229', 'C227', 'C226', 'C225', 'C228', 'C224', 'C223', 'C222', 'C221', 'C220', 'C219', 'C218', 'C217', 'C216', 'C215', 'C214', 'C212', 'C211', 'C210', 'C208', 'C207', 'C209', 'C213', 'C206', 'C205', 'C204', 'C203', 'C202', 'C201', 'C198', 'C200', 'C197', 'C199', 'C196', 'C195', '30Rd5', '30Rd4', '10Rd8', '10Rd7', '2Rd4', '1Ld7', '1Ld3'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'1Ld3', '3Ld3', '3Ld6', '2Rd4', '6Rd10', '10Rd7', '10Rd6', 'Pleth', 'OSAT', 'TRIG', 'DC16', 'DC15', 'DC13', 'DC14', 'PR', 'DC12', 'DC11', 'DC10', 'DC9', 'DC8', 'DC7', 'DC6', 'DC5', 'DC4', 'DC2', 'DC1', 'C256', 'DC3', 'C254', 'C253', 'C255', 'C252', 'C251', 'C250', 'C248', 'C247', 'C246', 'C244', 'C243', 'C241', 'C238', 'C240', 'C239', 'C242', 'C245', 'C249', 'C237', 'C236', 'C235', 'C234', 'C233', 'C232', 'C231', 'C230', 'C229', 'C228', 'C227', 'C225', 'C224', 'C226', 'C221', 'C220', 'C222', 'C223', 'C219', 'C218', 'C215', 'C214', 'C217', 'C216', 'C211', 'C210', 'C208', 'C209', 'C207', 'C206', 'C205', 'C204', 'C202', 'C201', 'C200', 'C203', 'C213', 'C212', 'C199', 'C198', 'C196', 'C197', 'C195', '22Rd10', '28Rd6', '28Rd10', '22Rd6', '3Ld2', '3Ld1', '5Ld2', '5Ld1'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [40,49]; %hippocampal CA fields - Martina: 40 (4Rd4) CA1/ventricle boundary, 49 (6Rd3) CA1/DG boundary
patient(pID).contra_region(2).lfpnum = [38,39];%dentate gyrus - Martina: 38 (4Rd2) DG, 39 (4Rd3) DG/CA1 boundary
patient(pID).contra_region(3).lfpnum = []; %parahippocampal gyrus
patient(pID).contra_region(4).lfpnum = [28,29];
patient(pID).contra_region(5).lfpnum = 37; %all hippocampal regions - Martina:37 (4Rd1) subiculum/DG/CA1 boundary
patient(pID).contra_region(6).lfpnum = [];%entorhinal cortex channels
patient(pID).contra_region(7).lfpnum = [];%perirhinal cortex channels
patient(pID).stimchan(1).num = 2; %1Ld2 [c]
patient(pID).stimchan(2).num = 3; %1Ld3 [a]
patient(pID).stimchan(3).num = 28; %2Rd2 [c] session 2 stimulation
patient(pID).stimchan(4).num = 29; %2Rd3 [a] session 2 stimulation

pID = pID+1;
patient(pID).exp = 'Duration';
patient(pID).name = 'amyg037';
patient(pID).syncfn = 'day1_lfp_069.mat' ;%no lfp datafile on Rolston server
patient(pID).samprate = 1023.999;
patient(pID).ipsi_region(1).lfpnum = [28,11,12,21]; %hippocampal CA fields - Martina: 28 (7Ld2) dorsolateral CA1, above PRG, 11 (3Ld2) CA1, 12 (3Ld3) CA1/DG, 20 (5Ld2) CA3/subiculum/CA1, 21 (5Ld3) CA1 (some DG)
patient(pID).ipsi_region(2).lfpnum = []; %dentate gyrus - Martina: 117 (2Rd3) DG 
patient(pID).ipsi_region(3).lfpnum = []; %parahippocampal gyrus
patient(pID).ipsi_region(4).lfpnum = [2,3]; %stimulated channels 2 1Ld1[c] and 3 1Ld2[a]
patient(pID).ipsi_region(5).lfpnum = [11,12,20,21,28]; %all hippocampal regions-Martina: 19 (5Ld1) subiculum/DG
patient(pID).ipsi_region(6).lfpnum = [98,99]; %entorhinal cortex - Martina: 98 (23Ld1) ERC, 99 (23Ld2) ERC/PRC boundary
patient(pID).ipsi_region(7).lfpnum = 14;%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'1Ld1', '1Ld7', '5Ld1', '5Ld4', '11Ld1', '13Ld1', '15Ld8', '15Ld7', '15Ld9', '17Ld5', '17Ld6', '1Ld2', '5Ld2', '3Ld3', '3Ld2', '3Ld1', '5Ld3', '3Ld4', 'DC15', 'DC13', 'DC16', 'TRIG', 'DC14', 'DC11', 'DC10', 'DC12', 'DC9', 'DC8', 'DC7', 'DC6', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'Pleth', 'PR', 'OSAT', '21Ld5', '25Ld6', '6Rd1', 'EKG2', 'EKG1', '21Ld7', '2Rd1', '2Rd3', '4Rd3', '4Rd1', '6Rd3', '19Ld5', '23Ld1', '4Rd5'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {'1Ld1', '1Ld7', '5Ld1', '5Ld4', '11Ld1', '13Ld1', '15Ld8', '15Ld7', '15Ld9', '17Ld5', '17Ld6', '1Ld2', '5Ld2', '3Ld3', '3Ld2', '3Ld1', '5Ld3', '3Ld4', 'DC15', 'DC13', 'DC16', 'TRIG', 'DC14', 'DC11', 'DC10', 'DC12', 'DC9', 'DC8', 'DC7', 'DC6', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'Pleth', 'PR', 'OSAT', '21Ld5', '25Ld6', '6Rd1', 'EKG2', 'EKG1', '21Ld7', '2Rd1', '2Rd3', '4Rd3', '4Rd1', '6Rd3', '19Ld5', '23Ld1', '4Rd5'}; % Channels that has to be removed before computing the median for phase = 2 (Day1_ImmTest)
patient(pID).phase(3).removeChannels.names = {'1Ld7', '5Ld4', '11Ld1', '3Ld2', '3Ld3', '3Ld1', '5Ld2', '5Ld1', '15Ld8', '15Ld7', '13Ld2', '13Ld1', '15Ld9', '1Ld3', '17Ld5', '17Ld9', '13Ld4', '5Ld5', '5Ld3', 'DC15', 'TRIG', 'DC16', 'DC14', 'DC13', 'DC11', 'DC9', 'DC8', 'DC12', 'DC10', 'DC7', 'DC6', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'EKG2', 'EKG1', 'Pleth', 'PR', 'OSAT', '6Rd1', '21Ld5', '25Ld6', '19Ld5', '6Rd3', '2Rd3', '2Rd1', '4Rd3', '4Rd5', '4Rd1', '6Rd5'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = 121;%hippocampal CA fields - Martina:116 (2Rd1) CA3/DG, 121 (4Rd3) CA1/DG boundary
patient(pID).contra_region(2).lfpnum = 117;%DG
patient(pID).contra_region(3).lfpnum = [];%PHG
patient(pID).contra_region(4).lfpnum = [];%amygdala stim
patient(pID).contra_region(5).lfpnum = [116,117,120,121];%all HPC- Martina: 120 (4Rd1) subiculum,
patient(pID).contra_region(6).lfpnum = [];%EC
patient(pID).contra_region(7).lfpnum = [];%PRC
patient(pID).stimchan(1).num = 2;%1Ld1 [c]
patient(pID).stimchan(2).num = 3;%1Ld2 [a]
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = []; 


%%% No usable data for this patient
% patient(18).exp = 'Duration';
% patient(18).name = 'amyg042';  %log filename is this because the other side (L) has no hippocampus
% patient(18).syncfn = 'day1_lfp_161.mat';
% patient(18).samprate = 1024.004;
% patient(18).ipsi_region(1).lfpnum = [123, 131]; %hippocampal CA fields - Martina: 123 (2Rd3) CA1, 131 (4Rd3) posterior CA1
% patient(18).ipsi_region(2).lfpnum = [121, 122,]; %dentate gyrus - Martina: 121 (2Rd1) DG, 122 (2Rd2) DG/CA1,
% patient(18).ipsi_region(3).lfpnum = 129; %parahippocampal gyrus - Martina: 129 (4Rd1) PRG
% patient(18).ipsi_region(4).lfpnum = [138,139]; %stimulated channels
% patient(18).ipsi_region(5).lfpnum = 130; %all hippocampal regions - Martina: 130 (4Rd2) posterior subiculum/DG
% patient(18).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
% patient(18).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
% patient(pID).phase(1).removeChannels.names = {}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
% patient(pID).phase(2).removeChannels.names = {}; % no imm test for this subject, leave blank
% patient(pID).phase(3).removeChannels.names = {}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
% patient(18).contra_region(1).lfpnum = [];
% patient(18).contra_region(2).lfpnum = [];%DG
% patient(18).contra_region(3).lfpnum = [];%PHG
% patient(18).contra_region(4).lfpnum = [2,3];%amygdala stim
% patient(18).contra_region(5).lfpnum = [];%all HPC
% patient(18).contra_region(6).lfpnum = [];%EC
% patient(18).contra_region(7).lfpnum = [];%PRC
% patient(18).stimchan(1).num = 138; %6Rd2 [c]
% patient(18).stimchan(2).num = 139;%6Rd3 [a]
% patient(18).stimchan(3).num = 2; %1Ld2 [c]
% patient(18).stimchan(4).num = 3; %1Ld3 [a]


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                  AMME TIMING PATIENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%% taking the first novel session when subject has multiple sessions %%%%
pID = pID+1;
patient(pID).exp = 'Timing';
patient(pID).name = 'amyg045'; %has to be EXACTLY what the log file says - doing Left Amyg, log filename is 'amyg045_Lamyg'
patient(pID).syncfn  = 'day1Lamyg_lfp_062.mat'; %looking at L stim 
patient(pID).samprate = 1024.004;%based on EDFbrowser 
patient(pID).ipsi_region(1).lfpnum = [14, 15, 24, 13];%hippocampal CA fields - Martina: 14 (3Ld3) CA1/DG, 15 (3Ld4) CA1/TLateralVentricle, 24 (5Ld3) CA1/CA2/CA3/HP molecular layer
patient(pID).ipsi_region(2).lfpnum = [];%dentate gyrus 
patient(pID).ipsi_region(3).lfpnum = [108, 109];%parahippocampal gyrus - Martina: 108 (25Ld1) parahippocampal cortex, 109 (25Ld2) parahippocampal cortex/cingulate wm
patient(pID).ipsi_region(4).lfpnum = [4,58];%amygdala stim channels
patient(pID).ipsi_region(5).lfpnum = [12,13,14,15,23];%all hippocampal - Martina: 12 (3Ld1) presubiculum/parasubiculum/CA1, 13 (3Ld2) CA1/subiculum/DG, 22 (5Ld1) subiculum/presubiculum/DG, 23 (5Ld2) subiculum/CA1/CA4, 
patient(pID).ipsi_region(6).lfpnum = [2,3]; %entorhinal cortex channels - Martina: 2 (1Ld1) EC/Periamygdaloid cortex 
patient(pID).ipsi_region(7).lfpnum = [];%perirhinal cortex channels 
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'13Ld1', '1Ld3', '3Ld3', '3Ld1', '3Ld2', '5Ld2', '5Ld1', '13Ld7', 'EKG', 'C163', 'C216', 'C215', 'C214', 'C213', 'C212', 'C211', 'C210', 'C209', 'C208', 'C206', 'C205', 'C207', 'C203', 'C202', 'C204', 'C201', 'C200', 'C199', 'C198', 'C197', 'C196', 'C194', 'C193', 'C195', 'C191', 'C190', 'C192', 'C188', 'C187', 'C189', 'C186', 'C184', 'C183', 'C185', 'C180', 'C182', 'C181', 'C178', 'C179', 'C176', 'C175', 'C177', 'C174', 'C173', 'C172', 'C171', 'C170', 'C169', 'C168', 'C167', 'C166', 'C165', 'C164', 'C162', 'C161', 'Pleth', 'DC16', 'TRIG', 'DC15', 'DC14', 'DC13', 'DC12', 'DC11', 'DC10', 'DC7', 'DC9', 'DC8', 'DC6', 'DC5', 'OSAT', 'PR', 'DC4', 'DC3', 'DC2', 'DC1', 'C256', 'C254', 'C253', 'C255', 'C251', 'C250', 'C252', 'C249', 'C248', 'C246', 'C245', 'C247', 'C242', 'C241', 'C243', 'C244', 'C240', 'C238', 'C237', 'C239', 'C236', 'C235', 'C233', 'C234', 'C231', 'C232', 'C230', 'C229', 'C227', 'C226', 'C228', 'C225', 'C224', 'C223', 'C222', 'C221', 'C218', 'C219', 'C220', 'C217'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {}; % no imm test for this subject, leave blank
patient(pID).phase(3).removeChannels.names = {'13Ld7', 'Pleth', 'PR', 'DC15', 'DC13', 'OSAT', 'TRIG', 'DC14', 'DC16', 'DC11', 'DC10', 'DC12', 'DC8', 'DC7', 'DC9', 'DC6', 'DC5', 'DC4', 'DC3', 'DC1', 'C256', 'DC2', 'C254', 'C253', 'C252', 'C255', 'C251', 'C250', 'C249', 'C248', 'C247', 'C246', 'C245', 'C244', 'C243', 'C242', 'C241', 'C240', 'C239', 'C238', 'C237', 'C236', 'C235', 'C234', 'C233', 'C232', 'C231', 'C230', 'C229', 'C228', 'C227', 'C226', 'C225', 'C223', 'C222', 'C221', 'C224', 'C220', 'C219', 'C218', 'C217', 'C216', 'C215', 'C214', 'C213', 'C212', 'C211', 'C210', 'C209', 'C208', 'C207', 'C206', 'C205', 'C204', 'C203', 'C202', 'C201', 'C199', 'C198', 'C196', 'C200', 'C195', 'C194', 'C193', 'C197', 'C192', 'C191', 'C190', 'C189', 'C188', 'C187', 'C186', 'C185', 'C184', 'C183', 'C182', 'C181', 'C180', 'C179', 'C178', 'C177', 'C175', 'C174', 'C173', 'C172', 'C171', 'C170', 'C176', 'C169', 'C168', 'C167', 'C166', 'C165', 'C164', 'C163', 'C162', 'C161', 'EKG'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = 145;%hippocampal CA fields - Martina:145 (4Rd4) CA1/cingulum wm/subiculum/PRC
patient(pID).contra_region(2).lfpnum = [];%DG
patient(pID).contra_region(3).lfpnum = [];%PHG
patient(pID).contra_region(4).lfpnum = [2,3];%amygdala stim
patient(pID).contra_region(5).lfpnum = 144;%all HPC- Martina: 144 (4Rd3) subiculum/CA1/DG
patient(pID).contra_region(6).lfpnum = [142,143];%entorhinal cortex channels - Martina:142 (4Rd1) parasubiculum/EC/uncal notch, 143 (4Rd2) EC/presubiculum/ cingulum wm
patient(pID).contra_region(7).lfpnum = 146;%perirhinal cortex channels - Martina: 146 (4Rd5) PRC
patient(pID).stimchan(1).num = 4; %1Ld3 [a]
patient(pID).stimchan(2).num = 58; %13Ld2 [c]
patient(pID).stimchan(3).num = 2; %2Rd2 [c]
patient(pID).stimchan(4).num = 3; %2Rd3 [a]

pID = pID+1;
patient(pID).exp = 'Timing';
patient(pID).name = 'amyg046' ; %has to be EXACTLY what the log file says - Martina changed file name from amyg046_Lamyg to amyg046. 'Lamyg' was redundant info as only that hemi was stimulated
patient(pID).syncfn  = 'day1_lfp_048.mat';
patient(pID).samprate = 1024.004;%based on EDFbrowser 
patient(pID).ipsi_region(1).lfpnum = [];%hippocampal CA fields 
patient(pID).ipsi_region(2).lfpnum = 8;%dentate gyrus - 8 (3Ld3) DG/CA1
patient(pID).ipsi_region(3).lfpnum = [];%parahippocampal gyrus
patient(pID).ipsi_region(4).lfpnum = 3;%stim channels 3[c] and NaN[a]
patient(pID).ipsi_region(5).lfpnum = 8; % all hippocampal regions
patient(pID).ipsi_region(6).lfpnum = [7,2]; %entorhinal cortex channels - Martina: 2 (1Ld1) EC/BLVM amyg, 7 (3Ld1) EC/subiculum
patient(pID).ipsi_region(7).lfpnum = 9;%perirhinal cortex channels - Martina: 9 (3Ld5) PRC/ cignulum wm
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'4Rd8', '6Rd10', '8Rd4', '10Rd2', '10Rd3', '10Rd1', '10Rd10', '16Rd5', '16Rd3', '16Rd1', '1Ld3', '1Ld1', '12Rd1', '12Rd2', '12Rd4', '12Rd7', '12Rd6', '28Rd5', 'DC16', 'DC15', 'OSAT', 'TRIG', 'Pleth', 'PR', 'DC14', 'DC12', 'DC10', 'DC9', 'DC13', 'DC11', 'DC6', 'DC8', 'DC7', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'C256', 'C255', 'C254', 'C252', 'C251', 'C250', 'C253', 'C249', 'C248', 'C247', 'C245', 'C244', 'C243', 'C242', 'C246', 'C241', 'C240', 'C239', 'C238', 'C237', 'C236', 'C231', 'C230', 'C229', 'C235', 'C234', 'C233', 'C232', 'C228', 'C227', 'C226', 'C225', 'C224', 'C223', 'C222', 'C221', 'C220', 'C219', 'C218', 'C217', 'C216', 'C215', 'C214', 'C213', 'C212', 'C211', 'C210', 'C209', 'C208', 'C207', 'C206', 'C205', 'C204', 'C203', 'C202', 'C201', 'C200', 'C197', 'C196', 'C195', 'C199', 'C198', 'C194', 'C193', 'C192', 'C190', 'C189', 'C188', 'C187', 'C191', 'C186', 'C185', 'C184', 'C183', 'C182', 'C181', 'C180', 'C175', 'C173', 'C179', 'C178', 'C177', 'C174', 'C172', 'C171', 'C176', 'EKG2', 'EKG1', '42Rd10', '42Rd9', '30Rd1'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {}; % no imm test for this subject, leave blank
patient(pID).phase(3).removeChannels.names = {'4Rd8', '6Rd10', '8Rd4', '10Rd3', '10Rd2', '10Rd1', '12Rd1', '10Rd10', '16Rd1', '28Rd5', '30Rd1', '42Rd9', 'DC15', 'DC14', 'DC13', 'TRIG', 'DC12', 'DC11', 'DC7', 'DC10', 'Pleth', 'DC16', 'PR', 'OSAT', 'DC6', 'DC9', 'DC5', 'DC4', 'DC8', 'DC3', 'DC2', 'DC1', 'C254', 'C256', 'C255', 'C252', 'C253', 'C250', 'C251', 'C248', 'C247', 'C249', 'C246', 'C245', 'C244', 'C243', 'C242', 'C240', 'C239', 'C241', 'C237', 'C238', 'C235', 'C234', 'C236', 'C233', 'C232', 'C230', 'C231', 'C229', 'C228', 'C227', 'C226', 'C225', 'C223', 'C222', 'C224', 'C219', 'C221', 'C220', 'C218', 'C217', 'C216', 'C215', 'C213', 'C214', 'C212', 'C211', 'C210', 'C209', 'C207', 'C208', 'C206', 'C205', 'C204', 'C203', 'C202', 'C201', 'C200', 'C199', 'C197', 'C198', 'C195', 'C196', 'C192', 'C194', 'C193', 'C190', 'C191', 'C189', 'C188', 'C187', 'C186', 'C185', 'C184', 'C183', 'C182', 'C181', 'C180', 'C178', 'C179', 'C177', 'C176', 'C175', 'C174', 'C173', 'C172', 'C171', '42Rd10', 'EKG2', 'EKG1'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = 96;%hippocampal CA fields - Martina: 96 (28Rd2) posterior CA1
patient(pID).contra_region(2).lfpnum = [];%DG
patient(pID).contra_region(3).lfpnum = [];%PHG
patient(pID).contra_region(4).lfpnum = [];%amygdala stim
patient(pID).contra_region(5).lfpnum = [];%all HPC
patient(pID).contra_region(6).lfpnum = [];%EC
patient(pID).contra_region(7).lfpnum = [];%PRC
patient(pID).stimchan(1).num = NaN; %in EDF browser this channel doesn't exist? %should i use NaN or []?
patient(pID).stimchan(2).num = 3; %
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];


%sampling rate differs between day1 and day2 - lots of movement in T1 and we don't have a preop T1 MRI for this, only postop T1. The electrodeartifact is present
pID = pID+1;
patient(pID).exp = 'Timing';
patient(pID).name = 'amyg048'; %has to be EXACTLY what the log file says - Martina changed file name from amyg048_Lamyg to amyg048. 'Lamyg' was redundant info as only that hemi was stimulated
patient(pID).syncfn  = 'day1Lamyg_lfp_030.mat';
patient(pID).samprate = 1024;%day1 1024, day2 1023.999
patient(pID).ipsi_region(1).lfpnum = 11;%hippocampal CA fields - Martina: 11 (3Ld3) CA1/PRC, 16 (5Ld2) potentially CA3/DG, 17 (5Ld3) potentially CA1/CA2/DG
patient(pID).ipsi_region(2).lfpnum = [];%dentate gyrus
patient(pID).ipsi_region(3).lfpnum = [] ;%parahippocampal gyrus
patient(pID).ipsi_region(4).lfpnum = [];%stim channels 2[c] and 3[a]
patient(pID).ipsi_region(5).lfpnum = [10,15,9];% all hippocampal regions - Martina: 8 (3Ld1) parasuibulum/EC, 9 (3Ld2) subiculum/CA3, 10 (3Ld3) subiculum/CA1, 15 (5Ld1) potentially pre/parasubiculum
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels - Martina: 1 (1Ld1) EC/BLVM amyg, 
patient(pID).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'5Ld2', '5Ld16', '5Ld15', '5Ld14', '5Ld10', '5Ld9', '5Ld11', '5Ld12', '5Ld13', '7Ld8', '9Ld10', '13Ld1', '25Ld3', '31Ld1', 'Pleth', 'PR', 'OSAT', 'TRIG', 'DC16', 'DC15', 'DC14', 'DC13', 'DC12', 'DC11', 'DC10', 'DC9', 'DC8', 'DC7', 'DC6', 'DC5', 'DC4', 'C128', 'DC3', 'DC2', 'C126', 'C125', 'DC1', 'C124', 'C127', 'EKG', '23Ld8', '21Ld7', '21Ld2', '17Ld6', '5Ld1', '1Ld3', '1Ld2', '1Ld9', '3Ld4', '3Ld3', '3Ld2', '3Ld1'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {}; % no imm test for this subject, leave blank
patient(pID).phase(3).removeChannels.names = {'5LdBF10', '5LdBF9', '5LdBF8', '5LdBF15', '7Ld6', '9Ld4', '11Ld6', 'TRIG', 'DC16', 'DC15', 'DC14', 'DC13', 'DC12', 'DC10', 'DC9', 'DC8', 'DC7', 'DC6', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'C128', 'EKG', 'DC11', 'Pleth', 'PR', 'OSAT', '23Ld10', '23Ld9', '23Ld8', '23Ld7', '23Ld5', '19Ld7', '21Ld1', '21Ld4', '15Ld7', '5LdBF2', '1Ld9', '1Ld8', '1Ld10', '3Ld1', '3Ld5', '5LdBF7', '5LdBF6', '5LdBF5', '3Ld6', '5LdBF4', '5LdBF3', '1Ld3', '1Ld4', '1Ld5', '1Ld1', '1Ld2'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];%hippocampal CA fields
patient(pID).contra_region(2).lfpnum = [];%DG
patient(pID).contra_region(3).lfpnum = [];%PHG
patient(pID).contra_region(4).lfpnum = [];%amygdala stim
patient(pID).contra_region(5).lfpnum = [];%all HPC
patient(pID).contra_region(6).lfpnum = [];%EC
patient(pID).contra_region(7).lfpnum = [];%PRC
patient(pID).stimchan(1).num = 2;
patient(pID).stimchan(2).num = 3;
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];

pID = pID+1;
patient(pID).exp = 'Timing';
patient(pID).name = 'amyg053'; %has to be EXACTLY what the log file says - Martina changed file name from amyg053_Ramyg to amyg053. 'Ramyg' was redundant info as only that hemi was stimulated
patient(pID).syncfn  = 'day1_lfp_071.mat'; 
patient(pID).samprate = 1023.999;
patient(pID).ipsi_region(1).lfpnum = [79,86];%hippocampal CA fields - Martina: 79 (4Rd4) CA1/DG/cingulum wm, 86 (6Rd2) CA1/DG/subiculum
patient(pID).ipsi_region(2).lfpnum = [];%dentate gyrus 
patient(pID).ipsi_region(3).lfpnum = [];%parahippocampal gyrus
patient(pID).ipsi_region(4).lfpnum = [];%stim channels 68[c] and 69[a] - epileptic
patient(pID).ipsi_region(5).lfpnum = [78,79,85,86];%all hippocampal regions - Martina: 77 (4Rd2) subiculum/CA3/CA1, 78 (4Rd3) subiculum/CA1/DG, 85 (6Rd1) subiculum/DG
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels - Martina: 76 (4Rd1) EC/presubiculum - epileptic
patient(pID).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names ={'2Rd5', 'Pleth', 'PR', 'OSAT', 'DC16', 'DC15', 'TRIG', 'DC14', 'DC13', 'DC11', 'DC10', 'DC12', 'DC7', 'DC6', 'DC5', 'DC9', 'DC8', 'DC4', 'DC3', 'DC2', 'DC1', 'C128', 'C127', 'C116', 'C126', 'C125', 'C115', 'C124', 'C123', 'C121', 'C114', 'C119', 'C118', 'C120', 'C113', 'C122', 'C112', 'C111', 'C117', 'C110', 'C109', 'P4', 'C3', 'F3', 'O1', 'T5', 'T3', 'F7', 'Fp1', 'EKG', '2Rd1', '2Rd2'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {}; % no imm test for this subject, leave blank
patient(pID).phase(3).removeChannels.names = {'PR', 'DC16', 'C114', 'C112', 'C113', 'Pleth', 'OSAT', 'TRIG', 'DC15', 'C111', 'C110', 'C109', 'DC14', 'DC13', 'DC12', 'DC11', 'DC10', 'DC9', 'DC6', 'DC8', 'DC7', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'C127', 'C126', 'C128', 'C125', 'C124', 'C123', 'C122', 'C121', 'C120', 'C119', 'C118', 'C117', 'C115', 'C116', 'P4', 'C3', 'F3', 'O1', 'T5', 'T3', 'F7', 'Fp1', 'EKG', '2Rd5', '2Rd2', '2Rd1'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];%hippocampal CA fields
patient(pID).contra_region(2).lfpnum = [];%DG
patient(pID).contra_region(3).lfpnum = [];%PHG
patient(pID).contra_region(4).lfpnum = [];%amygdala stim
patient(pID).contra_region(5).lfpnum = [];%all HPC
patient(pID).contra_region(6).lfpnum = [];%EC
patient(pID).contra_region(7).lfpnum = [];%PRC
patient(pID).stimchan(1).num = 68; %2Rd1 [c]
patient(pID).stimchan(2).num = 69; %2Rd2 [a]
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];


%%% taking the first novel session when subject has multiple sessions %%%%
%after trial 130 we are missing 4 trials - it is documented. Trial 131 is
%actually trial 134.
pID = pID+1;
patient(pID).exp = 'Timing';
patient(pID).name = 'amyg054' ; %has to be EXACTLY what the log file says - Martina changed file name from amyg054_Lamyg to amyg054. 'Lamyg' was redundant info as only that hemi was stimulated
patient(pID).syncfn  = 'day1Lamyg_lfp_138.mat';
patient(pID).samprate = 1024.004;%based on EDFbrowser 
patient(pID).ipsi_region(1).lfpnum = [85, 95];% hippocampal CA fields - Martina: 85 (17Ld4) CA1/TLVentricle, 95 (19Ld4) CA1/TLVentricle
patient(pID).ipsi_region(2).lfpnum = [];% dentate gyrus
patient(pID).ipsi_region(3).lfpnum = 43;% parahippocampal gyrus - Martina: 43 (9Ld2) PHG/PRC/mainly wm
patient(pID).ipsi_region(4).lfpnum = [];%stim channels 15Ld3 73[c] and 15Ld4 74[a] - epileptic
patient(pID).ipsi_region(5).lfpnum = [83, 84, 92, 93];%all hippocampal regions - Martina: 83 (17Ld2) presubiculum/subiculum/DG/PRC, 84 (17Ld3) subiculum/CA1/DG, 92 (19Ld1) parasubiculum/PHG, 93 (19Ld2) subiculum/DG
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels - Martina: 52 (11Ld1) EC/PRC boundary, some wm, 72 (15Ld1) EC/BLVM boundary, 82 (17Ld1) EC/presubiculum/parasubiculum - epileptic
patient(pID).ipsi_region(7).lfpnum = [33, 34, 35];%perirhinal cortex channels - Martina: 32 (7Ld1) very anterior PRC/EC, 33 (7Ld2) very anterior PRC, 34 (7Ld3) very anterior PRC, 35 (7Ld4) very anterior PRC/fusiform(BA20), 42 (9Ld1) PRC/rhinal sulcus/ventricle, 53 (11Ld2) PRC/PHG
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'7Ld1', '9Ld9', '13Ld5', '15Ld4', '15Ld3', '8Rd8', 'C192', 'C238', 'C237', 'C236', 'C235', 'C234', 'C233', 'C232', 'C230', 'C229', 'C228', 'C231', 'C227', 'C225', 'C226', 'C224', 'C223', 'C221', 'C220', 'C222', 'C219', 'C218', 'C217', 'C216', 'C209', 'C214', 'C213', 'C215', 'C212', 'C211', 'C210', 'C208', 'C207', 'C191', 'C206', 'C205', 'C204', 'C203', 'C190', 'C202', 'C201', 'C193', 'C200', 'C199', 'C198', 'C197', 'C196', 'C195', 'C194', 'C189', 'C188', 'C187', 'C186', 'C185', 'C176', 'C184', 'C172', 'C183', 'C182', 'C181', 'C180', 'C179', 'C178', 'C177', 'C175', 'C173', 'C174', 'EKG', 'PR', 'OSAT', 'DC16', 'DC13', 'DC14', 'DC12', 'DC11', 'DC10', 'DC9', 'DC8', 'DC15', 'TRIG', 'Pleth', 'DC7', 'DC5', 'DC6', 'DC4', 'DC3', 'DC2', 'C255', 'DC1', 'C256', 'C253', 'C252', 'C254', 'C249', 'C248', 'C247', 'C251', 'C250', 'C245', 'C244', 'C246', 'C243', 'C241', 'C242', 'C239', 'C240'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {}; % no imm test for this subject, leave blank
patient(pID).phase(3).removeChannels.names = {'7Ld1', '13Ld5', 'Pleth', 'OSAT', 'DC16', 'PR', 'TRIG', 'DC14', 'DC13', 'DC15', 'DC11', 'DC12', 'DC9', 'DC10', 'DC5', 'DC8', 'DC7', 'DC6', 'DC3', 'DC4', 'DC2', 'DC1', 'C256', 'C255', 'C254', 'C253', 'C252', 'C251', 'C248', 'C247', 'C250', 'C249', 'C246', 'C245', 'C244', 'C243', 'C242', 'C241', 'C240', 'C239', 'C238', 'C237', 'C236', 'C235', 'C234', 'C233', 'C228', 'C232', 'C227', 'C226', 'C231', 'C230', 'C229', 'C225', 'C224', 'C223', 'C222', 'C221', 'C220', 'C219', 'C217', 'C216', 'C215', 'C214', 'C213', 'C212', 'C218', 'C211', 'C210', 'C209', 'C208', 'C207', 'C206', 'C205', 'C204', 'C203', 'C202', 'C201', 'C200', 'C199', 'C198', 'C197', 'C196', 'C195', 'C194', 'C193', 'C192', 'C191', 'C190', 'C189', 'C188', 'C187', 'C186', 'C185', 'C184', 'C182', 'C181', 'C183', 'C180', 'C179', 'C178', 'C175', 'C177', 'C176', 'C174', 'C173', 'C172', 'EKG', '8Rd8', '1Ld8'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = 164;%hippocampal CA fields - Martina: 164 (18Rd3) CA1/DG/PHG (fusiform)
patient(pID).contra_region(2).lfpnum = [];%DG
patient(pID).contra_region(3).lfpnum = [];%PHG
patient(pID).contra_region(4).lfpnum = [];%amygdala stim
patient(pID).contra_region(5).lfpnum = 163;%all HPC - Martina: 163 (18Rd2) subiculum/DG
patient(pID).contra_region(6).lfpnum = [152,16];%EC - Martina: 152 (16Rd1) EC,162 (18Rd1) EC/presubiculum/parasubiculum 
patient(pID).contra_region(7).lfpnum = [];%PRC
patient(pID).stimchan(1).num = 73; %15Ld3 73[c] 
patient(pID).stimchan(2).num = 74; %15Ld4 74[a]
patient(pID).stimchan(3).num = []; 
patient(pID).stimchan(4).num = []; 

%check if 067 was just a typo and these data are truly for amyg057
pID = pID+1;
patient(pID).exp = 'Timing';
patient(pID).name = 'amyg057'; %has to be EXACTLY what the log file says - log file says 'amyg057_bipolar'
patient(pID).syncfn  = 'day1bipolar_lfp_050.mat';
patient(pID).samprate = 1024;%based on EDFbrowser 
patient(pID).ipsi_region(1).lfpnum = [31, 32];% hippocampal CA fields - Martina: 31 (7Ld1) CA1/BLVL amyg, 32 (7Ld2) CA1/TLVentricle
patient(pID).ipsi_region(2).lfpnum = [];%dentate gyrus
patient(pID).ipsi_region(3).lfpnum = [];%parahippocampal gyrus
patient(pID).ipsi_region(4).lfpnum = [22,23];%stim channels 5Ld2 22[c] and5Ld3 23[a]
patient(pID).ipsi_region(5).lfpnum = [];%all hippocampal regions
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'5Ld3', '5Ld8', '9Ld10', '5Ld2', 'Pleth', 'PR', 'OSAT', 'TRIG', 'DC15', 'DC14', 'DC16', 'DC13', 'DC12', 'DC11', 'DC10', 'DC9', 'DC8', 'DC7', 'DC6', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'C256', 'C254', 'C253', 'C255', 'C251', 'C250', 'C252', 'C248', 'C247', 'C249', 'C246', 'C245', 'C243', 'C242', 'C244', 'C241', 'C240', 'C239', 'C238', 'C237', 'C236', 'C235', 'C234', 'C233', 'C231', 'C230', 'C232', 'C229', 'C228', 'C226', 'C227', 'C225', 'C224', 'C223', 'C222', 'C220', 'C221', 'C219', 'C218', 'C217', 'C216', 'C215', 'C214', 'C213', 'C212', 'C211', 'C210', 'C209', 'C207', 'C208', 'C206', 'C205', 'C204', 'C203', 'C202', 'C201', 'C198', 'C200', 'C199', 'C197', 'C196', 'C195', 'C194', 'C193', 'C192', 'C191', 'C189', 'C188', 'C190', 'C186', 'C187', 'C185', 'C183', 'C184', 'C182', 'C181', 'C180', 'C178', 'C179', 'C177', 'C176', 'C175', 'C173', 'C172', 'C174', 'C171', 'C170', 'EKG'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {}; % no imm test for this subject, leave blank
patient(pID).phase(3).removeChannels.names = {'5Ld2', 'PR', 'OSAT', 'TRIG', 'DC16', 'DC15', 'DC14', 'DC12', 'DC11', 'DC13', 'Pleth', 'DC10', 'DC9', 'DC8', 'DC7', 'DC6', 'DC5', 'DC4', 'DC3', 'DC1', 'DC2', 'C256', 'C255', 'C254', 'C253', 'C252', 'C251', 'C250', 'C249', 'C248', 'C247', 'C246', 'C245', 'C244', 'C243', 'C242', 'C241', 'C240', 'C239', 'C238', 'C237', 'C236', 'C235', 'C234', 'C233', 'C232', 'C231', 'C230', 'C229', 'C228', 'C227', 'C226', 'C225', 'C224', 'C223', 'C222', 'C221', 'C220', 'C219', 'C218', 'C217', 'C216', 'C215', 'C214', 'C213', 'C212', 'C211', 'C210', 'C209', 'C208', 'C206', 'C205', 'C207', 'C203', 'C202', 'C201', 'C200', 'C204', 'C199', 'C198', 'C197', 'C196', 'C195', 'C194', '31Ld3', 'C193', 'C192', 'C191', 'C190', 'C189', 'C188', 'C187', 'C186', 'C185', 'C184', 'C183', 'C182', 'C181', 'C180', 'C179', 'C178', 'C177', 'C176', 'C175', 'C174', 'C173', 'C172', 'C171', 'C170', 'EKG'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];%hippocampal CA fields
patient(pID).contra_region(2).lfpnum = [];%DG
patient(pID).contra_region(3).lfpnum = [];%PHG
patient(pID).contra_region(4).lfpnum = [];%amygdala stim
patient(pID).contra_region(5).lfpnum = [];%all HPC
patient(pID).contra_region(6).lfpnum = [];%EC
patient(pID).contra_region(7).lfpnum = [];%PRC
patient(pID).stimchan(1).num = 22; %5Ld2 [c]
patient(pID).stimchan(2).num = 23; %5Ld3 [a]
patient(pID).stimchan(3).num = 23; %monopolar stim - 5Ld3
patient(pID).stimchan(4).num = [];

pID = pID+1;
patient(pID).exp = 'Timing';
patient(pID).name = 'amyg059'; %has to be EXACTLY what the log file says - Martina changed file name from amyg059_Lamyg to amyg059. 'Lamyg' was redundant info as only that hemi was stimulated
patient(pID).syncfn  = 'day1_lfp_128.mat';
patient(pID).samprate = 1024;%based on EDFbrowser 
patient(pID).ipsi_region(1).lfpnum = 12;%hippocampal CA fields - Martina: 11 (3Ld1) CA1, 12 (3Ld2) CA1/TLVentricle, 21 (5Ld3) CA1/DG
patient(pID).ipsi_region(2).lfpnum = [];%dentate gyrus
patient(pID).ipsi_region(3).lfpnum = [22, 67, 68, 69];%parahippocampal gyrus- Martina: 22 (5Ld4) PHG/parahipp cortex, 67 (15Ld1) PHG/maybe PRC, 68 (15Ld2) PHG/PHC, 69 (15Ld3) PHG
patient(pID).ipsi_region(4).lfpnum = [2,3];%stim channels 3[c] and 2[a]
patient(pID).ipsi_region(5).lfpnum = [12,20];%all hippocampal regions - Martina: 20 (5Ld2) subiculum
patient(pID).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(pID).ipsi_region(7).lfpnum = 59;%perirhinal cortex channels - Martina: 59 (13Ld1) PRC
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'11Ld1', '11Ld2', '1Ld3', '1Ld2', 'DC16', 'DC15', 'DC14', 'DC13', 'OSAT', 'PR', 'TRIG', 'DC12', 'DC11', 'DC10', 'DC9', 'Pleth', 'DC8', 'DC7', 'DC6', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'RSRCH', 'EKG', '23Ld3'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {}; % no imm test for this subject, leave blank
patient(pID).phase(3).removeChannels.names = {'7Ld1', '11Ld2', '11Ld1', '9Ld1', '7Ld10', 'DC10', 'DC9', 'DC8', 'DC7', 'DC6', 'DC5', 'DC4', 'RSRCH', 'DC2', '23Ld3', 'DC3', 'DC1', 'EKG', '23Ld8'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];%hippocampal CA fields
patient(pID).contra_region(2).lfpnum = [];%DG
patient(pID).contra_region(3).lfpnum = [];%PHG
patient(pID).contra_region(4).lfpnum = [];%amygdala stim
patient(pID).contra_region(5).lfpnum = [];%all HPC
patient(pID).contra_region(6).lfpnum = [];%EC
patient(pID).contra_region(7).lfpnum = [];%PRC
patient(pID).stimchan(1).num = 3; %Martina:  potentially just before LA - 1Ld3 [a]
patient(pID).stimchan(2).num = 2; %Martina: in periamygdaloid cortex/PRC = 1Ld2 [c]
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];


% majority of channels are epileptic %
%%% taking the first novel session when subject has multiple sessions %%%% - second session is bilateral bipolar stimulation
pID = pID+1;
patient(pID).exp = 'Timing';
patient(pID).name = 'amyg060'; %has to be EXACTLY what the log file says - this is the unilateral Lamyg stim
patient(pID).syncfn  = 'day1Lamyg_lfp_222.mat';
patient(pID).samprate = 1024;%based on EDFbrowser 
patient(pID).ipsi_region(1).lfpnum = [];%hippocampal CA fields - Martina: 12 (3Ld2) CA1/ventricle, 14 (3Ld4) CA1/TLVentricle a bit,  24 (5Ld4) CA1/DG, 134 (6Rd4) CA1/subiculum/DG
patient(pID).ipsi_region(2).lfpnum = [];%dentate gyrus - Martina: 13 (3Ld3) DG/CA3/CA1
patient(pID).ipsi_region(3).lfpnum = []; %PHG
patient(pID).ipsi_region(4).lfpnum = [];%stim channels 2[c] and [a] epileptic
patient(pID).ipsi_region(5).lfpnum = [21,25];%all hippocampal regions - Martina: 11(3Ld1) subiculum/presubiculum/CA1, 21 (5Ld1) parasubiuclum/Ventricle/EC, 22 (5Ld2) presubiuclum/subiculum, 23 (5Ld3) subiculum/DG, 
patient(pID).ipsi_region(6).lfpnum = 71; %entorhinal cortex channels - Martina: (1Ld1) EC/BLVM amyg, 71 (15Ld1) EC/PRC boundary
patient(pID).ipsi_region(7).lfpnum = [72,73];%perirhinal cortex channels - Martina: 72 (15Ld2) PRC, 73 (15Ld3) PRC/cingulum wm
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'1Ld2', '9Ld9', '9Ld10', '1Ld3', '3Ld2', '3Ld4', '3Ld3', '3Ld1', '5Ld4', '5Ld3', '5Ld2', '11Ld4', '11Ld2', '11Ld5', '11Ld3', '1Ld1', '21Ld1', '2Rd5', '2Rd4', '2Rd3', '2Rd2', '4Rd2', '4Rd4', '4Rd3', '4Rd1', '6Rd3', '6Rd4', '6Rd2'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {}; % no imm test for this subject, leave blank
patient(pID).phase(3).removeChannels.names = {'3Ld4', '3Ld3', '3Ld2', '3Ld1', '5Ld3', '5Ld2', '5Ld4', '9Ld10', '9Ld9', '15Ld1', '4Rd3', '4Rd2', '4Rd1', '4Rd5', '2Rd2', '2Rd3', '4Rd4', '6Rd5', '6Rd3', '6Rd2', '6Rd4', '21Ld1', '16Rd2', '16Rd1', 'PR', 'DC15', 'DC14', 'DC13', 'DC16', 'Pleth', 'OSAT', 'TRIG', 'DC12', 'DC11', 'DC10', 'DC8', 'DC7', 'DC9', 'DC6', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'C256', 'C255', 'C254', 'C253', 'C252', 'C251', 'C250', 'C249', 'C248', 'C247', 'C246', 'C245', 'C244', 'C243', 'C242', 'C241', 'C239', 'C238', 'C240', 'C237', 'C236', 'C235', 'C234', 'C232', 'C222', 'C231', 'C233', 'C230', 'C229', 'C228', 'C227', 'C226', 'C225', 'C224', 'C223', 'EKG'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [122, 134];%hippocampal CA fields - Martina: 122 (4Rd2) CA1/subiculum
patient(pID).contra_region(2).lfpnum = [123, 124, 133];%DG - Martina:  123 (4Rd3) DG/subiculum/presubiulum, 124 (4Rd4)DG/CA1/subiculum, 133 (6Rd3) subiculum/DG
patient(pID).contra_region(3).lfpnum = [131, 191, 192];%parahippocampal gyrus - Martina: 131 (6Rd1) PHG/PHC/EC/Ventricle, 191 (18Rd1) PHG/PHC/EC, 192 (18Rd2) PHG/PHC/fusiform (BA20) boundary
patient(pID).contra_region(4).lfpnum = [112,113];%amygdala stim
patient(pID).contra_region(5).lfpnum = 121;%all HPC - Martina:  121 (4Rd1) presubiculum/subiculum/CA1
patient(pID).contra_region(6).lfpnum = [111, 112, 181, 182];%EC - Martina: 111 (2Rd1) ambiens gyrus/EC, 112 (2Rd2) right side cathode stim electrode in EC/BLVM amyg,  181 (16Rd1) EC, 182 (16Rd2) EC
patient(pID).contra_region(7).lfpnum = 183;%PRC - Martina: 183 (16Rd3) PRC
patient(pID).stimchan(1).num = 2; %1ld2[c]
patient(pID).stimchan(2).num = 3; %1ld3[a]
patient(pID).stimchan(3).num = 112; % 2rd2[c]
patient(pID).stimchan(4).num = 113; % 2rd3 [a]

pID = pID+1;
patient(pID).exp = 'Timing';
patient(pID).name = 'amyg061'; %has to be EXACTLY what the log file says -Martina changed file name from amyg061_Ramyg to amyg061. 'Ramyg' was redundant info as only that hemi was stimulated
patient(pID).syncfn  = 'day1_lfp_127.mat';
patient(pID).samprate = 1024;%based on EDFbrowser 
patient(pID).ipsi_region(1).lfpnum = 85;%hippocampal CA fields - Martina: 102 (12Rd3) CA1/cingulum wm, 85 (4Rd2) CA1/TLVentricle, 66 (28Rd1) CA1/CA3/TLVentricle,95 (6Rd4) CA2/CA1/TLVentricle
patient(pID).ipsi_region(2).lfpnum = [84, 94];%dentate gyrus - Martina: 84 (4Rd1) DG/CA3/CA1, 94 (6Rd3) DG/subiculum/CA3
patient(pID).ipsi_region(3).lfpnum = 103;%parahippocampal gyrus - Martina: 103 (12Rd4) PHG/cingulum wm/maybe PRC, 
patient(pID).ipsi_region(4).lfpnum = [75,76];%stim channels 2Rd2 75[a] and 2Rd3 76 [c]
patient(pID).ipsi_region(5).lfpnum = [85,92,93];%all hippocampal regions - Martina: 100 (12Rd1) subiulum/EC/cingulum wm, 101 (12Rd2) subiculum, 92 (6Rd1) parasubiculum/EC, 93 (6Rd2)parasubiculum/presubiculum 
patient(pID).ipsi_region(6).name = 74; %entorhinal cortex channels
patient(pID).ipsi_region(7).name = [];%perirhinal cortex channels
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'28Rd2', 'DC10', 'DC9', 'DC8', 'DC7', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'DC6', 'EKG', 'Rsch', '2Rd3', '2Rd2', '4Rd1', '2Rd1', '6Rd4', '6Rd3', '12Rd3', '12Rd2', '12Rd1'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {}; % no imm test for this subject, leave blank
patient(pID).phase(3).removeChannels.names = {'14Rd9', '28Rd3', '28Rd7', '2Rd1', '2Rd2', '28Rd2', '28Rd1', '28Rd8', 'PR', 'OSAT', 'Pleth', 'DC16', 'TRIG', 'DC15', 'DC14', 'DC13', 'DC12', 'DC11', 'DC10', 'DC9', 'DC8', 'DC7', 'DC6', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'EKG', 'Rsch', '8Rd10', '4Rd6', '4Rd1', '28Rd6', '28Rd5', '28Rd4'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];%hippocampal CA fields
patient(pID).contra_region(2).lfpnum = [];%DG
patient(pID).contra_region(3).lfpnum = [];%PHG
patient(pID).contra_region(4).lfpnum = [];%amygdala stim
patient(pID).contra_region(5).lfpnum = [];%all HPC
patient(pID).contra_region(6).lfpnum = [];%EC
patient(pID).contra_region(7).lfpnum = [];%PRC
patient(pID).stimchan(1).num = 75; %2Rd2 75[a]
patient(pID).stimchan(2).num = 76; %2Rd3 76 [c]
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];

pID = pID+1;
patient(pID).exp = 'Timing';
patient(pID).name = 'amyg066'; %has to be EXACTLY what the log file says - Martina changed file name from amyg066_Lamyg to amyg066. 'Lamyg' was redundant info as only that hemi was stimulated
patient(pID).syncfn  = 'day1_lfp_257.mat';
patient(pID).samprate = 1024;%based on EDFbrowser 
patient(pID).ipsi_region(1).lfpnum = 11;%hippocampal CA fields - Martina: 11 (3Ld1) CA1/subiculum, 22(5Ld4) CA1/TLVentricle
patient(pID).ipsi_region(2).lfpnum = 21;%dentate gyrus - Martina: 21 (5Ld3) DG/subiculum/CA1
patient(pID).ipsi_region(3).lfpnum = [69,70,68,69];%parahippocampal gyrus - Martina: 67 (17Ld1) PHG/PHC/ventircle, 68 (17Ld2) PHG/cingulum wm, 69 (17Ld3) PHG/PHC, 70 (17Ld4) PHG/PHC/fusiform gyrus boundary
patient(pID).ipsi_region(4).lfpnum = [2,3];%stim channels 1Ld3 3[c] and 1Ld2 2[a]
patient(pID).ipsi_region(5).lfpnum = [19, 20];% all hippocampal regions - Martina: 19 (5Ld1) presubiculum/subiculum/cingulum wm, 20 (5Ld2)subiculum/presubiculum/DG
patient(pID).ipsi_region(6).name = [57,1,58]; %entorhinal cortex channels - Martina: 1 (1Ld1) EC/ventricle/BLVM amyg, 57 (15Ld1) EC, 58 (15Ld2) EC/PRC boundary
patient(pID).ipsi_region(7).name = 59;%perirhinal cortex channels - Martina: 140 (4Rd4) PRC, 59 (15Ld3) PRC/cingulum wm
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'1Ld3', '3Ld3', '7Ld6', '7Ld8', '3Ld5', '1Ld2', '17Ld10', '17Ld9', '3Ld7', '21Ld10', '8Rd9', '8Rd8', 'DC9', 'DC10', 'DC8', 'DC7', 'DC6', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'C256', 'C255', 'C254', 'C251', 'C253', 'C252', 'C250', 'C249', 'C248', 'C247', 'C246', 'C245', 'C244', 'C243', 'C242', 'C241', 'C240', 'C239', 'C238', 'C236', 'C237', 'C235', 'C234', 'C233', 'C232', 'C231', 'C230', 'C229', 'C228', 'C227', 'C226', 'C225', 'C224', 'C223', 'C222', 'C221', 'C220', 'C219', 'C218', 'C217', 'C216', 'C215', 'C214', 'C213', 'C212', 'C211', 'C210', 'C209', 'C208', 'C207', 'C206', 'C205', 'C204', 'C203', 'C202', 'C201', 'C200', 'C199', 'C198', 'C197', 'C195', 'C194', 'C196', 'C193', 'C192', 'C190', 'C191', 'C189', 'C188', 'C187', 'C186', 'C185', 'C184', 'C183', 'C182', 'C181', 'C180', 'C178', 'C179', 'C177', 'C176', 'C174', 'C175', 'C172', 'C171', 'C170', 'C173', 'C168', 'C167', 'C169', 'C166', 'C165', 'C164', 'C163', 'C162', 'C161', 'C160', 'C159', 'EKG', 'C158', '8Rd10'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {}; % no imm test for this subject, leave blank
patient(pID).phase(3).removeChannels.names = {'3Ld5', '7Ld6', '7Ld8', '3Ld2', '17Ld10', '17Ld9', '3Ld1', '1Ld10', '1Ld9', '3Ld4', '15Ld10', '15Ld9', '7Ld1', '21Ld10', 'Research', 'EKG', '4Rd10', '4Rd9', '8Rd9', '8Rd10', 'PR', 'OSAT', 'TRIG', 'DC15', 'DC13', 'DC14', 'DC12', 'DC16', 'DC11', 'DC10', 'DC9', 'DC8', 'DC7', 'DC6', 'DC5', 'DC4', 'DC3', 'DC2', 'C256', 'Pleth', 'C255', 'C254', 'C252', 'C251', 'DC1', 'C253', 'C248', 'C247', 'C249', 'C250', 'C246', 'C245', 'C244', 'C243', 'C241', 'C240', 'C242', 'C239', 'C238', 'C237', 'C236', 'C235', 'C234', 'C233', 'C231', 'C230', 'C232', 'C229', 'C228', 'C225', 'C224', 'C223', 'C226', 'C227', 'C221', 'C220', 'C219', 'C222', 'C218', 'C217', 'C216', 'C215', 'C213', 'C212', 'C214', 'C211', 'C210', 'C209', 'C208', 'C207', 'C206', 'C205', 'C204', 'C203', 'C202', 'C201', 'C200', 'C199', 'C198', 'C197', 'C196', 'C195', 'C194', 'C192', 'C191', 'C193', 'C189', 'C188', 'C190', 'C187', 'C186', 'C185', 'C184', 'C182', 'C181', 'C180', 'C183', 'C179', 'C178', 'C177', 'C175', 'C174', 'C176', 'C172', 'C171', 'C173', 'C170', 'C169', 'C168', 'C167', 'C166', 'C165', 'C164', 'C163', 'C161', 'C160', 'C162', 'C159'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [138,139];%hippocampal CA fields - Martina: 138 (4Rd2) CA1/DG/subiculum, 139 (4rd3)CA1/DG/subiculum
patient(pID).contra_region(2).lfpnum = [];%DG
patient(pID).contra_region(3).lfpnum = [];%PHG
patient(pID).contra_region(4).lfpnum = [];%amygdala stim
patient(pID).contra_region(5).lfpnum = 137;%all HPC - Martina: 137 (4Rd1) subiculum/presubiculum/CA1
patient(pID).contra_region(6).lfpnum = [];%EC
patient(pID).contra_region(7).lfpnum = [];%PRC
patient(pID).stimchan(1).num = 3;%1Ld3 [c]
patient(pID).stimchan(2).num = 2;%1Ld2 [a]
patient(pID).stimchan(3).num = [];
patient(pID).stimchan(4).num = [];


%%% taking the first novel session when subject has multiple sessions %%%%
%%% R sided HPC resection - hard to localize %%%
pID = pID+1;
patient(pID).exp = 'Timing';
patient(pID).name = 'amyg072'; %has to be EXACTLY what the log file says - logfile says amyg072_Lamyg
patient(pID).syncfn  = 'day1Lamyg_lfp_257.mat';
patient(pID).samprate = 2048;%based on EDFbrowser 
patient(pID).ipsi_region(1).lfpnum = 19;%hippocampal CA fields - Martina: 19 (3Ld4) CA1 
patient(pID).ipsi_region(2).lfpnum = 18;% dentate gyrus - Martina: 18 (3Ld3) DG/CA3 / CA1
patient(pID).ipsi_region(3).lfpnum = [];%parahippocampal gyrus
patient(pID).ipsi_region(4).lfpnum = [3,4];%stim channels 1Ld3 3[c] and 1Ld4 4[a]
patient(pID).ipsi_region(5).lfpnum = [16,17,18,19];%all hippocampal regions - Martina: 16 (3Ld1) subiculum/EC, 17 (3Ld2) subiculum/DG/CA3
patient(pID).ipsi_region(6).name = [1,2]; %entorhinal cortex channels - Martina: 1 (1Ld1) EC, 2 (2Ld2) EC/BLVM amyg
patient(pID).ipsi_region(7).name = 20;%perirhinal cortex channels - Martina: 20 (3Ld5) - TLVentricle/cingulum wm/PRC - maybe CA1
patient(pID).ipsi_region(8).lfpnum = 13;% PNAS_CA 
patient(pID).ipsi_region(9).lfpnum = 12;%PNAS_DG
patient(pID).ipsi_region(10).lfpnum = 31;%PNAS_PRC
patient(pID).ipsi_region(11).lfpnum = 2;%PNAS_BLA
patient(pID).phase(1).removeChannels.names = {'1Ld3', '3Ld13', '6Rd12', '1Ld4', '3Ld6', '3Ld3', '3Ld2', '3Ld4', '3Ld5', '3Ld1', '1Ld15', '3Ld15', 'DC2', 'DC1', 'EKG', '22Rd14', '28Rd7', '28Rd8', '18Rd15', '20Rd18', '20Rd17'}; % Channels that has to be removed before computing the median for phase = 1 (Day1_Study)
patient(pID).phase(2).removeChannels.names = {}; % no imm test for this subject, leave blank
patient(pID).phase(3).removeChannels.names = {'1Ld15', '28Rd7', 'Pleth', 'PR', 'OSAT', 'TRIG', 'DC16', 'DC15', 'DC14', 'DC13', 'DC12', 'DC11', 'DC10', 'DC9', 'DC8', 'DC7', 'DC6', 'DC5', 'DC4', 'DC3', 'DC2', 'DC1', 'EKG', '22Rd14', '18Rd15', '20Rd17', '20Rd18', '18Rd3', '18Rd12', '6Rd11', '6Rd12', '3Ld13', '3Ld15', '1Ld14', '2Rd13', '1Ld13', '1Ld12'}; % Channels that has to be removed before computing the median for phase = 3 (Day2)
patient(pID).contra_region(1).lfpnum = [];%hippocampal CA fields
patient(pID).contra_region(2).lfpnum = 67;%DG - Martina: 67 (10Rd1) prior resection of HPC tissue, hard to localize - DG/CA3/CA1/PHG
patient(pID).contra_region(3).lfpnum = [68,69];%PHG - Martina: 68 (10Rd2) PHG/CA1, 69 (10Rd3) PHG
patient(pID).contra_region(4).lfpnum = [33, 34];%amygdala stim - R side had HPC resection
patient(pID).contra_region(5).lfpnum = [];%all HPC
patient(pID).contra_region(6).lfpnum = [31, 32];%EC - Martina: 31 (2Rd1) EC, 32 (Rd2) EC/basal amyg - FS localization says lateral ofc (check!)
patient(pID).contra_region(7).lfpnum = [];%PRC
patient(pID).stimchan(1).num = 3;%1Ld3 [c]
patient(pID).stimchan(2).num = 4; %1Ld4 [a]
patient(pID).stimchan(3).num = 33; %2Rd3 [c]
patient(pID).stimchan(4).num = 34; %2Rd4 [a]



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              How many actual channels of data?                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ORIGINAL PATIENTS - PNAS   
patient(1).maxchan = 128;
patient(2).maxchan = 128;
patient(3).maxchan = 128;
patient(4).maxchan = 113;
patient(5).maxchan = 128;
patient(6).maxchan = 128;
patient(7).maxchan = 70;
patient(8).maxchan = 80;
patient(9).maxchan = 126;
patient(10).maxchan = 102;%101 & 102 = sync
patient(11).maxchan = 128;
patient(12).maxchan = 100;
patient(13).maxchan = 118;
patient(14).maxchan = 104;

%double check them from EDF browser! Do CH and DC not count? are those empty channels?
% AMME DURATION PATIENTS
patient(15).maxchan = 148; %amyg030
patient(15).lfp_chan_count = 116;

patient(16).maxchan = 276; %amyg033
patient(16).lfp_chan_count = 199;

patient(17).maxchan = 276; %amyg034
patient(17).lfp_chan_count = 194;

patient(18).maxchan = 148; %amyg037
patient(18).lfp_chan_count = 126;

% patient(18).maxchan = 276; %amyg042
% patient(18).lfp_chan_count = 161;



%AMME TIMING PATIENTS
patient(19).maxchan = 276; %amyg045
patient(19).lfp_chan_count = 155;

patient(20).maxchan = 276; %amyg046
patient(20).lfp_chan_count = 155;
% 
% patient(21).maxchan = 276; %amyg047
% patient(21).lfp_chan_count = 155;

%mutliple maxchan and lfpcount for this pt- day1 1:148, day2 2:149
patient(21).maxchan = 148; %amyg048
patient(21).lfp_chan_count = 148;

patient(22).maxchan = 148; %amyg053
patient(22).lfp_chan_count = 148;

patient(23).maxchan = 276; %amyg054
patient(23).lfp_chan_count = 155;

patient(24).maxchan = 276; %amyg057
patient(24).lfp_chan_count = 155;

patient(25).maxchan = 148; %amyg059
patient(25).lfp_chan_count = 148;

patient(26).maxchan = 276; %amyg060
patient(26).lfp_chan_count = 155;

patient(27).maxchan = 148; %amyg061
patient(27).lfp_chan_count = 148;

patient(28).maxchan = 276; %amyg066
patient(28).lfp_chan_count = 155;

patient(29).maxchan = 276 ; %amyg072
patient(29).lfp_chan_count = 155 ;


%% this section is for the Original patients

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Set up the basic format of the                   %
%                       "patient" structure                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for pIdx = 1:length(patient)
    % if (~strcmp(patient(pIdx).exp,"Original"))
    %     continue
    % end

    patient(pIdx).ipsi_region(1).name = 'ipsi CA fields';
    patient(pIdx).ipsi_region(2).name = 'ipsi DG';
    patient(pIdx).ipsi_region(3).name = 'ipsi PHG';
    patient(pIdx).ipsi_region(4).name = 'ipsi BLA';
    patient(pIdx).ipsi_region(5).name = 'all ipsi hippocampus';
    patient(pIdx).ipsi_region(6).name = 'all ipsi EC'; %entorhinal cortex channels
    patient(pIdx).ipsi_region(7).name = 'all ipsi PRC';%perirhinal cortex channels
    patient(pIdx).ipsi_region(8).name = 'PNAS_CA';
    patient(pIdx).ipsi_region(9).name = 'PNAS_DG';
    patient(pIdx).ipsi_region(10).name = 'PNAS_PRC'; 
    patient(pIdx).ipsi_region(11).name = 'PNAS_BLA';

    patient(pIdx).contra_region(1).name = 'contra CA fields';
    patient(pIdx).contra_region(2).name = 'contra DG';
    patient(pIdx).contra_region(3).name = 'contra PHG';
    patient(pIdx).contra_region(4).name = 'contra BLA';
    patient(pIdx).contra_region(5).name = 'all contra hippocampus';
    patient(pIdx).contra_region(6).name = 'all contra EC'; %entorhinal cortex channels
    patient(pIdx).contra_region(7).name = 'all contra PRC';%perirhinal cortex channels
    % patient(pIdx).stimchan(1).num = [];
    % patient(pIdx).stimchan(2).num = [];
    % patient(pIdx).stimchan(3).num = [];
    % patient(pIdx).stimchan(4).num = [];
    
    patient(pIdx).phase(1).name = 'study';
    patient(pIdx).phase(2).name = 'immediate test';
    patient(pIdx).phase(3).name = 'one-day test';
     
    for ph = 1:3
        patient(pIdx).phase(ph).samprate = patient(pIdx).samprate;
        patient(pIdx).phase(ph).syncfn = patient(pIdx).syncfn;
    end
    patient(pIdx).phase(3).syncfn(4) = '2';%change the sync filename for one-day test to reflect day2 rather than day1
    
    patient(pIdx).sync_chnum=str2num(patient(pIdx).syncfn(end-6:end-4)); %#ok<ST2NM>
end

% %% this section is for AMME Timing patients (no immediate test)
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                 Set up the basic format of the                   %
% %                       "patient" structure                        %
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  for pIdx = 1:length(patient)
%    if (~strcmp(patient(pIdx).exp,"Timing"))
%         continue
%    end
%   patient(pIdx).ipsi_region(1).name = 'ipsi CA fields';
%   patient(pIdx).ipsi_region(2).name = 'ipsi DG';
%   patient(pIdx).ipsi_region(3).name = 'ipsi PHG';
%   patient(pIdx).ipsi_region(4).name = 'ipsi BLA';
%   patient(pIdx).ipsi_region(5).name = 'all ipsi hippocampus';
%   patient(pIdx).ipsi_region(6).name = 'all ipsi EC'; %entorhinal cortex channels
%   patient(pIdx).ipsi_region(7).name = 'all ipsi PRC';%perirhinal cortex channels
%   patient(pIdx).contra_region(1).name = 'contra CA fields';
%   patient(pIdx).contra_region(2).name = 'contra DG';
%   patient(pIdx).contra_region(3).name = 'contra PHG';
%   patient(pIdx).contra_region(4).name = 'contra BLA';
%   patient(pIdx).contra_region(5).name = 'all contra hippocampus';
%   patient(pIdx).contra_region(6).name = 'all contra EC'; %entorhinal cortex channels
%   patient(pIdx).contra_region(7).name = 'all contra PRc';%perirhinal cortex channels
%   patient(pIdx).stimchan(1).num = [];
%   patient(pIdx).stimchan(2).num = [];
%   patient(pIdx).stimchan(3).num = [];
%   patient(pIdx).stimchan(4).num = [];
% 
%   patient(pIdx).phase(1).name = 'study';
%   patient(pIdx).phase(3).name = 'one-day test';
%   for ph = [1,3] 
%     patient(pIdx).phase(ph).samprate = patient(pIdx).samprate;
%     patient(pIdx).phase(ph).syncfn = patient(pIdx).syncfn;
%   end
%   patient(pIdx).phase(3).syncfn(4) = '2';
% 
%   patient(pIdx).sync_chnum=str2num(patient(pIdx).syncfn(end-6:end-4)); %#ok<ST2NM> ???
%  end
% 
% 
%  %% this section is for AMME Duration patients
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                 Set up the basic format of the                   %
% %                       "patient" structure                        %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% for pIdx = 1:length(patient)
%     if (~strcmp(patient(pIdx).exp,"Duration"))
%         continue
%     end
%       patient(pIdx).ipsi_region(1).name = 'ipsi CA fields';
%       patient(pIdx).ipsi_region(2).name = 'ipsi DG';
%       patient(pIdx).ipsi_region(3).name = 'ipsi PHG';
%       patient(pIdx).ipsi_region(4).name = 'ipsi BLA';
%       patient(pIdx).ipsi_region(5).name = 'all ipsi hippocampus';
%       patient(pIdx).ipsi_region(6).name = 'all ipsi EC'; %entorhinal cortex channels
%       patient(pIdx).ipsi_region(7).name = 'all ipsi PRC';%perirhinal cortex channels
%       patient(pIdx).contra_region(1).name = 'contra CA fields';
%       patient(pIdx).contra_region(2).name = 'contra DG';
%       patient(pIdx).contra_region(3).name = 'contra PHG';
%       patient(pIdx).contra_region(4).name = 'contra BLA';
%       patient(pIdx).contra_region(5).name = 'all contra hippocampus';
%       patient(pIdx).contra_region(6).name = 'all contra EC'; %entorhinal cortex channels
%       patient(pIdx).contra_region(7).name = 'all contra PRC';%perirhinal cortex channels
%       patient(pIdx).stimchan(1).num = [];
%       patient(pIdx).stimchan(2).num = [];
%       patient(pIdx).stimchan(3).num = [];
%       patient(pIdx).stimchan(4).num = [];
% 
% 
%       patient(pIdx).phase(1).name = 'study';
%       patient(pIdx).phase(2).name = 'immediate test';
%       patient(pIdx).phase(3).name = 'one-day test';
%       for ph = 1:3
%         patient(pIdx).phase(ph).samprate = patient(pIdx).samprate;
%         patient(pIdx).phase(ph).syncfn = patient(pIdx).syncfn;
%       end
%       patient(pIdx).phase(3).syncfn(4) = '2';%change the sync filename for one-day test to reflect day2 rather than day1
% 
%       patient(pIdx).sync_chnum=str2num(patient(pIdx).syncfn(end-6:end-4)); %#ok<ST2NM>
% end

%% Limit the data to only work on included participants
includedPatients = readtable(RD+"FileInfoList.csv");
PatientNames = unique(includedPatients.Patient);
pList = string(vertcat(patient.name));
pIndex = find(ismember(pList,PatientNames));
patient = patient(pIndex);
% Save the patient structure
save(WR+"PatientStructL1","patient");
