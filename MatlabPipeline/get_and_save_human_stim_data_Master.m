%script to do analyses/plotting of human amygdala stim data
%previously called do_human_stim_analyses
%changed by JRM 6/11/16 to better reflect scope of this script
%all lfp channel numbers refer to the nth lfp, excluding the initial event channel
%thus, be careful to subtract one from each EDF file channel number to get the correct nth lfp number
%updated CSI 5/9/16
%updated JRM & CSI 6/1/16 to read in sync pulse times for test sessions
%updated JRM & CSI 6/1/16 to have current best guesses about lfp locations/numbers
%updated 7/15/2016 to calculate median lfp for each session and to use that to re-reference all lfps JRM
%updated 8/4/16 to use electrodes picked by Kelly to be "most BLA"  JRM
%updated 8/30/16 with new anatomy info for 001, 009, 010, 014, 017 JRM
%updated 9/13/16 to include region(5), which will be all available hippocampus(CA1/2/3, DG, Subiculum) electrodes
%updated 9/14/16 to remove electrodes that had large 60 cycle even after trying to remove it
%updated 10/10/16 to remove previously mislabeled electrodes for amyg002
%updated 10/10/16 to reflect Joe's inspection of ROSA screen shots
%   ... I selected most anterior hippocampus BODY (not uncus/head) electrode in CA1/2/3 or Subiculum (or DG if no other option)
%   ... goal was to prioritize positions in hippoocampus most connected to amygdala
%   ... I avoided uncus/head because in rats, BLA actually doesn't project strongly to temporal pole of hip
%   ... also, the convoluted arrangement of hippocampal layers in head might yield odd LFPs, I guessed
%updated 10/26/16: JRM looked at ROSA screen shots of 003,008,010, 013, and 017 for PHG electrodes.  Only ones who had alternates were 008 and 013.
%   ...008: 52 (original) was most similar to other patients' perirhinal contacts.  Thus, I did not change. FYI LFPs 55, 56, and 57 are closer to temporalpolar peri
%   ...013: 34 seemed to be a viable alternative.  I re-ran major analyese with 34--> everything looked the same.  I kept #35 (original) since there was no difference.

%%%%%%%%%%param=set_exp_param(exp = 'Timing') - explain what this is %%%%%%%%%%!!!!!!!!!!!!!!!!!!!!!!


%updated by Martina 10/19/22: adding Timing and Duration data to this
%script and restructuring the script to accommodate the data differences
%between PNAS, Timing, and Duration experiments 

%updated by Martina 12/20/23: reformatted the entire code strucutre with
%sections and added a function to call specific parts of the script. Each
%section accommodates a specific sub-experiment and variations in the data

%Per Kelly RE stimulated BLA electrodes to use as of 8/4/16
%updated 8/5/16 to correct amy013
%updated 9/14/16 to try to avoid noisy BLA electrodes
% Final list:
% Amyg001: LFP #128
% Amyg002: LFP #127
% Amyg008: LFP #53--per Kelly: Bestest BLAist (though not stimulated) = 52
% Amyg010: LFP #23
% Amyg014: LFP #2
% Amyg003: LFP #21
% Amyg009: LFP #12
% Amyg013: LFP #2
% Amyg015: LFP #2--per Kelly: Bestest BLAist (though not stimulated) = 3
% Amyg017: LFP #3--per Kelly: Bestest BLAist (though not stimulated) = 
% Amyg011: LFP #29
% Amyg016: LFP #66
% Amyg007: LFP #19
% Amyg005: LFP #103


%ADDING SPECIFIC TOOLBOXES TO THE PATH

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Manually assign names,                       %
%          sync pulse channel numbers, and sampling rates          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% THIS IS THE STRUCTURE
% patient(1).exp = 'name of experiment';
% patient(1).name  = 'subject ID';
% patient(1).syncfn  = 'day1 lfp channel name';
% patient(1).samprate = #;%sampling rate day1 - based on EDFbrowser
% patient(1).ipsi_region(1).lfpnum = [];%ispilateral CA1 channels
% patient(1).ipsi_region(2).lfpnum = [];%ipsilateral DG channels
% patient(1).ipsi_region(3).lfpnum = [];%ipsilateral parahipppocampal channels
% patient(1).ipsi_region(4).lfpnum = [];%ipsilateral amyg stimulated channels
% patient(1).ipsi_region(5).lfpnum = [];%all ipsilateral hippocampal channels
% patient(1).ipsi_region(6).name = []; %ipsilateral entorhinal cortex channels
% patient(1).ipsi_region(7).name = [];%ipsilateral perirhinal cortex channels
% patient(1).contra_region(1).lfpnum = [];%contralateral CA1 channels
% patient(1).contra_region(2).lfpnum = [];%contralateral DG channels
% patient(1).contra_region(3).lfpnum = [];%contralateral parahipppocampal channels
% patient(1).contra_region(4).lfpnum = [];%contralateral amyg stimulated channels - if any in case of multiple sessions or bilateral stimulation
% patient(1).contra_region(5).lfpnum = [];%all contralateral hippocampal channels
% patient(1).contra_region(6).lfpnum = [];%contralateralentorhinal cortex channels
% patient(1).contra_region(7).lfpnum = [];%contralateral perirhinal cortex channels
% patient(1).stimchan(1).num = #;% lfp channel number for each stim electrode
% patient(1).stimchan(2).num = #;
% patient(1).stimchan(3).num = #;
% patient(1).stimchan(4).num = #;
% patient(1).region(8).name  = 'stim_chan_name';

% include ispi/contra lfp channel names
% include log file names even for multiple sessions
% include multiple sampling rates?
% include multiple stim channels?


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                  AMME ORIGINAL PATIENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

patient(1).exp = 'Original';
patient(1).name  = 'amyg001';
patient(1).syncfn = 'day1_lfp_095.mat';
patient(1).samprate = 499.70714;%samp rate day1 - based on EDFbrowser
patient(1).ipsi_region(1).lfpnum = 124;%per Jon: 124 is CA1, next to ventricle; ...124 = CA1/3; 125 is likely in white matter near CA fields per DARPA
patient(1).ipsi_region(2).lfpnum = [];%probably no gray matter contact
patient(1).ipsi_region(3).lfpnum = [];%probably no gray matter contact
patient(1).ipsi_region(4).lfpnum = 128;%stimulated channels = 128 (monopolar)
patient(1).ipsi_region(5).lfpnum = 124;%region 5 = all possible hippocampus electrodes; see above for notes
patient(1).ipsi_region(6).lfpnum = [];%entorhinal cortex channels
patient(1).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(1).contra_region(1).lfpnum = [];
patient(1).contra_region(2).lfpnum = [];
patient(1).contra_region(3).lfpnum = [];
patient(1).contra_region(4).lfpnum = [];
patient(1).contra_region(5).lfpnum = [];
patient(1).contra_region(6).lfpnum = [];
patient(1).contra_region(7).lfpnum = [];
patient(1).stimchan(1).num = 128;%only one--monopolar
patient(1).stimchan(2).num = [];
patient(1).stimchan(3).num = [];
patient(1).stimchan(4).num = [];


patient(2).exp = 'Original';
patient(2).name  = 'amyg002';
patient(2).syncfn  = 'day1_lfp_018.mat';
patient(2).samprate = 499.70714;
patient(2).ipsi_region(1).lfpnum = [];%update 10/10/16--no ipsi hip electrodes; DARPA lists 117 as both CA and DG
patient(2).ipsi_region(2).lfpnum = [];
patient(2).ipsi_region(3).lfpnum = 116;%per both Jon and DARPA
patient(2).ipsi_region(4).lfpnum = [127, 128];%stimulated channels = 127 & 128
patient(2).ipsi_region(5).lfpnum = [];%region 5 = all possible hippocampus electrodes; see above for notes
patient(2).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(2).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(2).contra_region(1).lfpnum = [];
patient(2).contra_region(2).lfpnum = [];
patient(2).contra_region(3).lfpnum = [];
patient(2).contra_region(4).lfpnum = [];
patient(2).contra_region(5).lfpnum = [];
patient(2).contra_region(6).lfpnum = [];
patient(2).contra_region(7).lfpnum = [];
patient(2).stimchan(1).num = 127;
patient(2).stimchan(2).num = 128;
patient(2).stimchan(3).num = [];
patient(2).stimchan(4).num = [];


patient(3).exp = 'Original';
patient(3).name  = 'amyg003';
patient(3).syncfn  = 'day1_lfp_128.mat';
patient(3).samprate = 999.41211;
patient(3).ipsi_region(1).lfpnum = 32;%32=CA2/DG per Jon; 31=CA3/DG per Jon (noisy); 30=SUB per Jon (though it is noisy)
patient(3).ipsi_region(2).lfpnum = [];
patient(3).ipsi_region(3).lfpnum = [];%33 = parahippocampal (peri/para border) white matter near collateral eminence per Jon; 34 = PH cortex white matter near collateral sulcus per Jon
patient(3).ipsi_region(4).lfpnum = [20,21];%stimulated channels = 20 & 21
patient(3).ipsi_region(5).lfpnum = 32;%region 5 = all possible hippocampus electrodes; see above for notes
patient(3).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(3).ipsi_region(7).lfpnum = 33;%perirhinal cortex channels
patient(3).contra_region(1).lfpnum = [];
patient(3).contra_region(2).lfpnum = [];
patient(3).contra_region(3).lfpnum = [];
patient(3).contra_region(4).lfpnum = [];
patient(3).contra_region(5).lfpnum = [];
patient(3).contra_region(6).lfpnum = [];
patient(3).contra_region(7).lfpnum = [];
patient(3).stimchan(1).num = 20;
patient(3).stimchan(2).num = 21;
patient(3).stimchan(3).num = [];
patient(3).stimchan(4).num = [];


patient(4).exp = 'Original';
patient(4).name  = 'amyg005';%pervious contralateral lateral temporal lobe resection from TBI
patient(4).syncfn  = 'day1_lfp_096.mat';
patient(4).samprate = 999.41211;
patient(4).ipsi_region(1).lfpnum = [];%no CA1/CA3 ipsi
patient(4).ipsi_region(2).lfpnum = [];%no DG ipsi
patient(4).ipsi_region(3).lfpnum = 107;%border of perirhinal ctx and adjacent white matter per Jon; 108 is same per Jon
patient(4).ipsi_region(4).lfpnum = [102,103];%stimulated channels = 102 & 103
patient(4).ipsi_region(5).lfpnum = [];%region 5 = all possible hippocampus electrodes; see above for notes
patient(4).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(4).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(4).contra_region(1).lfpnum = [];
patient(4).contra_region(2).lfpnum = [];
patient(4).contra_region(3).lfpnum = [];
patient(4).contra_region(4).lfpnum = [];
patient(4).contra_region(5).lfpnum = [];
patient(4).contra_region(6).lfpnum = [];
patient(4).contra_region(7).lfpnum = [];
patient(4).stimchan(1).num = 102;
patient(4).stimchan(2).num = 103;
patient(4).stimchan(3).num = [];
patient(4).stimchan(4).num = [];


patient(5).exp = 'Original';
patient(5).name  = 'amyg007';
patient(5).syncfn  = 'day1_lfp_102.mat';
patient(5).samprate = 999.41211;%based on EDFbrowser and feedback from EMU director (via Cory) to use this rather than 1000
patient(5).ipsi_region(1).lfpnum = 23;%23=CA1/CA2 per Jon; 27 = ventricle adjacent to hippocampus; 26 = subiculum per Jon per Joe via ROSA: 23* = very anterior (but still body of hip); 26 = mid S-T
patient(5).ipsi_region(2).lfpnum = [];%no DG per Jon
patient(5).ipsi_region(3).lfpnum = [];%no PHG per Jon
patient(5).ipsi_region(4).lfpnum = [19,48];%stimulated channels = 19 & 48--19 is noisy, but it doesn't look like we can risk #48
patient(5).ipsi_region(5).lfpnum = [23,26];%region 5 = all possible hippocampus electrodes; see above for notes
patient(5).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(5).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(5).contra_region(1).lfpnum = [];
patient(5).contra_region(2).lfpnum = [];
patient(5).contra_region(3).lfpnum = [];
patient(5).contra_region(4).lfpnum = [];
patient(5).contra_region(5).lfpnum = [];
patient(5).contra_region(6).lfpnum = [];
patient(5).contra_region(7).lfpnum = [];
patient(5).stimchan(1).num = 19;
patient(5).stimchan(2).num = 48;%per Cory--electrode 48 was stimulated on day one, but might not have been plugged into BLA on day 2
patient(5).stimchan(3).num = [];
patient(5).stimchan(4).num = [];


patient(6).exp = 'Original';
patient(6).name  = 'amyg008';
patient(6).syncfn  = 'day1_lfp_078.mat';
patient(6).samprate = 999.41211;%based on EDFbrowser and feedback from EMU director (via Cory) to use this rather than 1000
patient(6).ipsi_region(1).lfpnum = 27;%Per Jon: 24 & 25 = CA1(head/uncal apex); 26 = fimbria near CA3; 27 = CA2/CA3; 28 = CA2; 31 = CA1/2/3 (though noisy) per Joe via ROSA: 24,25 both in head; 27* @ anterior 1/3 S-T, 28 mid S-T
patient(6).ipsi_region(2).lfpnum = [];
patient(6).ipsi_region(3).lfpnum = 52;%Per Jon: 49, 50, 51 = entorhinal cortex; 52, 55, 56, 57 = parahip/entorhinal, 52 is close to PHC/PRC while 55,56,57 are in perirhinal
patient(6).ipsi_region(4).lfpnum = [53,54];%stimulated channels = 53 & 54--53 was noisy
patient(6).ipsi_region(5).lfpnum = [27,24,25,28];%region 5 = all possible hippocampus electrodes; see above for notes
patient(6).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(6).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(6).contra_region(1).lfpnum = [];
patient(6).contra_region(2).lfpnum = [];
patient(6).contra_region(3).lfpnum = [];
patient(6).contra_region(4).lfpnum = [];
patient(6).contra_region(5).lfpnum = [];
patient(6).contra_region(6).lfpnum = [];
patient(6).contra_region(7).lfpnum = [];
patient(6).stimchan(1).num = 53;
patient(6).stimchan(2).num = 54;
patient(6).stimchan(3).num = [];
patient(6).stimchan(4).num = [];


patient(7).exp = 'Original';
patient(7).name  = 'amyg009';
patient(7).syncfn  = 'day1_lfp_070.mat';
patient(7).samprate = 999.41211;
patient(7).ipsi_region(1).lfpnum = 31;%per Jon: 21=uncinate gyrus/head; 31,32,42=CA3/fimbria;33=CA2/CA3; 34 = CA2/CA1 per Joe via ROSA: 21=head; 31=anterior in hip*; 32=fimbria; 33=mid S-T; 34 = mid S-T; 42 = post 1/3 S-T per DARPA:22-25 are CA1/CA3; 34 and 43 are also CA1/CA3 per DARPA
patient(7).ipsi_region(2).lfpnum = [];%per Jon: no DG; per DARPA 32, 33, 41, 42 are all DG
patient(7).ipsi_region(3).lfpnum = [];%no ipsi phg per Jon and per DARPA
patient(7).ipsi_region(4).lfpnum = [12,13];%stimulated channels = 12 & 13
patient(7).ipsi_region(5).lfpnum = [31,21,33,34,42];%region 5 = all possible hippocampus electrodes; see above for notes
patient(7).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(7).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(7).contra_region(1).lfpnum = [];
patient(7).contra_region(2).lfpnum = [];
patient(7).contra_region(3).lfpnum = [];
patient(7).contra_region(4).lfpnum = [];
patient(7).contra_region(5).lfpnum = [];
patient(7).contra_region(6).lfpnum = [];
patient(7).contra_region(7).lfpnum = [];
patient(7).stimchan(1).num = 12;
patient(7).stimchan(2).num = 13;
patient(7).stimchan(3).num = [];
patient(7).stimchan(4).num = [];


patient(8).exp = 'Original';
patient(8).name  = 'amyg010';
patient(8).syncfn  = 'day1_lfp_068.mat';
patient(8).samprate = 499.70714;
patient(8).ipsi_region(1).lfpnum = 33;%per Jon: 31=CA1@head; 32=CA1; 41=CA3/fimbria; 42=CA2/3; 43=CA2; 52=CA3; 53=CA1/2; 51=sub, per Joe via ROSA: 31,32=head; 33*=anterior body; 41=fimbria; 42=mid S-T; 43,51=mid S-T, but close to ventricle; 52=posterior 1/3; 53=post 1/3 but close to ventricle, per DARPA: 31, 34, 53 are CA1/CA3 ;  42, 43 are subiculum per DARPA
patient(8).ipsi_region(2).lfpnum = 33;%per Jon: 33 = DG per DARPA: 32, 33, 52 are DG; 
patient(8).ipsi_region(3).lfpnum = 35;%per Jon: 35 = Parahip gyrus/fusiform gyrus/perirhinal per DARPA: 35 and 36 are perirhinal
patient(8).ipsi_region(4).lfpnum = [22,23];%stimulated channels = 22 & 23
patient(8).ipsi_region(5).lfpnum = [33,31,32,42,43,51,52,53];%region 5 = all possible hippocampus electrodes; see above for notes
patient(8).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(8).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(8).contra_region(1).lfpnum = [];
patient(8).contra_region(2).lfpnum = [];
patient(8).contra_region(3).lfpnum = [];
patient(8).contra_region(4).lfpnum = [];
patient(8).contra_region(5).lfpnum = [];
patient(8).contra_region(6).lfpnum = [];
patient(8).contra_region(7).lfpnum = [];
patient(8).stimchan(1).num = 22;
patient(8).stimchan(2).num = 23;
patient(8).stimchan(3).num = [];
patient(8).stimchan(4).num = [];


patient(9).exp = 'Original';
patient(9).name  = 'amyg011';
patient(9).syncfn  = 'day1_lfp_043.mat';
patient(9).samprate = 999.41211;
patient(9).ipsi_region(1).lfpnum = 35;%per Jon: 35 = CA1, 40 = CA2/3,  %per Jon and DARPA 39 = subiculum (noisy)per Joe via ROSA: 34=head; 35*=anterior hip body; 40 = post 1/3 S-T
patient(9).ipsi_region(2).lfpnum = 34;%per Jon: 34 = DG at head of hip; per DARPA 40 = DG (Jon said 40 was CA2/3)
patient(9).ipsi_region(3).lfpnum = [];%none per Jon or DARPA
patient(9).ipsi_region(4).lfpnum = [29,30];%stimulated channels = 29 & 30
patient(9).ipsi_region(5).lfpnum = [35,34,40];%region 5 = all possible hippocampus electrodes; see above for notes
patient(9).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(9).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(9).contra_region(1).lfpnum = [];
patient(9).contra_region(2).lfpnum = [];
patient(9).contra_region(3).lfpnum = [];
patient(9).contra_region(4).lfpnum = [];
patient(9).contra_region(5).lfpnum = [];
patient(9).contra_region(6).lfpnum = [];
patient(9).contra_region(7).lfpnum = [];
patient(9).stimchan(1).num = 29;
patient(9).stimchan(2).num = 30;
patient(9).stimchan(3).num = [];
patient(9).stimchan(4).num = [];


patient(10).exp = 'Original';
patient(10).name = 'amyg013';
patient(10).syncfn  = 'day1_lfp_101.mat';
patient(10).samprate =  499.70714;
patient(10).ipsi_region(1).lfpnum = 24;%per Jon: 12 = CA1/DG, 22 = uncal apex CA2, 25 = CA1/white matter, 33 = CA1 (posterior); 24, 31, 32=subiculum,per Joe via ROSA: 11,22=head;12=head/body? 13,23,24*=ant body; 25=ant 1/2 but near white; 31=ant body but near ventricle; 32=mid S-T; 33=post 1/3...per DARPA: 12, 14, 24, 25, 33 = CA1/CA3 (12 is noisy); 23, 31, 32 = subiculum
patient(10).ipsi_region(2).lfpnum = 13;%per Jon: 11 =uncal apex DG, 13, 23 = DG; per DARPA: 13 = DG
patient(10).ipsi_region(3).lfpnum = 35;%per Jon: 34, 35 = PHG/white matter (Jon said 22= uncal apex CA2, 26 = white matter)...per DARPA: 22 = Entorhinal; 26, 34, 35 = parahippocampal
patient(10).ipsi_region(4).lfpnum = [2,3];%stimulated channels = 2 & 3, -->once called #1, but corrected on 8/5/16
patient(10).ipsi_region(5).lfpnum = [24,11,12,13,22,23,25,31,32,33];%region 5 = all possible hippocampus electrodes; see above for notes
patient(10).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(10).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(10).contra_region(1).lfpnum = [];
patient(10).contra_region(2).lfpnum = [];
patient(10).contra_region(3).lfpnum = [];
patient(10).contra_region(4).lfpnum = [];
patient(10).contra_region(5).lfpnum = [];
patient(10).contra_region(6).lfpnum = [];
patient(10).contra_region(7).lfpnum = [];
patient(10).stimchan(1).num = 2;
patient(10).stimchan(2).num = 3;
patient(10).stimchan(3).num = [];
patient(10).stimchan(4).num = [];



patient(11).exp = 'Original';
patient(11).name = 'amyg014';
patient(11).syncfn  = 'day1_lfp_054.mat';
patient(11).samprate =  499.70714;
patient(11).ipsi_region(1).lfpnum = 21;%per Jon: 10=uncinate gyrus/head; 20=CA3/fimbria; 21=CA2; 32=CA1/2; 30,31=sub, per Joe via ROSA: 10 = head near both white matter and ventricle; 20=mid ST; 21*=mid ST; 30,31,32 = posterior 1/3 S-T...per DARPA: 10, 11, 12 = CA1/CA2; 21, 31, 32, 33 = CA1/CA3
patient(11).ipsi_region(2).lfpnum = [];%per Jon: no DG...per DARPA: 20 = DG
patient(11).ipsi_region(3).lfpnum = [];%per Jon: no PHG
patient(11).ipsi_region(4).lfpnum = [1,2];%stimulated channels = 1 & 2
patient(11).ipsi_region(5).lfpnum = [21,10,20,30,31,32];%region 5 = all possible hippocampus electrodes; see above for notes
patient(11).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(11).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(11).contra_region(1).lfpnum = [];
patient(11).contra_region(2).lfpnum = [];
patient(11).contra_region(3).lfpnum = [];
patient(11).contra_region(4).lfpnum = [];
patient(11).contra_region(5).lfpnum = [];
patient(11).contra_region(6).lfpnum = [];
patient(11).contra_region(7).lfpnum = [];
patient(11).stimchan(1).num = 1;
patient(11).stimchan(2).num = 2;
patient(11).stimchan(3).num = [];
patient(11).stimchan(4).num = [];


patient(12).exp = 'Original';
patient(12).name = 'amyg015';
patient(12).syncfn  = 'day1_lfp_010.mat';
patient(12).samprate =  499.70714;%based on EDFbrowser and feedback from EMU director (via Cory) to use this rather than 500
patient(12).ipsi_region(1).lfpnum = 13;%per Jon: 14 = CA1, 13 = CA3/DG, 22=subiculum;per DARPA: 14 =  CA1; 12=subiculum, per Joe via ROSA: 12 = ant body; 13* = ant body; 14 = ant body close to ventricle; 22 = mid S-T
patient(12).ipsi_region(2).lfpnum = 12;%per Jon: 12 = DG, 13 = CA3/DG, per DARPA: 13 = DG
patient(12).ipsi_region(3).lfpnum = 31;%per Jon:11=parasubiculum/entorhinal, 21=presubiculum,  23=PHG white matter near CA1, 31=PHG, 33,34=PHG/white matter, ...per DARPA: 23 = perirhinal ctx; 31, 34 = parahippocampal ctx; 11 = entorhinal cortex
patient(12).ipsi_region(4).lfpnum = 2;%stimulated channels = 1 [a] & 2 [c]
patient(12).ipsi_region(5).lfpnum = [13,12,14,22];%region 5 = all possible hippocampus electrodes; see above for note
patient(12).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(12).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(12).contra_region(1).lfpnum = [];
patient(12).contra_region(2).lfpnum = [];
patient(12).contra_region(3).lfpnum = [];
patient(12).contra_region(4).lfpnum = [];
patient(12).contra_region(5).lfpnum = [];
patient(12).contra_region(6).lfpnum = [];
patient(12).contra_region(7).lfpnum = [];
patient(12).stimchan(1).num = 1;
patient(12).stimchan(2).num = 2;
patient(12).stimchan(3).num = [];
patient(12).stimchan(4).num = [];


patient(13).exp = 'Original';
patient(13).name = 'amyg016';
patient(13).syncfn  = 'day1_lfp_060.mat';
patient(13).samprate =  999.41211;
patient(13).ipsi_region(1).lfpnum = [];%per Jon: no ipsi hippocampus, DG, PHG; 
patient(13).ipsi_region(2).lfpnum = [];
patient(13).ipsi_region(3).lfpnum = [];
patient(13).ipsi_region(4).lfpnum = [66,67];%stimulated channels = 66 [c] & 67 [a]
patient(13).ipsi_region(5).lfpnum = [];%region 5 = all possible hippocampus electrodes; see above for notes
patient(13).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(13).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(13).contra_region(1).lfpnum = [];
patient(13).contra_region(2).lfpnum = [];
patient(13).contra_region(3).lfpnum = [];
patient(13).contra_region(4).lfpnum = [];
patient(13).contra_region(5).lfpnum = [];
patient(13).contra_region(6).lfpnum = [];
patient(13).contra_region(7).lfpnum = [];
patient(13).stimchan(1).num = 66;
patient(13).stimchan(2).num = 67;
patient(13).stimchan(3).num = [];
patient(13).stimchan(4).num = [];


patient(14).exp = 'Original';
patient(14).name = 'amyg017';
patient(14).syncfn  = 'day1_lfp_017.mat';
patient(14).samprate =  499.70714;
patient(14).ipsi_region(1).lfpnum = 1;%per Jon: 1=ambient gyrus of uncus; 21=ventricle near head of hip; 22=ventricle above CA2...per DARPA: 11, 12, 13, 21, 22, 23 = CA1; 11 is noisy
patient(14).ipsi_region(2).lfpnum = [];%per Jon: no DG
patient(14).ipsi_region(3).lfpnum = 25;%per Jon:  PHG...per DARPA: 1 = entorhinal cortex; 25 = perirhinal cortex
patient(14).ipsi_region(4).lfpnum = [2,3];%stimulated channels = 2[a] & 3 [c] -- put cathode here!
patient(14).ipsi_region(5).lfpnum = 1;%region 5 = all possible hippocampus electrodes; see above for notes
patient(14).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(14).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(14).contra_region(1).lfpnum = [];
patient(14).contra_region(2).lfpnum = [];
patient(14).contra_region(3).lfpnum = [];
patient(14).contra_region(4).lfpnum = [];
patient(14).contra_region(5).lfpnum = [];
patient(14).contra_region(6).lfpnum = [];
patient(14).contra_region(7).lfpnum = [];
patient(14).stimchan(1).num = 2;
patient(14).stimchan(2).num = 3;
patient(14).stimchan(3).num = [];
patient(14).stimchan(4).num = [];


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
patient(15).exp = 'Duration';
patient(15).name = 'amyg030'; % log filename stays this way, because the unilateral (R) is marked as 'unilateral'
patient(15).syncfn = 'day1bilateral_lfp_106.mat';
patient(15).samprate = 1023.999;
patient(15).ipsi_region(1).lfpnum = 99; %hippocampal CA fields - Martina: 3 (2Rd2) in CA1, maybe 4 (2Rd4) but mainly in wm, 99 (3Ld2)in CA1/CA3 (possibly DG too)
patient(15).ipsi_region(2).lfpnum = 100; % dentate gyrus - Martina: 100 (3Ld3) DG
patient(15).ipsi_region(3).lfpnum = []; %parahippocampal gyrus 
patient(15).ipsi_region(4).lfpnum = [88,89]; % bilateral stim: stimulated channels 1Ld1 (88) [a], 1Ld2 (89) [c]
patient(15).ipsi_region(5).lfpnum = [10, 40, 41, 98, 101];%all hippocampal regions - Martina: 98 (3Ld1) subiculum, 101 (3Ld4) CA1/DG boundary 
patient(15).ipsi_region(6).lfpnum = [];%entorhinal cortex channels - Martina: NAN
patient(15).ipsi_region(7).lfpnum = [];%perirhinal cortex channels - Martina: NAN
patient(15).contra_region(1).lfpnum = [3,11];%hippocampal CA fields - Martina: 3 (2Rd2) in CA1, maybe 4 (2Rd4) but mainly in wm,
patient(15).contra_region(2).lfpnum = 2;% dentate gyrus - Martina: 2 (Rd1)DG
patient(15).contra_region(3).lfpnum = 38;%parahippocampal gyrus - Martina: 38 (10Rd1) in PHC gray matter, 39 (10Rd2) in cingulum wm
patient(15).contra_region(4).lfpnum = [48,49]; % bilateral stim: stimulated channels 12Rd2 (48) [c], 12Rd3 (49) [a]
patient(15).contra_region(5).lfpnum = []; %all hippocampal regions - Martina: 10 (4Rd1) subiculum/CA1, 12 (4Rd3) in wm close to CA1, 40 (10Rd3) posterior CA1/subiculum boundary, 41 (10Rd4) posterior CA1/DG boundary
patient(15).contra_region(6).lfpnum = [];%entorhinal cortex channels - Martina: NAN
patient(15).contra_region(7).lfpnum = [];%perirhinal cortex channels - Martina: NAN
patient(15).stimchan(1).num = 88; %1Ld1 [a]
patient(15).stimchan(2).num = 89; %1Ld2 [c]
patient(15).stimchan(3).num = 48; %12Rd2 [c]
patient(15).stimchan(4).num = 49; %12Rd3 [a]

%no imm test on any recording
patient(16).exp = 'Duration';
patient(16).name = 'amyg033';
patient(16).syncfn = 'day1_lfp_100.mat';
patient(16).samprate = 1024.004;
patient(16).ipsi_region(1).lfpnum = [14,23]; %hippocampal CA fields - Martina: 14 (4Rd3) CA1/DG, 23 (6Rd2) CA1
patient(16).ipsi_region(2).lfpnum= []; %dentate gyrus
patient(16).ipsi_region(3).lfpnum = []; %parahippocampal gyrus
patient(16).ipsi_region(4).lfpnum = [2,3]; %stimulated channels 2 [c] and 3 [a]
patient(16).ipsi_region(5).lfpnum= [13,22, 62]; %all hippocampal regions - Martina: 13 (4Rd2) subiculum, 22 (6Rd1) subiculum, 62 (14Rd1) subiculum, 171 (36Rd1) cingulum wm/parasubiculum/ERC, 172 (36Rd2) cingulum wm/CA1
patient(16).ipsi_region(6).lfpnum = 12; %entorhinal cortex channels - Martina: 12 (4Rd1) ERC and presubiculum boundary
patient(16).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(16).contra_region(1).lfpnum = [];
patient(16).contra_region(2).lfpnum = [];
patient(16).contra_region(3).lfpnum = [];
patient(16).contra_region(4).lfpnum = [];
patient(16).contra_region(5).lfpnum = [];
patient(16).contra_region(6).lfpnum = [];
patient(16).contra_region(7).lfpnum = [];
patient(16).stimchan(1).num = 2;%2Rd1 [c]
patient(16).stimchan(2).num = 3;%2Rd2 [a]
patient(16).stimchan(3).num = [];
patient(16).stimchan(4).num = []; 


%multiple runs, taking the novel session (L)
%LFP channels extracted from L stim session? not sure
%no imm test on any recording
patient(17).exp = 'Duration';
patient(17).name = 'amyg034' ;%log file name stays this as the other stim hemi (R) is marked as 'Ramyg'
patient(17).syncfn = 'day1_lfp_055.mat';
patient(17).samprate = 1024.004;
patient(17).ipsi_region(1).lfpnum = [11, 17, 18, 19, 20]; %hippocampal CA fields - Martina: 11 (3Ld3) CA1/DG boundary, 17 (5Ld1) CA3/ventricle, 18 (5Ld2) CA3/DG, 19 (5Ld3) CA2/CA1/DG, 20 (5Ld4) CA1/ventricle,
patient(17).ipsi_region(2).lfpnum = 10; %dentate gyrus - Martina: 10 (3Ld2)
patient(17).ipsi_region(3).lfpnum = []; %parahippocampal gyrus
patient(17).ipsi_region(4).lfpnum = [2,3]; %stimulated channels 2 [c] and 3[a]
patient(17).ipsi_region(5).lfpnum = [9, 37]; %all hippocampal regions - Martina: 9 (3Ld1) subiculum, 
patient(17).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(17).ipsi_region(7).lfpnum = []; %perirhinal cortex channels
patient(17).contra_region(1).lfpnum = [40,49]; %hippocampal CA fields - Martina: 40 (4Rd4) CA1/ventricle boundary, 49 (6Rd3) CA1/DG boundary
patient(17).contra_region(2).lfpnum = [38,39];%dentate gyrus - Martina: 38 (4Rd2) DG, 39 (4Rd3) DG/CA1 boundary
patient(17).contra_region(3).lfpnum = []; %parahippocampal gyrus
patient(17).contra_region(4).lfpnum = [28,29];
patient(17).contra_region(5).lfpnum = 37; %all hippocampal regions - Martina:37 (4Rd1) subiculum/DG/CA1 boundary
patient(17).contra_region(6).lfpnum = [];%entorhinal cortex channels
patient(17).contra_region(7).lfpnum = [];%perirhinal cortex channels
patient(17).stimchan(1).num = 2; %1Ld2 [c]
patient(17).stimchan(2).num = 3; %1Ld3 [a]
patient(17).stimchan(3).num = 28; %2Rd2 [c] session 2 stimulation
patient(17).stimchan(4).num = 29; %2Rd3 [a] session 2 stimulation


% 
% %%% no lfp data on our server %%%%%%
% patient(18).exp = 'Duration';
% patient(18).name = 'amyg037';
% patient(18).syncfn = '' ;%no lfp datafile on Rolston server
% patient(18).samprate = 1023.999;
% patient(18).ipsi_region(1).lfpnum = [28, 11, 12, 121, 20, 21]; %hippocampal CA fields - Martina: 28 (7Ld2) dorsolateral CA1, above PRG, 11 (3Ld2) CA1, 12 (3Ld3) CA1/DG, 20 (5Ld2) CA3/subiculum/CA1, 21 (5Ld3) CA1 (some DG)
% patient(18).ipsi_region(2).lfpnum = 117; %dentate gyrus - Martina: 117 (2Rd3) DG 
% patient(18).ipsi_region(3).lfpnum = []; %parahippocampal gyrus
% patient(18).ipsi_region(4).lfpnum = [2,3]; %stimulated channels 2 1Ld1[c] and 3 1Ld2[a]
% patient(18).ipsi_region(5).lfpnum = 19; %all hippocampal regions-Martina: 19 (5Ld1) subiculum/DG
% patient(18).ipsi_region(6).lfpnum = [98,99]; %entorhinal cortex - Martina: 98 (23Ld1) ERC, 99 (23Ld2) ERC/PRC boundary
% patient(18).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
% patient(18).contra_region(1).lfpnum = [116,121];%hippocampal CA fields - Martina:116 (2Rd1) CA3/DG, 121 (4Rd3) CA1/DG boundary
% patient(18).contra_region(2).lfpnum = [];%DG
% patient(18).contra_region(3).lfpnum = [];%PHG
% patient(18).contra_region(4).lfpnum = [];%amygdala stim
% patient(18).contra_region(5).lfpnum = 120;%all HPC- Martina: 120 (4Rd1) subiculum,
% patient(18).contra_region(6).lfpnum = [];%EC
% patient(18).contra_region(7).lfpnum = [];%PRC
% patient(18).stimchan(1).num = 2;%1Ld1 [c]
% patient(18).stimchan(2).num = 3;%1Ld2 [a]
% patient(18).stimchan(3).num = [];
% patient(18).stimchan(4).num = []; 


%need to check with Jon since this pt had Left hipp resection
%no lfp data for Lamyg stim (no Lhipp)
patient(18).exp = 'Duration';
patient(18).name = 'amyg042';  %log filename is this because the other side (L) has no hippocampus
patient(18).syncfn = 'day1_lfp_161.mat';
patient(18).samprate = 1024.004;
patient(18).ipsi_region(1).lfpnum = [123, 131]; %hippocampal CA fields - Martina: 123 (2Rd3) CA1, 131 (4Rd3) posterior CA1
patient(18).ipsi_region(2).lfpnum = [121, 122,]; %dentate gyrus - Martina: 121 (2Rd1) DG, 122 (2Rd2) DG/CA1,
patient(18).ipsi_region(3).lfpnum = 129; %parahippocampal gyrus - Martina: 129 (4Rd1) PRG
patient(18).ipsi_region(4).lfpnum = [138,139]; %stimulated channels
patient(18).ipsi_region(5).lfpnum = 130; %all hippocampal regions - Martina: 130 (4Rd2) posterior subiculum/DG
patient(18).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(18).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(18).contra_region(1).lfpnum = [];
patient(18).contra_region(2).lfpnum = [];%DG
patient(18).contra_region(3).lfpnum = [];%PHG
patient(18).contra_region(4).lfpnum = [2,3];%amygdala stim
patient(18).contra_region(5).lfpnum = [];%all HPC
patient(18).contra_region(6).lfpnum = [];%EC
patient(18).contra_region(7).lfpnum = [];%PRC
patient(18).stimchan(1).num = 138; %6Rd2 [c]
patient(18).stimchan(2).num = 139;%6Rd3 [a]
patient(18).stimchan(3).num = 2; %1Ld2 [c]
patient(18).stimchan(4).num = 3; %1Ld3 [a]


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                  AMME TIMING PATIENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%% taking the first novel session when subject has multiple sessions %%%%
patient(19).exp = 'Timing';
patient(19).name = 'amyg045'; %has to be EXACTLY what the log file says - doing Left Amyg, log filename is 'amyg045_Lamyg'
patient(19).syncfn  = 'day1Lamyg_lfp_062.mat'; %looking at L stim 
patient(19).samprate = 1024.004;%based on EDFbrowser 
patient(19).ipsi_region(1).lfpnum = [14, 15, 24];%hippocampal CA fields - Martina: 14 (3Ld3) CA1/DG, 15 (3Ld4) CA1/TLateralVentricle, 24 (5Ld3) CA1/CA2/CA3/HP molecular layer
patient(19).ipsi_region(2).lfpnum = [];%dentate gyrus 
patient(19).ipsi_region(3).lfpnum = [108, 109];%parahippocampal gyrus - Martina: 108 (25Ld1) parahippocampal cortex, 109 (25Ld2) parahippocampal cortex/cingulate wm
patient(19).ipsi_region(4).lfpnum = [3,56];%amygdala stim channels
patient(19).ipsi_region(5).lfpnum = [12, 13, 22, 23];%all hippocampal - Martina: 12 (3Ld1) presubiculum/parasubiculum/CA1, 13 (3Ld2) CA1/subiculum/DG, 22 (5Ld1) subiculum/presubiculum/DG, 23 (5Ld2) subiculum/CA1/CA4, 
patient(19).ipsi_region(6).lfpnum = 2; %entorhinal cortex channels - Martina: 2 (1Ld1) EC/Periamygdaloid cortex 
patient(19).ipsi_region(7).lfpnum = [];%perirhinal cortex channels 
patient(19).contra_region(1).lfpnum = 145;%hippocampal CA fields - Martina:145 (4Rd4) CA1/cingulum wm/subiculum/PRC
patient(19).contra_region(2).lfpnum = [];%DG
patient(19).contra_region(3).lfpnum = [];%PHG
patient(19).contra_region(4).lfpnum = [2,3];%amygdala stim
patient(19).contra_region(5).lfpnum = 144;%all HPC- Martina: 144 (4Rd3) subiculum/CA1/DG
patient(19).contra_region(6).lfpnum = [142,143];%entorhinal cortex channels - Martina:142 (4Rd1) parasubiculum/EC/uncal notch, 143 (4Rd2) EC/presubiculum/ cingulum wm
patient(19).contra_region(7).lfpnum = 146;%perirhinal cortex channels - Martina: 146 (4Rd5) PRC
patient(19).stimchan(1).num = 3; %1Ld3 [a]
patient(19).stimchan(2).num = 56; %13Ld2 [c]
patient(19).stimchan(3).num = 2; %2Rd2 [c]
patient(19).stimchan(4).num = 3; %2Rd3 [a]


patient(20).exp = 'Timing';
patient(20).name = 'amyg046' ; %has to be EXACTLY what the log file says - Martina changed file name from amyg046_Lamyg to amyg046. 'Lamyg' was redundant info as only that hemi was stimulated
patient(20).syncfn  = 'day1_lfp_048.mat';
patient(20).samprate = 1024.004;%based on EDFbrowser 
patient(20).ipsi_region(1).lfpnum = [];%hippocampal CA fields 
patient(20).ipsi_region(2).lfpnum = 8;%dentate gyrus - 8 (3Ld3) DG/CA1
patient(20).ipsi_region(3).lfpnum = [];%parahippocampal gyrus
patient(20).ipsi_region(4).lfpnum = 3;%stim channels 3[c] and NaN[a]
patient(20).ipsi_region(5).lfpnum = []; % all hippocampal regions
patient(20).ipsi_region(6).lfpnum = [2, 7]; %entorhinal cortex channels - Martina: 2 (1Ld1) EC/BLVM amyg, 7 (3Ld1) EC/subiculum
patient(20).ipsi_region(7).lfpnum = 9;%perirhinal cortex channels - Martina: 9 (3Ld5) PRC/ cignulum wm
patient(20).contra_region(1).lfpnum = 96;%hippocampal CA fields - Martina: 96 (28Rd2) posterior CA1
patient(20).contra_region(2).lfpnum = [];%DG
patient(20).contra_region(3).lfpnum = [];%PHG
patient(20).contra_region(4).lfpnum = [];%amygdala stim
patient(20).contra_region(5).lfpnum = [];%all HPC
patient(20).contra_region(6).lfpnum = [];%EC
patient(20).contra_region(7).lfpnum = [];%PRC
patient(20).stimchan(1).num = NaN; %in EDF browser this channel doesn't exist? %should i use NaN or []?
patient(20).stimchan(2).num = 3; %
patient(20).stimchan(3).num = [];
patient(20).stimchan(4).num = [];

% notes say no lfp data for amyg or hippocampus, ONLY EC STIM LFP DATA
patient(21).exp = 'Timing';
patient(21).name = 'amyg047' ; %has to be EXACTLY what the log file says - Martina changed filename from amyg043p_lamyg2a3c to 'amyg047'. As per Cory's notes this subject was ran by Kelly and they wrote down the wrong subject number. Also this is the only amyg stim for this subject
patient(21).syncfn  = 'day1_lfp_134.mat';
patient(21).samprate = 1024.004;%based on EDFbrowser 
patient(21).ipsi_region(1).lfpnum = [65, 66, 67, 77];%hippocampal CA fields - 65 (3Ld2) CA1/DG, 66 (3Ld3) CA3/DG, 67 (3Ld4) CA1/TLVentricle, 77 (5Ld4) CA1/TLVentricle 
patient(21).ipsi_region(2).lfpnum = [];%dentate gyrus
patient(21).ipsi_region(3).lfpnum = [121, 115];% parahippocampal gyrus - Martina: 121 (23Ld2)  posterior PHG, 115 (21Ld4) parahippocampal cortex/fusifum cortex
patient(21).ipsi_region(4).lfpnum = [54,55];%stim channels 1Ld2 54[a] and 1Ld3 55[c]
patient(21).ipsi_region(5).lfpnum = [74, 75, 76, 84, 85, 86, 112];%all hippocampal regions - Martina: 74 (5Ld1) mainly in ventricle/parasubiculum, 75 (5Ld2) parasubiculum/CA3/CA4, 76 (5Ld3) CA3/DG/CA4, 84 (7Ld1) mainly in ventricle/parasubiculum, 85 (7Ld2) mainly in ventricle/parasubiculum/subiculum, 86 (7Ld3) subiculum/CA3, 112 (21Ld1) presubiculum/parasubiculum
patient(21).ipsi_region(6).lfpnum = [102, 103, 104]; %entorhinal cortex channels - Martina: 102 (19Ld1) ERC/ventricle, 103 (19Ld2) ERC, 
patient(21).ipsi_region(7).lfpnum = [94, 95, 105, 106];%perirhinal cortex channels - Martina: 94 (17Ld1) PRC, 95 (17Ld2) PRC/wm, 105 (19Ld4) PRC, 106 (19Ld5) PRC/fusiform wm/PHG
patient(21).contra_region(1).lfpnum = [];%hippocampal CA fields
patient(21).contra_region(2).lfpnum = [];%DG
patient(21).contra_region(3).lfpnum = [];%PHG
patient(21).contra_region(4).lfpnum = [];%amygdala stim
patient(21).contra_region(5).lfpnum = [];%all HPC
patient(21).contra_region(6).lfpnum = [];%EC
patient(21).contra_region(7).lfpnum = [];%PRC
patient(21).stimchan(1).num = 55;%1Ld2
patient(21).stimchan(2).num = 54;%1Ld3 - Martina: anode stim electrode is partially in EC
patient(21).stimchan(3).num = [];
patient(21).stimchan(4).num = [];


%sampling rate differs between day1 and day2 - lots of movement in T1 and we don't have a preop T1 MRI for this, only postop T1. The electrodeartifact is present
patient(22).exp = 'Timing';
patient(22).name = 'amyg048'; %has to be EXACTLY what the log file says - Martina changed file name from amyg048_Lamyg to amyg048. 'Lamyg' was redundant info as only that hemi was stimulated
patient(22).syncfn  = 'day1Lamyg_lfp_030.mat';
patient(22).samprate = 1024;%day1 1024, day2 1023.999
patient(22).ipsi_region(1).lfpnum = [11, 16, 17];%hippocampal CA fields - Martina: 11 (3Ld3) CA1/PRC, 16 (5Ld2) potentially CA3/DG, 17 (5Ld3) potentially CA1/CA2/DG
patient(22).ipsi_region(2).lfpnum = [];%dentate gyrus
patient(22).ipsi_region(3).lfpnum = [] ;%parahippocampal gyrus
patient(22).ipsi_region(4).lfpnum = [2,3];%stim channels 2[c] and 3[a]
patient(22).ipsi_region(5).lfpnum = [8, 9, 10, 15];% all hippocampal regions - Martina: 8 (3Ld1) parasuibulum/EC, 9 (3Ld2) subiculum/CA3, 10 (3Ld3) subiculum/CA1, 15 (5Ld1) potentially pre/parasubiculum
patient(22).ipsi_region(6).lfpnum = 1; %entorhinal cortex channels - Martina: 1 (1Ld1) EC/BLVM amyg, 
patient(22).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(22).contra_region(1).lfpnum = [];%hippocampal CA fields
patient(22).contra_region(2).lfpnum = [];%DG
patient(22).contra_region(3).lfpnum = [];%PHG
patient(22).contra_region(4).lfpnum = [];%amygdala stim
patient(22).contra_region(5).lfpnum = [];%all HPC
patient(22).contra_region(6).lfpnum = [];%EC
patient(22).contra_region(7).lfpnum = [];%PRC
patient(22).stimchan(1).num = 2;
patient(22).stimchan(2).num = 3;
patient(22).stimchan(3).num = [];
patient(22).stimchan(4).num = [];


patient(23).exp = 'Timing';
patient(23).name = 'amyg053'; %has to be EXACTLY what the log file says - Martina changed file name from amyg053_Ramyg to amyg053. 'Ramyg' was redundant info as only that hemi was stimulated
patient(23).syncfn  = 'day1_lfp_071.mat'; 
patient(23).samprate = 1023.999;
patient(23).ipsi_region(1).lfpnum = [79,86];%hippocampal CA fields - Martina: 79 (4Rd4) CA1/DG/cingulum wm, 86 (6Rd2) CA1/DG/subiculum
patient(23).ipsi_region(2).lfpnum = [];%dentate gyrus 
patient(23).ipsi_region(3).lfpnum = [];%parahippocampal gyrus
patient(23).ipsi_region(4).lfpnum = [68,69];%stim channels 68[c] and 69[a]
patient(23).ipsi_region(5).lfpnum = [77,78,85];%all hippocampal regions - Martina: 77 (4Rd2) subiculum/CA3/CA1, 78 (4Rd3) subiculum/CA1/DG, 85 (6Rd1) subiculum/DG
patient(23).ipsi_region(6).lfpnum = 76; %entorhinal cortex channels - Martina: 76 (4Rd1) EC/presubiculum
patient(23).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(23).contra_region(1).lfpnum = [];%hippocampal CA fields
patient(23).contra_region(2).lfpnum = [];%DG
patient(23).contra_region(3).lfpnum = [];%PHG
patient(23).contra_region(4).lfpnum = [];%amygdala stim
patient(23).contra_region(5).lfpnum = [];%all HPC
patient(23).contra_region(6).lfpnum = [];%EC
patient(23).contra_region(7).lfpnum = [];%PRC
patient(23).stimchan(1).num = 68; %2Rd1 [c]
patient(23).stimchan(2).num = 69; %2Rd2 [a]
patient(23).stimchan(3).num = [];
patient(23).stimchan(4).num = [];


%%% taking the first novel session when subject has multiple sessions %%%%
%after trial 130 we are missing 4 trials - it is documented. Trial 131 is
%actually trial 134.
patient(24).exp = 'Timing';
patient(24).name = 'amyg054' ; %has to be EXACTLY what the log file says - Martina changed file name from amyg054_Lamyg to amyg054. 'Lamyg' was redundant info as only that hemi was stimulated
patient(24).syncfn  = 'day1Lamyg_lfp_138.mat';
patient(24).samprate = 1024.004;%based on EDFbrowser 
patient(24).ipsi_region(1).lfpnum = [85, 95];% hippocampal CA fields - Martina: 85 (17Ld4) CA1/TLVentricle, 95 (19Ld4) CA1/TLVentricle
patient(24).ipsi_region(2).lfpnum = [];% dentate gyrus
patient(24).ipsi_region(3).lfpnum = 43;% parahippocampal gyrus - Martina: 43 (9Ld2) PHG/PRC/mainly wm
patient(24).ipsi_region(4).lfpnum = [73, 74];%stim channels 15Ld3 73[c] and 15Ld4 74[a]
patient(24).ipsi_region(5).lfpnum = [83, 84, 92, 93];%all hippocampal regions - Martina: 83 (17Ld2) presubiculum/subiculum/DG/PRC, 84 (17Ld3) subiculum/CA1/DG, 92 (19Ld1) parasubiculum/PHG, 93 (19Ld2) subiculum/DG
patient(24).ipsi_region(6).lfpnum = [52, 72, 82]; %entorhinal cortex channels - Martina: 52 (11Ld1) EC/PRC boundary, some wm, 72 (15Ld1) EC/BLVM boundary, 82 (17Ld1) EC/presubiculum/parasubiculum
patient(24).ipsi_region(7).lfpnum = [32, 33, 34, 35, 42, 53];%perirhinal cortex channels - Martina: 32 (7Ld1) very anterior PRC/EC, 33 (7Ld2) very anterior PRC, 34 (7Ld3) very anterior PRC, 35 (7Ld4) very anterior PRC/fusiform(BA20), 42 (9Ld1) PRC/rhinal sulcus/ventricle, 53 (11Ld2) PRC/PHG
patient(24).contra_region(1).lfpnum = 164;%hippocampal CA fields - Martina: 164 (18Rd3) CA1/DG/PHG (fusiform)
patient(24).contra_region(2).lfpnum = [];%DG
patient(24).contra_region(3).lfpnum = [];%PHG
patient(24).contra_region(4).lfpnum = [];%amygdala stim
patient(24).contra_region(5).lfpnum = 163;%all HPC - Martina: 163 (18Rd2) subiculum/DG
patient(24).contra_region(6).lfpnum = [152,16];%EC - Martina: 152 (16Rd1) EC,162 (18Rd1) EC/presubiculum/parasubiculum 
patient(24).contra_region(7).lfpnum = [];%PRC
patient(24).stimchan(1).num = 73; %15Ld3 73[c] 
patient(24).stimchan(2).num = 74; %15Ld4 74[a]
patient(24).stimchan(3).num = []; 
patient(24).stimchan(4).num = []; 

%check if 067 was just a typo and these data are truly for amyg057
patient(25).exp = 'Timing';
patient(25).name = 'amyg057'; %has to be EXACTLY what the log file says - log file says 'amyg057_bipolar'
patient(25).syncfn  = 'day1bipolar_lfp_050.mat';
patient(25).samprate = 1024;%based on EDFbrowser 
patient(25).ipsi_region(1).lfpnum = [31, 32];% hippocampal CA fields - Martina: 31 (7Ld1) CA1/BLVL amyg, 32 (7Ld2) CA1/TLVentricle
patient(25).ipsi_region(2).lfpnum = [];%dentate gyrus
patient(25).ipsi_region(3).lfpnum = [];%parahippocampal gyrus
patient(25).ipsi_region(4).lfpnum = [22,23];%stim channels 5Ld2 22[c] and5Ld3 23[a]
patient(25).ipsi_region(5).lfpnum = [];%all hippocampal regions
patient(25).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(25).ipsi_region(7).lfpnum = [];%perirhinal cortex channels
patient(25).contra_region(1).lfpnum = [];%hippocampal CA fields
patient(25).contra_region(2).lfpnum = [];%DG
patient(25).contra_region(3).lfpnum = [];%PHG
patient(25).contra_region(4).lfpnum = [];%amygdala stim
patient(25).contra_region(5).lfpnum = [];%all HPC
patient(25).contra_region(6).lfpnum = [];%EC
patient(25).contra_region(7).lfpnum = [];%PRC
patient(25).stimchan(1).num = 22; %5Ld2 [c]
patient(25).stimchan(2).num = 23; %5Ld3 [a]
patient(25).stimchan(3).num = 23; %monopolar stim - 5Ld3
patient(25).stimchan(4).num = []; 


patient(26).exp = 'Timing';
patient(26).name = 'amyg059'; %has to be EXACTLY what the log file says - Martina changed file name from amyg059_Lamyg to amyg059. 'Lamyg' was redundant info as only that hemi was stimulated
patient(26).syncfn  = 'day1_lfp_128.mat';
patient(26).samprate = 1024;%based on EDFbrowser 
patient(26).ipsi_region(1).lfpnum = [11, 12, 21];%hippocampal CA fields - Martina: 11 (3Ld1) CA1, 12 (3Ld2) CA1/TLVentricle, 21 (5Ld3) CA1/DG
patient(26).ipsi_region(2).lfpnum = [];%dentate gyrus
patient(26).ipsi_region(3).lfpnum = [22, 67, 68, 69];%parahippocampal gyrus- Martina: 22 (5Ld4) PHG/parahipp cortex, 67 (15Ld1) PHG/maybe PRC, 68 (15Ld2) PHG/PHC, 69 (15Ld3) PHG
patient(26).ipsi_region(4).lfpnum = [2,3];%stim channels 3[c] and 2[a]
patient(26).ipsi_region(5).lfpnum = 20;%all hippocampal regions - Martina: 20 (5Ld2) subiculum
patient(26).ipsi_region(6).lfpnum = []; %entorhinal cortex channels
patient(26).ipsi_region(7).lfpnum = 59;%perirhinal cortex channels - Martina: 59 (13Ld1) PRC
patient(26).contra_region(1).lfpnum = [];%hippocampal CA fields
patient(26).contra_region(2).lfpnum = [];%DG
patient(26).contra_region(3).lfpnum = [];%PHG
patient(26).contra_region(4).lfpnum = [];%amygdala stim
patient(26).contra_region(5).lfpnum = [];%all HPC
patient(26).contra_region(6).lfpnum = [];%EC
patient(26).contra_region(7).lfpnum = [];%PRC
patient(26).stimchan(1).num = 3; %Martina:  potentially just before LA - 1Ld3 [a]
patient(26).stimchan(2).num = 2; %Martina: in periamygdaloid cortex/PRC = 1Ld2 [c]
patient(26).stimchan(3).num = [];
patient(26).stimchan(4).num = [];


%%% taking the first novel session when subject has multiple sessions %%%% - second session is bilateral bipolar stimulation
patient(27).exp = 'Timing';
patient(27).name = 'amyg060'; %has to be EXACTLY what the log file says - this is the unilateral Lamyg stim
patient(27).syncfn  = 'day1Lamyg_lfp_222.mat';
patient(27).samprate = 1024;%based on EDFbrowser 
patient(27).ipsi_region(1).lfpnum = [12, 14, 24];%hippocampal CA fields - Martina: 12 (3Ld2) CA1/ventricle, 14 (3Ld4) CA1/TLVentricle a bit,  24 (5Ld4) CA1/DG, 134 (6Rd4) CA1/subiculum/DG
patient(27).ipsi_region(2).lfpnum = 13;%dentate gyrus - Martina: 13 (3Ld3) DG/CA3/CA1
patient(27).ipsi_region(3).lfpnum = []; %PHG
patient(27).ipsi_region(4).lfpnum = [2,3];%stim channels 2[c] and [a]
patient(27).ipsi_region(5).lfpnum = [11, 21, 22, 23];%all hippocampal regions - Martina: 11(3Ld1) subiculum/presubiculum/CA1, 21 (5Ld1) parasubiuclum/Ventricle/EC, 22 (5Ld2) presubiuclum/subiculum, 23 (5Ld3) subiculum/DG, 
patient(27).ipsi_region(6).lfpnum = [1, 71]; %entorhinal cortex channels - Martina: (1Ld1) EC/BLVM amyg, 71 (15Ld1) EC/PRC boundary
patient(27).ipsi_region(7).lfpnum = [72, 73];%perirhinal cortex channels - Martina: 72 (15Ld2) PRC, 73 (15Ld3) PRC/cingulum wm
patient(27).contra_region(1).lfpnum = [122, 134];%hippocampal CA fields - Martina: 122 (4Rd2) CA1/subiculum,
patient(27).contra_region(2).lfpnum = [123, 124, 133];%DG - Martina:  123 (4Rd3) DG/subiculum/presubiulum, 124 (4Rd4)DG/CA1/subiculum, 133 (6Rd3) subiculum/DG
patient(27).contra_region(3).lfpnum = [131, 191, 192];%parahippocampal gyrus - Martina: 131 (6Rd1) PHG/PHC/EC/Ventricle, 191 (18Rd1) PHG/PHC/EC, 192 (18Rd2) PHG/PHC/fusiform (BA20) boundary
patient(27).contra_region(4).lfpnum = [112,113];%amygdala stim
patient(27).contra_region(5).lfpnum = 121;%all HPC - Martina:  121 (4Rd1) presubiculum/subiculum/CA1
patient(27).contra_region(6).lfpnum = [111, 112, 181, 182];%EC - Martina: 111 (2Rd1) ambiens gyrus/EC, 112 (2Rd2) right side cathode stim electrode in EC/BLVM amyg,  181 (16Rd1) EC, 182 (16Rd2) EC
patient(27).contra_region(7).lfpnum = 183;%PRC - Martina: 183 (16Rd3) PRC
patient(27).stimchan(1).num = 2; %1ld2[c]
patient(27).stimchan(2).num = 3; %1ld3[a]
patient(27).stimchan(3).num = 112; % 2rd2[c]
patient(27).stimchan(4).num = 113; % 2rd3 [a]



patient(28).exp = 'Timing';
patient(28).name = 'amyg061'; %has to be EXACTLY what the log file says -Martina changed file name from amyg061_Ramyg to amyg061. 'Ramyg' was redundant info as only that hemi was stimulated
patient(28).syncfn  = 'day1_lfp_127.mat';
patient(28).samprate = 1024;%based on EDFbrowser 
patient(28).ipsi_region(1).lfpnum = [102, 85, 66, 95];%hippocampal CA fields - Martina: 102 (12Rd3) CA1/cingulum wm, 85 (4Rd2) CA1/TLVentricle, 66 (28Rd1) CA1/CA3/TLVentricle,95 (6Rd4) CA2/CA1/TLVentricle
patient(28).ipsi_region(2).lfpnum = [84, 94];%dentate gyrus - Martina: 84 (4Rd1) DG/CA3/CA1, 94 (6Rd3) DG/subiculum/CA3
patient(28).ipsi_region(3).lfpnum = 103;%parahippocampal gyrus - Martina: 103 (12Rd4) PHG/cingulum wm/maybe PRC, 
patient(28).ipsi_region(4).lfpnum = [75,76];%stim channels 2Rd2 75[a] and 2Rd3 76 [c]
patient(28).ipsi_region(5).lfpnum = [100, 101, 92, 93];%all hippocampal regions - Martina: 100 (12Rd1) subiulum/EC/cingulum wm, 101 (12Rd2) subiculum, 92 (6Rd1) parasubiculum/EC, 93 (6Rd2)parasubiculum/presubiculum 
patient(28).ipsi_region(6).name = []; %entorhinal cortex channels
patient(28).ipsi_region(7).name = [];%perirhinal cortex channels
patient(28).contra_region(1).lfpnum = [];%hippocampal CA fields
patient(28).contra_region(2).lfpnum = [];%DG
patient(28).contra_region(3).lfpnum = [];%PHG
patient(28).contra_region(4).lfpnum = [];%amygdala stim
patient(28).contra_region(5).lfpnum = [];%all HPC
patient(28).contra_region(6).lfpnum = [];%EC
patient(28).contra_region(7).lfpnum = [];%PRC
patient(28).stimchan(1).num = 75; %2Rd2 75[a]
patient(28).stimchan(2).num = 76; %2Rd3 76 [c]
patient(28).stimchan(3).num = [];
patient(28).stimchan(4).num = [];


patient(29).exp = 'Timing';
patient(29).name = 'amyg066'; %has to be EXACTLY what the log file says - Martina changed file name from amyg066_Lamyg to amyg066. 'Lamyg' was redundant info as only that hemi was stimulated
patient(29).syncfn  = 'day1_lfp_257.mat';
patient(29).samprate = 1024;%based on EDFbrowser 
patient(29).ipsi_region(1).lfpnum = [11, 22];%hippocampal CA fields - Martina: 11 (3Ld1) CA1/subiculum, 22(5Ld4) CA1/TLVentricle
patient(29).ipsi_region(2).lfpnum = 21;%dentate gyrus - Martina: 21 (5Ld3) DG/subiculum/CA1
patient(29).ipsi_region(3).lfpnum = [67,68,69,70];%parahippocampal gyrus - Martina: 67 (17Ld1) PHG/PHC/ventircle, 68 (17Ld2) PHG/cingulum wm, 69 (17Ld3) PHG/PHC, 70 (17Ld4) PHG/PHC/fusiform gyrus boundary
patient(29).ipsi_region(4).lfpnum = [2,3];%stim channels 1Ld3 3[c] and 1Ld2 2[a]
patient(29).ipsi_region(5).lfpnum = [19, 20];% all hippocampal regions - Martina: 19 (5Ld1) presubiculum/subiculum/cingulum wm, 20 (5Ld2)subiculum/presubiculum/DG
patient(29).ipsi_region(6).name = [1, 57, 58]; %entorhinal cortex channels - Martina: 1 (1Ld1) EC/ventricle/BLVM amyg, 57 (15Ld1) EC, 58 (15Ld2) EC/PRC boundary
patient(29).ipsi_region(7).name = [140, 59];%perirhinal cortex channels - Martina: 140 (4Rd4) PRC, 59 (15Ld3) PRC/cingulum wm
patient(29).contra_region(1).lfpnum = [138,139];%hippocampal CA fields - Martina: 138 (4Rd2) CA1/DG/subiculum, 139 (4rd3)CA1/DG/subiculum
patient(29).contra_region(2).lfpnum = [];%DG
patient(29).contra_region(3).lfpnum = [];%PHG
patient(29).contra_region(4).lfpnum = [];%amygdala stim
patient(29).contra_region(5).lfpnum = 137;%all HPC - Martina: 137 (4Rd1) subiculum/presubiculum/CA1
patient(29).contra_region(6).lfpnum = [];%EC
patient(29).contra_region(7).lfpnum = [];%PRC
patient(29).stimchan(1).num = 3;%1Ld3 [c]
patient(29).stimchan(2).num = 2;%1Ld2 [a]
patient(29).stimchan(3).num = [];
patient(29).stimchan(4).num = [];


%%% taking the first novel session when subject has multiple sessions %%%%
%%% R sided HPC resection - hard to localize %%%
patient(30).exp = 'Timing';
patient(30).name = 'amyg072'; %has to be EXACTLY what the log file says - logfile says amyg072_Lamyg
patient(30).syncfn  = 'day1Lamyg_lfp_257.mat';
patient(30).samprate = 2048;%based on EDFbrowser 
patient(30).ipsi_region(1).lfpnum = 19;%hippocampal CA fields - Martina: 19 (3Ld4) CA1 
patient(30).ipsi_region(2).lfpnum = 18;% dentate gyrus - Martina: 18 (3Ld3) DG/CA3 / CA1
patient(30).ipsi_region(3).lfpnum = [];%parahippocampal gyrus
patient(30).ipsi_region(4).lfpnum = [3,4];%stim channels 1Ld3 3[c] and 1Ld4 4[a]
patient(30).ipsi_region(5).lfpnum = [16,17];%all hippocampal regions - Martina: 16 (3Ld1) subiculum/EC, 17 (3Ld2) subiculum/DG/CA3
patient(30).ipsi_region(6).name = [1,2]; %entorhinal cortex channels - Martina: 1 (1Ld1) EC, 2 (2Ld2) EC/BLVM amyg
patient(30).ipsi_region(7).name = 20;%perirhinal cortex channels - Martina: 20 (3Ld5) - TLVentricle/cingulum wm/PRC - maybe CA1
patient(30).contra_region(1).lfpnum = [];%hippocampal CA fields
patient(30).contra_region(2).lfpnum = 67;%DG - Martina: 67 (10Rd1) prior resection of HPC tissue, hard to localize - DG/CA3/CA1/PHG
patient(30).contra_region(3).lfpnum = [68,69];%PHG - Martina: 68 (10Rd2) PHG/CA1, 69 (10Rd3) PHG
patient(30).contra_region(4).lfpnum = [33, 34];%amygdala stim - R side had HPC resection
patient(30).contra_region(5).lfpnum = [];%all HPC
patient(30).contra_region(6).lfpnum = [31, 32];%EC - Martina: 31 (2Rd1) EC, 32 (Rd2) EC/basal amyg - FS localization says lateral ofc (check!)
patient(30).contra_region(7).lfpnum = [];%PRC
patient(30).stimchan(1).num = 3;%1Ld3 [c]
patient(30).stimchan(2).num = 4; %1Ld4 [a]
patient(30).stimchan(3).num = 33; %2Rd3 [c]
patient(30).stimchan(4).num = 34; %2Rd4 [a]



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

% patient(18).maxchan = 148; %amyg037
% patient(18).lfp_chan_count = 126;

patient(18).maxchan = 276; %amyg042
patient(18).lfp_chan_count = 161;



%AMME TIMING PATIENTS
patient(19).maxchan = 276; %amyg045
patient(19).lfp_chan_count = 155;

patient(20).maxchan = 276; %amyg046
patient(20).lfp_chan_count = 155;

patient(21).maxchan = 276; %amyg047
patient(21).lfp_chan_count = 155;

%mutliple maxchan and lfpcount for this pt- day1 1:148, day2 2:149
patient(22).maxchan = 148; %amyg048
patient(22).lfp_chan_count = 148;

patient(23).maxchan = 148; %amyg053
patient(23).lfp_chan_count = 148;

patient(24).maxchan = 276; %amyg054
patient(24).lfp_chan_count = 155;

patient(25).maxchan = 276; %amyg057
patient(25).lfp_chan_count = 155;

patient(26).maxchan = 148; %amyg059
patient(26).lfp_chan_count = 148;

patient(27).maxchan = 276; %amyg060
patient(27).lfp_chan_count = 155;

patient(28).maxchan = 148; %amyg061
patient(28).lfp_chan_count = 148;

patient(29).maxchan = 276; %amyg066
patient(29).lfp_chan_count = 155;

patient(30).maxchan = 276 ; %amyg072
patient(30).lfp_chan_count = 155 ;

%% this section is for the Original patients

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Set up the basic format of the                   %
%                       "patient" structure                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for p = 1:length(patient)
    if strcmp(param.exp,patient(p).exp) == 0 || param.exp ~="Original"
        continue
    elseif strcmp(param.name,patient(p).name) == 0
        continue
    end

  patient(p).ipsi_region(1).name = 'ipsi CA fields';
  patient(p).ipsi_region(2).name = 'ipsi DG';
  patient(p).ipsi_region(3).name = 'ipsi PHG';
  patient(p).ipsi_region(4).name = 'ipsi BLA';
  patient(p).ipsi_region(5).name = 'all ipsi hippocampus';
  patient(p).ipsi_region(6).name = 'all ipsi erc'; %entorhinal cortex channels
  patient(p).ipsi_region(7).name = 'all ipsi prc';%perirhinal cortex channels
  patient(p).contra_region(1).name = 'contra CA fields';
  patient(p).contra_region(2).name = 'contra DG';
  patient(p).contra_region(3).name = 'contra PHG';
  patient(p).contra_region(4).name = 'contra BLA';
  patient(p).contra_region(5).name = 'all contra hippocampus';
  patient(p).contra_region(6).name = 'all contra erc'; %entorhinal cortex channels
  patient(p).contra_region(7).name = 'all contra prc';%perirhinal cortex channels
  patient(p).stimchan(1).num = [];
  patient(p).stimchan(2).num = [];
  patient(p).stimchan(3).num = [];
  patient(p).stimchan(4).num = [];

  patient(p).phase(1).name = 'study';
  patient(p).phase(2).name = 'immediate test';
  patient(p).phase(3).name = 'one-day test';
  for ph = 1:3
    patient(p).phase(ph).samprate = patient(p).samprate;
    patient(p).phase(ph).syncfn = patient(p).syncfn;
  end
  patient(p).phase(3).syncfn(4) = '2';%change the sync filename for one-day test to reflect day2 rather than day1

  patient(p).sync_chnum=str2num(patient(p).syncfn(end-6:end-4)); %#ok<ST2NM>
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 READ IN LFPS FROM EDF FILES                      %
%   NOTE: one could alter this to avoid filtering ALL the lfps     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%comment this out after running once for each patient
%FYI: this is the script in which we subtract 1 from the edf channel number (because edf channel 1 = event)
%No 60 cycle removal was done in this script.

 %filter_and_save_lfps%this will take a LONG time



% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %              GET THE START TIMES OF EACH TRIAL                   %
% % % as of 6/1/16, includes study, immediate test, and one-day test   %
% % %   NOTE: each one of these functions was tailored to the sync     %
% % %                  channel for each patient                        %
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % fprintf('Reading log files and getting start times for study AND both test session trials...\n')
% % for p = 1:length(patient)
% %     if strcmp(param.exp,patient(p).exp) == 0 || param.exp ~="Original"
% %         continue
% %     elseif strcmp(param.name,patient(p).name) == 0
% %         continue
% %     end
% %   fprintf('\tWorking on %s . . .', patient(p).name)
% %   cd(patient(p).name)%go into patient's directory
% %   load(patient(p).syncfn)%load the lfp for the sync channel
% %   %get the sync pulse times for the STUDY SESSION
% %   fxn = sprintf('find_%s_study_trial_times(lfp)', patient(p).name);
% %   try
% %     %if it works, just do it
% %     patient(p).phase(1).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
% %   catch
% %     %if it doesn't work, keep moving, but alert us
% %     fprintf(' Could not find study session start times in %s...', fxn)
% %     patient(p).phase(1).trial_start_times = [];%nada
% %   end
% % 
% %   %since we're using same LFP, let's get the sync pulse times for the IMMEDIATE TEST session
% %   fxn = sprintf('find_%s_imm_trial_times(lfp)', patient(p).name);
% %   try
% %     %if it works, just do it
% %     patient(p).phase(2).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
% %   catch
% %     %if it doesn't work, keep moving, but alert us
% %     fprintf(' Could not find immediate test session start times in %s...', fxn)
% %     patient(p).phase(2).trial_start_times = [];%nada
% %   end
% %   clear lfp
% % 
% %   %load the appropriate lfp for the one-day (day #2) test sync file
% %   load(patient(p).phase(3).syncfn)%load the lfp for the sync channel
% %   %get the sync pulse times for the ONE-DAY TEST session
% %   fxn = sprintf('find_%s_day2_trial_times(lfp)', patient(p).name);
% %   try
% %     %if it works, just do it
% %     patient(p).phase(3).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
% %   catch
% %     %if it doesn't work, keep moving, but alert us
% %     fprintf(' Could not find one-day test session start times in %s...', fxn)
% %     patient(p).phase(3).trial_start_times = [];%nada
% %   end
% %   clear lfp
% % 
% % 
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   % read in information about STUDY SESSION from log file %
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% %   logfn = sprintf('%s.log', patient(p).name);
% %   fileID = fopen(logfn);
% %   C = textscan(fileID,'%d %f %s %d %s %*[^\n]', 'HeaderLines',3);
% %   fclose(fileID);
% %   %FYI
% %   %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
% %   %C{2}(1:5) should be RTs for first 5 trials
% %   %C{3}{1} should be 'in', 'out', or 'n/a' , i.e., trial type
% %   %C{4}(1:5) should be 1 (stim) or 0 (no stim) for first five trials
% %   %C{5}{1} should be name of image file for first trial
% % 
% %   if(length(C{1})~=160)
% %     fprintf('Error: there should be 160 trials in study session.  Check %s.\n', logfn);
% %   end
% %   for t = 1:length(C{1})
% %     patient(p).phase(1).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 160
% %     patient(p).phase(1).trial(t).rt = C{2}(t); %in/out decision rt (-1 = no button press)
% %     patient(p).phase(1).trial(t).in_or_out = C{3}{t};%indoor or outdoor (or NA if no button press), as judged by participant
% %     patient(p).phase(1).trial(t).stimulation = C{4}(t);%stimulation = 1; no stimulation = 0
% %     patient(p).phase(1).trial(t).full_im_name = C{5}{t}; %name of image, including path on testing computer
% %     if(length(patient(p).phase(1).trial_start_times)>=t)
% %       patient(p).phase(1).trial(t).start_time = patient(p).phase(1).trial_start_times(t);%time of sync pulse ping for this trial = image onset
% %     else
% %       patient(p).phase(1).trial(t).start_time = [];
% %     end
% %   end%trial
% % 
% % 
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   % read in information about IMMEDIATE TEST from same log file %
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   fileID = fopen(logfn);
% %   %TRIAL	RT	YES/NO	SURE/NOT	CONDITION(stim/nostim/new) IMAGENAME
% %   C = textscan(fileID,'%d %f %s %s %s %s %*[^\n]', 'HeaderLines',166);%we'll skip the whole study session, treating it as "header lines"
% %   fclose(fileID);
% %   if(length(C{1})~=120)
% %     fprintf('Error: there should be 120 trials in immediate test session.  Check %s.\n', logfn);
% %   end
% % 
% %   %FYI
% %   %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
% %   %C{2}(1:5) should be RTs for first 5 trials
% %   %C{3}{1} should be 'yes', 'no', or 'n/a' , i.e., trial type
% %   %C{4}{1} should be 'sure' or 'notsure'
% %   %C{5}{1} should be 'stim', 'nostim', or 'new'
% %   %C{6}{1} should be name of image file for first trial
% % 
% %   for t = 1:length(C{1})
% %     patient(p).phase(2).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 120
% %     patient(p).phase(2).trial(t).rt = C{2}(t); %yes/no decision rt (0 = something wrong)
% %     patient(p).phase(2).trial(t).yes_or_no = C{3}{t};%yes or no (or NA if no button press), as judged by participant
% %     patient(p).phase(2).trial(t).sure_notsure = C{4}{t};%sure or not sure, as judged by participant
% %     patient(p).phase(2).trial(t).trial_type = C{5}{t}; %'stim', 'nostim', or 'new'
% %     patient(p).phase(2).trial(t).full_im_name = C{6}{t}; %name of image, including path on testing computer
% % 
% %     if(length(patient(p).phase(2).trial_start_times)>=t)
% %       patient(p).phase(2).trial(t).start_time = patient(p).phase(2).trial_start_times(t);%time of sync pulse ping for this trial = image onset
% %     else
% %       patient(p).phase(2).trial(t).start_time = [];
% %     end
% % 
% %   end%trial
% % 
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   % read in information about ONE DAY TEST  from 2nd log file %
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   logfn = sprintf('%s_day2.log', patient(p).name);
% %   fileID = fopen(logfn);
% %   C = textscan(fileID,'%d %f %s %s %s %s %*[^\n]', 'HeaderLines',3);%skip 3 header rows
% %   fclose(fileID);
% %   if(length(C{1})~=120)
% %     fprintf('Error: there should be 120 trials in one-day test session.  Check %s.\n', logfn);
% %   end
% % 
% %   %FYI
% %   %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
% %   %C{2}(1:5) should be RTs for first 5 trials
% %   %C{3}{1} should be 'yes', 'no', or 'n/a' , i.e., trial type
% %   %C{4}{1} should be 'sure' or 'notsure'
% %   %C{5}{1} should be 'stim', 'nostim', or 'new'
% %   %C{6}{1} should be name of image file for first trial
% % 
% %   for t = 1:length(C{1})
% %     patient(p).phase(3).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 120
% %     patient(p).phase(3).trial(t).rt = C{2}(t); %yes/no decision rt (0 = something wrong)
% %     patient(p).phase(3).trial(t).yes_or_no = C{3}{t};%yes or no (or NA if no button press), as judged by participant
% %     patient(p).phase(3).trial(t).sure_notsure = C{4}{t};%sure or not sure, as judged by participant
% %     patient(p).phase(3).trial(t).trial_type = C{5}{t}; %'stim', 'nostim', or 'new'
% %     patient(p).phase(3).trial(t).full_im_name = C{6}{t}; %name of image, including path on testing computer
% % 
% %     if(length(patient(p).phase(3).trial_start_times)>=t)
% %       patient(p).phase(3).trial(t).start_time = patient(p).phase(3).trial_start_times(t);%time of sync pulse ping for this trial = image onset
% %     else
% %       patient(p).phase(3).trial(t).start_time = [];
% %     end
% % 
% %   end%trial
% % 
% %   fprintf('done.\n')
% %   cd ..
% % end%patients
% % 



% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %                         PROCESS LOG FILES                        %
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % fprintf('Processing data in log files...\n')
% % for p = 1:length(patient)
% %      if strcmp(param.exp,patient(p).exp) == 0 || param.exp ~="Original"
% %         continue
% %      elseif strcmp(param.name,patient(p).name) == 0
% %         continue
% %     end
% %   for t = 1:length(patient(p).phase(1).trial)
% %     %find where the image from this study trial was tested
% %     tmpstudyname = patient(p).phase(1).trial(t).full_im_name;
% %     testmatch=zeros(120,2);%Number of trials by two tests
% %     for ph = 2:3%immediate test, then one-day test
% %       for t2 = 1:120
% %         testmatch(t2,ph-1) = strcmp(tmpstudyname, patient(p).phase(ph).trial(t2).full_im_name);
% %       end%t2
% %     end%test phases
% % 
% %     %make sure we find one and only one match
% %     if(sum(sum(testmatch))~=1)
% %       fprintf('Error: image not found for patient %s, study trial %d.\n', patient(p).name, t);
% %     end
% % 
% %     patient(p).phase(1).trial(t).whichtest = find(sum(testmatch));%1 = immediate, 2 = one-day
% %     if(isempty(patient(p).phase(1).trial(t).whichtest))
% %       fprintf('Error: no test match for patient %s, study trial %d.\n', patient(p).name, t);
% %     end
% % 
% %     patient(p).phase(1).trial(t).whichtesttrial = find(testmatch(:,patient(p).phase(1).trial(t).whichtest));%trial number
% %     if(isempty(patient(p).phase(1).trial(t).whichtesttrial))
% %       fprintf('Error: no trial match for patient %s, study trial %d.\n', patient(p).name, t);
% %     end
% % 
% %     %sanity check
% %     tmpmatchname = patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).full_im_name;
% %     if(~strcmp(tmpstudyname, tmpmatchname))
% %       fprintf('Error: wrong image mtch for patient %s, study trial %d.\n', patient(p).name, t);
% %     end
% % 
% % 
% %     %get test info to match to study image
% %     patient(p).phase(1).trial(t).test_rt = ...
% %       patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).rt;
% % 
% %     patient(p).phase(1).trial(t).test_yes_no = ...
% %       patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).yes_or_no;
% % 
% %     patient(p).phase(1).trial(t).test_sure_notsure = ...
% %       patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).sure_notsure;
% % 
% %     patient(p).phase(1).trial(t).test_trial_type = ... %sanity check
% %       patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).trial_type;
% %     %if this doesn't match, we gotta problem
% %     if(patient(p).phase(1).trial(t).stimulation==1)
% %       temptype = 'stim';
% %     else
% %       temptype = 'nostim';
% %     end
% %     if(~strcmp(temptype, patient(p).phase(1).trial(t).test_trial_type))
% %       fprintf('Error: wrong trial type for patient %s, test %d trial %d.\n', patient(p).name, ...
% %         patient(p).phase(1).trial(t).whichtest,...
% %         patient(p).phase(1).trial(t).whichtesttrial);
% %     end
% % 
% %   end%end of study trials
% % end%patient
% % 


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                 Find the median lfp of all lfps                  %
% %                 global median can be used later                  %
% %                 to re-reference all the channels                 %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%pause(10)%pause for 10 seconds before starting this

fprintf('Calculating median LFP ...\n')

for p = 1:length(patient)
    if strcmp(param.exp,patient(p).exp) == 0 || param.exp ~="Original"
        continue
    elseif strcmp(param.name,patient(p).name) == 0
        continue
    end
  fprintf('\tWorking on patient %d...\n',p)
  cd(patient(p).name)%go into patient's directory
  for d=1:2
    fprintf('\t\tDay %d...\n',d)
    tmplfpfn = sprintf('day%d_lfp_%03d.mat',d,1);%load first lfp just to find out how long it is
    load(tmplfpfn)%load the lfp from the .mat file;
    lfplen = length(lfp);
    clear lfp
    tempalllfps = zeros(patient(p).maxchan,lfplen);
    fprintf('\t\t...')
    for ch = 1:patient(p).maxchan
      fprintf(' %d ',ch)
      tmplfpfn = sprintf('day%d_lfp_%03d.mat',d,ch);
      load(tmplfpfn)%load the lfp from the .mat file; 
      if(length(lfp)~=lfplen)
        fprintf('\n...error: lfp %d not same length as first lfp...\n',ch)
      end
      tempalllfps(ch,:) = lfp;
      clear lfp
    end%channel
    fprintf('\n')

    %let's take out the sync channel and, on day 1, the stim channels
    tempdelch = str2num(patient(p).syncfn(end-6:end-4)); %#ok<ST2NM>
    if(d==1)
      for sc = 1:length(patient(p).stimchan)%take out ipsi stim channels on day 1
        tempdelch = [tempdelch patient(p).stimchan(sc).num]; %#ok<AGROW>
      end
    end
    tempalllfps(tempdelch, :) = [];%delete the unwanted channels
    medlfp = median(tempalllfps);
    clear tempalllfps
    tmpmedlfpfn = sprintf('day%d_median_lfp.mat',d);%file name
    save(tmpmedlfpfn,'medlfp');
    clear medlfp

  end%day
  cd ..
end%patient


fprintf('\tDone; median LFPs saved as .mat files ...\n')


 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %                   GET THE LFPS FOR IPSILATERAL                   %
% % %                 CA FIELDS, DG, AND PHG, EC, PRC                  %
% % %                from the study phase, if available                %
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % fprintf('Getting LFP data for ispilateral select regions...\n')
% % 
% % params.fpass=[1 120]; % band of frequencies to be kept
% % params.tapers=[1 1]; % taper parameters
% % params.pad=1; % pad factor for fft
% % params.err=[2 0.05];
% % params.trialave=1;
% % movingwin = [.5 .05];
% % 
% % addpath("mtit")
% % addpath('chronux_2_12')
% % 
% % for p = 1:length(patient)
% %     if strcmp(param.exp,patient(p).exp) == 0 || param.exp ~="Original"
% %         continue
% %     elseif strcmp(param.name,patient(p).name) == 0
% %         continue
% %     end
% %   fprintf('\tWorking on patient %d...\n',p)
% %   cd(patient(p).name)%go into patient's directory
% %   params.Fs=patient(p).samprate;
% %   %hard-coded here to get 10 seconds (-5 to +5 around image onset)
% %   sampsbefore = round(patient(p).samprate * 5);
% %   sampsafter = round(patient(p).samprate * 5);
% %   for ph=1:3
% %     fprintf('\t\tPhase %d...\n',ph)
% %     if(ph<3)
% %       d=1;
% %     else
% %       d=2;
% %     end
% %     %load median lfp for re-referencing
% %     load(sprintf('day%d_median_lfp.mat',d));%variable called medlfp
% % 
% %     for rg = 1:length(patient(p).ipsi_region)
% %       for lnum = 1:length(patient(p).ipsi_region(rg).lfpnum)
% % 
% %         if(ph<3)
% %           tmplfpfn = sprintf('day1_lfp_%03d.mat',patient(p).ipsi_region(rg).lfpnum(lnum));
% %         else
% %           tmplfpfn = sprintf('day2_lfp_%03d.mat',patient(p).ipsi_region(rg).lfpnum(lnum));
% %         end
% % 
% %         load(tmplfpfn)%load the lfp from the .mat file; not 100% efficient to load first day's lfp twice, but whatevs
% % 
% %         %subtract median lfp from this lfp--same as digitally re-referencing
% %         lfp = lfp-medlfp;
% %         lfp=rmlinesmovingwinc(lfp,[1.5 .5],10,params,.00000001,'n', 60);%remove 60 Hz noise
% %         lfp=rmlinesmovingwinc(lfp,[2 1],10,params,.00000001,'n', 42);%remove 42 Hz noise (source?); use [2 1] since not as bad
% % 
% %         for t = 1:1:length(patient(p).phase(ph).trial)
% %           try
% %             tempindex = round(patient(p).phase(ph).trial(t).start_time*patient(p).samprate);
% %             tmplfp = lfp(tempindex-sampsbefore:tempindex+sampsafter-1);
% %           catch myerror
% %             fprintf('\t\tproblem on region %d, trial %d, lfpnum %d, filling in with NaNs...\n',rg, t, lnum)
% %             fprintf('\t\tError = %s.\n', myerror.message);
% %             tmplfp = zeros(sampsbefore+sampsafter,1) .* NaN;
% %             %patient #9, phase 2, all trials regions 1, 2, and 4 (not 3)--error matrix exceeds dimensions
% %             %patient #14, phase 1, trials 141-149, regions 1, 3, and 4 (not 2)--Nonfinite endpoints or increment for colon operator in index
% %           end
% %           if(rg<5)
% %             patient(p).phase(ph).trial(t).region(rg).lfp = tmplfp;
% %           else
% %             patient(p).phase(ph).trial(t).region(rg).lfp(lnum).data = tmplfp;
% %           end
% %         end%end of trials
% % 
% %         clear lfp
% % 
% % 
% %       end%lnum
% %     end%region
% %   end%phase
% %   cd ..
% % end%patient
% % 
% % fprintf('done with MTL subfield LFPs for Original subjects .\n')
% % 
% % save('AMMEpatientstruct.mat','patient');
% % %save(name of output file, name of variable in workspace)

%% this section is for AMME Duration patients

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Set up the basic format of the                   %
%                       "patient" structure                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for p = 1:length(patient)
    if strcmp(param.exp,patient(p).exp) == 0 || param.exp ~="Duration"
        continue
    %elseif strcmp(param.name,patient(p).name) == 0
     %   continue
    end
  patient(p).ipsi_region(1).name = 'ipsi CA fields';
  patient(p).ipsi_region(2).name = 'ipsi DG';
  patient(p).ipsi_region(3).name = 'ipsi PHG';
  patient(p).ipsi_region(4).name = 'ipsi BLA';
  patient(p).ipsi_region(5).name = 'all ipsi hippocampus';
  patient(p).ipsi_region(6).name = 'all ipsi erc'; %entorhinal cortex channels
  patient(p).ipsi_region(7).name = 'all ipsi prc';%perirhinal cortex channels
  patient(p).contra_region(1).name = 'contra CA fields';
  patient(p).contra_region(2).name = 'contra DG';
  patient(p).contra_region(3).name = 'contra PHG';
  patient(p).contra_region(4).name = 'contra BLA';
  patient(p).contra_region(5).name = 'all contra hippocampus';
  patient(p).contra_region(6).name = 'all contra erc'; %entorhinal cortex channels
  patient(p).contra_region(7).name = 'all contra prc';%perirhinal cortex channels
  patient(p).stimchan(1).num = [];
  patient(p).stimchan(2).num = [];
  patient(p).stimchan(3).num = [];
  patient(p).stimchan(4).num = [];


  patient(p).phase(1).name = 'study';
  patient(p).phase(2).name = 'immediate test';
  patient(p).phase(3).name = 'one-day test';
  for ph = 1:3
    patient(p).phase(ph).samprate = patient(p).samprate;
    patient(p).phase(ph).syncfn = patient(p).syncfn;
  end
  patient(p).phase(3).syncfn(4) = '2';%change the sync filename for one-day test to reflect day2 rather than day1

  patient(p).sync_chnum=str2num(patient(p).syncfn(end-6:end-4)); %#ok<ST2NM>
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 READ IN LFPS FROM EDF FILES                      %
%   NOTE: one could alter this to avoid filtering ALL the lfps     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%comment this out after running once for each patient
%FYI: this is the script in which we subtract 1 from the edf channel number (because edf channel 1 = event)
%No 60 cycle removal was done in this script.

 %filter_and_save_lfps%this will take a LONG time




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              GET THE START TIMES OF EACH TRIAL                   %
% as of 6/1/16, includes study, immediate test, and one-day test   %
%   NOTE: each one of these functions was tailored to the sync     %
%                  channel for each patient                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % fprintf('Reading log files and getting start times for study AND both test session trials...\n')
% % for p = 1:length(patient)
% %     if strcmp(param.exp,patient(p).exp) == 0 || param.exp ~="Duration"
% %         continue
% %     elseif strcmp(param.name,patient(p).name) == 0
% %         continue
% %     end
% %   fprintf('\tWorking on %s . . .', patient(p).name)
% %   cd(patient(p).name)%go into patient's directory
% %   load(patient(p).syncfn)%load the lfp for the sync channel
% %   %get the sync pulse times for the STUDY SESSION
% %   fxn = sprintf('find_%s_study_trial_times(lfp)', patient(p).name);
% %   try
% %     %if it works, just do it
% %     patient(p).phase(1).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
% %   catch
% %     %if it doesn't work, keep moving, but alert us
% %     fprintf(' Could not find study session start times in %s...', fxn)
% %     patient(p).phase(1).trial_start_times = [];%nada
% %   end
% % 
% %   %since we're using same LFP, let's get the sync pulse times for the IMMEDIATE TEST session
% %   fxn = sprintf('find_%s_imm_trial_times(lfp)', patient(p).name);
% %   try
% %     %if it works, just do it
% %     patient(p).phase(2).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
% %   catch
% %     %if it doesn't work, keep moving, but alert us
% %     fprintf(' Could not find immediate test session start times in %s...', fxn)
% %     patient(p).phase(2).trial_start_times = [];%nada
% %   end
% %   clear lfp
% % 
% %   %load the appropriate lfp for the one-day (day #2) test sync file
% %   load(patient(p).phase(3).syncfn)%load the lfp for the sync channel
% %   %get the sync pulse times for the ONE-DAY TEST session
% %   fxn = sprintf('find_%s_day2_trial_times(lfp)', patient(p).name);
% %   try
% %     %if it works, just do it
% %     patient(p).phase(3).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
% %   catch
% %     %if it doesn't work, keep moving, but alert us
% %     fprintf(' Could not find one-day test session start times in %s...', fxn)
% %     patient(p).phase(3).trial_start_times = [];%nada
% %   end
% %   clear lfp
% % 
% % 
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   % read in information about STUDY SESSION from log file %
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% %   logfn = sprintf('%s.log', patient(p).name);
% %   fileID = fopen(logfn);
% %   C = textscan(fileID,'%d %f %s %d %s %s %s %s %*[^\n]', 'HeaderLines',3);
% %   fclose(fileID);
% %   %FYI
% %   %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
% %   %C{2}(1:5) should be RTs
% %   %C{3}{1} should be 'in', 'out', or 'n/a' , i.e., trial type
% %   %C{4}(1:5) should be 1 (1 sec stim), 3 (3 sec stim), or 0 (no stim)
% %   %C{5}{1} should be name of image file
% %   %C{6}{1} - amplitude of stimulation in microamps
% %   %C{7}{1} - sync from starting time in seconds
% %   %C{8}{1} - GetSecs computer clock 
% % 
% %   if(length(C{1})~=240)
% %     fprintf('Error: there should be 240 trials in study session.  Check %s.\n', logfn);
% %   end
% %   for t = 1:length(C{1})
% %     patient(p).phase(1).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 240
% %     patient(p).phase(1).trial(t).rt = C{2}(t); %in/out decision rt (-1 = no button press)
% %     patient(p).phase(1).trial(t).in_or_out = C{3}{t};%indoor or outdoor (or NA if no button press), as judged by participant
% %     patient(p).phase(1).trial(t).stimulation = C{4}(t);%stimulation = 1; no stimulation = 0
% %     patient(p).phase(1).trial(t).full_im_name = C{5}{t}; %name of image, including path on testing computer
% %     patient(p).phase(1).trial(t).amp = C{6}{t};%amplitude in microamps
% %     patient(p).phase(1).trial(t).sycnfromstart = C{7}{t}; %sync from starting time in seconds - cumulative
% %     patient(p).phase(1).trial(t).getsecs = C{8}{t}; % GetSecs computer's inner clock
% % 
% %     if(length(patient(p).phase(1).trial_start_times)>=t)
% %       patient(p).phase(1).trial(t).start_time = patient(p).phase(1).trial_start_times(t);%time of sync pulse ping for this trial = image onset
% %     else
% %       patient(p).phase(1).trial(t).start_time = [];
% %     end
% %   end%trial
% % 
% % 
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   % read in information about IMMEDIATE TEST from same log file %
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   fileID = fopen(logfn);
% %   %TRIAL	RT	YES/NO	SURE/NOT	CONDITION(stim/nostim/new) IMAGENAME
% %   C = textscan(fileID,'%d %f %f %s %s %s %s %s %s %s %s %*[^\n]','HeaderLines',246);%we'll skip the whole study session, treating it as "header lines" %MKH is 246 the accurate number of headers to skip here?????
% %   fclose(fileID);
% %   if(length(C{1})~=200)
% %     fprintf('Error: there should be 200 trials in immediate test session.  Check %s.\n', logfn);
% %   end
% % 
% %   %FYI
% %   %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
% %   %C{2}(1:5) should be RTs 
% %   %C{3}{1} should be confidence RTs
% %   %C{4}{1} should be 'yes', 'no', or 'n/a' , i.e., trial type
% %   %C{5}{1} should be 'sure' or 'notsure'
% %   %C{6}{1} should be condition of '1s stim', '3s stim', 'nostim', or 'new'
% %   %C{7}{1} should be name of image file for first trial
% %   %C{8}{1} -sync from starting time in seconds
% %   %C{9}{1} - GetSecs computer clock
% %   %C{10}{1} - YesNo Time on computer clock
% %   %C{11}{1} - Sure NotSure Time on computer clock
% % 
% %   for t = 1:length(C{1})
% %     patient(p).phase(2).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 200
% %     patient(p).phase(2).trial(t).rt = C{2}(t); %yes/no decision rt (0 = something wrong)
% %     patient(p).phase(2).trial(t).confrt = C{3}(t); %sure/not sure decision rt (0 = something wrong)
% %     patient(p).phase(2).trial(t).yes_or_no = C{4}{t};%yes or no (or NA if no button press), as judged by participant
% %     patient(p).phase(2).trial(t).sure_notsure = C{5}{t};%sure or not sure, as judged by participant
% %     patient(p).phase(2).trial(t).trial_type = C{6}{t}; %'1s stim', '3s stim', 'nostim', or 'new'
% %     patient(p).phase(2).trial(t).full_im_name = C{7}{t}; %name of image, including path on testing computer
% %     patient(p).phase(2).trial(t).syncfromstart = C{8}{t}; %sync from starting time in seconds
% %     patient(p).phase(2).trial(t).getsecs = C{9}{t}; %GetSecs computer clock
% %     patient(p).phase(2).trial(t).yesno_clock = C{10}{t}; %YesNo Time on computer clock
% %     patient(p).phase(2).trial(t).surenotsure_clock = C{11}{t}; %Sure NotSure Time on computer clock
% % 
% %     if(length(patient(p).phase(2).trial_start_times)>=t)
% %       patient(p).phase(2).trial(t).start_time = patient(p).phase(2).trial_start_times(t);%time of sync pulse ping for this trial = image onset
% %     else
% %       patient(p).phase(2).trial(t).start_time = [];
% %     end
% % 
% %   end%trial
% % 
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   % read in information about ONE DAY TEST  from 2nd log file %
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   logfn = sprintf('%s_day2.log', patient(p).name);
% %   fileID = fopen(logfn);
% %    C = textscan(fileID,'%d %f %f %s %s %s %s %s %s %s %s %*[^\n]', 'HeaderLines',3);%skip 3 header rows
% %   fclose(fileID);
% %   if(length(C{1})~=200)
% %     fprintf('Error: there should be 200 trials in one-day test session.  Check %s.\n', logfn);
% %   end
% % 
% %   %FYI
% %   %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
% %   %C{2}(1:5) should be RTs 
% %   %C{3}{1} should be confidence RTs
% %   %C{4}{1} should be 'yes', 'no', or 'n/a' , i.e., trial type
% %   %C{5}{1} should be 'sure' or 'notsure'
% %   %C{6}{1} should be condition of '1s stim', '3s stim', 'nostim', or 'new'
% %   %C{7}{1} should be name of image file for first trial
% %   %C{8}{1} -sync from starting time in seconds
% %   %C{9}{1} - GetSecs computer clock
% %   %C{10}{1} - YesNo Time on computer clock
% %   %C{11}{1} - Sure NotSure Time on computer clock
% % 
% %   for t = 1:length(C{1})
% %     patient(p).phase(3).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 200
% %     patient(p).phase(3).trial(t).rt = C{2}(t); %yes/no decision rt (0 = something wrong)
% %     patient(p).phase(3).trial(t).confrt = C{3}(t); %sure/not sure decision rt (0 = something wrong)
% %     patient(p).phase(3).trial(t).yes_or_no = C{4}{t};%yes or no (or NA if no button press), as judged by participant
% %     patient(p).phase(3).trial(t).sure_notsure = C{5}{t};%sure or not sure, as judged by participant
% %     patient(p).phase(3).trial(t).trial_type = C{6}{t}; %'1s stim', '3s stim', 'nostim', or 'new'
% %     patient(p).phase(3).trial(t).full_im_name = C{7}{t}; %name of image, including path on testing computer
% %     patient(p).phase(3).trial(t).syncfromstart = C{8}{t}; %sync from starting time in seconds
% %     patient(p).phase(3).trial(t).getsecs = C{9}{t}; %GetSecs computer clock
% %     patient(p).phase(3).trial(t).yesno_clock = C{10}{t}; %YesNo Time on computer clock
% %     patient(p).phase(3).trial(t).surenotsure_clock = C{11}{t}; %Sure NotSure Time on computer clock
% % 
% %     if(length(patient(p).phase(3).trial_start_times)>=t)
% %       patient(p).phase(3).trial(t).start_time = patient(p).phase(3).trial_start_times(t);%time of sync pulse ping for this trial = image onset
% %     else
% %       patient(p).phase(3).trial(t).start_time = [];
% %     end
% % 
% %   end%trial
% % 
% %   fprintf('done.\n')
% %   cd ..
% % end%patients



% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %                         PROCESS LOG FILES                        %
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % fprintf('Processing data in log files...\n')
% % for p = 1:length(patient)
% %     if strcmp(param.exp,patient(p).exp) == 0 || param.exp ~="Duration"
% %         continue
% %     elseif strcmp(param.name,patient(p).name) == 0
% %         continue
% %     end
% %   for t = 1:length(patient(p).phase(1).trial)
% %     %find where the image from this study trial was tested
% %     tmpstudyname = patient(p).phase(1).trial(t).full_im_name;
% %     testmatch=zeros(240,2);%Number of trials by two tests
% %     for ph = 2:3%immediate test, then one-day test
% %       for t2 = 1:200
% %         testmatch(t2,ph-1) = strcmp(tmpstudyname, patient(p).phase(ph).trial(t2).full_im_name);
% %       end%t2
% %     end%test phases
% % 
% %     %make sure we find one and only one match
% %     if(sum(sum(testmatch))~=1)
% %       fprintf('Error: image not found for patient %s, study trial %d.\n', patient(p).name, t);
% %     end
% % 
% %     patient(p).phase(1).trial(t).whichtest = find(sum(testmatch));%1 = immediate, 2 = one-day
% %     if(isempty(patient(p).phase(1).trial(t).whichtest))
% %       fprintf('Error: no test match for patient %s, study trial %d.\n', patient(p).name, t);
% %     end
% % 
% %     patient(p).phase(1).trial(t).whichtesttrial = find(testmatch(:,patient(p).phase(1).trial(t).whichtest));%trial number
% %     if(isempty(patient(p).phase(1).trial(t).whichtesttrial))
% %       fprintf('Error: no trial match for patient %s, study trial %d.\n', patient(p).name, t);
% %     end
% % 
% %     %sanity check
% %     tmpmatchname = patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).full_im_name;
% %     if(~strcmp(tmpstudyname, tmpmatchname))
% %       fprintf('Error: wrong image match for patient %s, study trial %d.\n', patient(p).name, t);
% %     end
% % 
% % 
% %     %get test info to match to study image
% %     patient(p).phase(1).trial(t).test_rt = ...
% %       patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).rt;
% % 
% %     patient(p).phase(1).trial(t).test_yes_no = ...
% %       patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).yes_or_no;
% % 
% %     patient(p).phase(1).trial(t).test_sure_notsure = ...
% %       patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).sure_notsure;
% % 
% %     patient(p).phase(1).trial(t).test_trial_type = ... %sanity check
% %       patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).trial_type;
% %     %if this doesn't match, we gotta problem
% %     if(patient(p).phase(1).trial(t).stimulation==1)
% %       temptype = '1s stim';
% %     elseif (patient(p).phase(1).trial(t).stimulation==3)
% %       temptype = '3s stim';
% %     elseif (patient(p).phase(1).trial(t).stimulation==0)
% %       temptype = 'nostim';
% %     else
% %       temptype = 'new';
% %     end
% % 
% %     if(~strcmp(temptype, patient(p).phase(1).trial(t).test_trial_type))
% %       fprintf('Error: wrong trial type for patient %s, test %d trial %d.\n', patient(p).name, ...
% %         patient(p).phase(1).trial(t).whichtest,...
% %         patient(p).phase(1).trial(t).whichtesttrial);
% %     end
% % 
% %   end%end of study trials
% % end%patient

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                 Find the median lfp of all lfps                  %
% %                 global median can be used later                  %
% %                 to re-reference all the channels                 %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%pause(10)%pause for 10 seconds before starting this

fprintf('Calculating median LFP ...\n')

for p = 1:length(patient)
    if strcmp(param.exp,patient(p).exp) == 0 || param.exp ~="Duration"
        continue
    %elseif strcmp(param.name,patient(p).name) == 0
     %   continue
    end
  fprintf('\tWorking on patient %d...\n',p)
  cd(patient(p).name)%go into patient's directory
  for d=1:2
    fprintf('\t\tDay %d...\n',d) 
    if strcmp(patient(p).name, "amyg030") == 1
        tmplfpfn = sprintf('day%dbilateral_lfp_%03d.mat',d,1);
    else
        tmplfpfn = sprintf('day%d_lfp_%03d.mat',d,1);%load first lfp just to find out how long it is
    end
    load(tmplfpfn)%load the lfp from the .mat file;
    lfplen = length(lfp);
    clear lfp
    tempalllfps = zeros(patient(p).maxchan,lfplen);
    fprintf('\t\t...')
    for ch = 1:patient(p).maxchan
      fprintf(' %d ',ch)
    if strcmp(patient(p).name, "amyg030") == 1
        tmplfpfn = sprintf('day%dbilateral_lfp_%03d.mat',d,ch);
    else
        tmplfpfn = sprintf('day%d_lfp_%03d.mat',d,ch);%load first lfp just to find out how long it is
    end
      load(tmplfpfn)%load the lfp from the .mat file; 
      if(length(lfp)~=lfplen)
        fprintf('\n...error: lfp %d not same length as first lfp...\n',ch)
      end
      tempalllfps(ch,:) = lfp;
      clear lfp
    end%channel
    fprintf('\n')

    %let's take out the sync channel and, on day 1, the stim channels
    tempdelch = str2num(patient(p).syncfn(end-6:end-4)); %#ok<ST2NM>
    if(d==1)
      for sc = 1:length(patient(p).stimchan)%take out stim channels on day 1
        tempdelch = [tempdelch patient(p).stimchan(sc).num]; %#ok<AGROW>
      end
    end
    tempalllfps(tempdelch, :) = [];%delete the unwanted channels
    medlfp = median(tempalllfps);
    clear tempalllfps
    tmpmedlfpfn = sprintf('day%d_median_lfp.mat',d);%file name
    save(tmpmedlfpfn,'medlfp');
    clear medlfp
 end%day
    cd ..
end %patient




fprintf('\tDone; median LFPs saved as .mat files ...\n')


 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   GET THE LFPS FOR IPSILATERAL                   %
%                 CA FIELDS, DG, AND PHG, EC, PRC                  %
%                from the study phase, if available                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % fprintf('Getting LFP data for ispilateral select regions...\n')
% % 
% % params.fpass=[1 120]; % band of frequencies to be kept
% % params.tapers=[1 1]; % taper parameters
% % params.pad=1; % pad factor for fft
% % params.err=[2 0.05];
% % params.trialave=1;
% % movingwin = [.5 .05];
% % 
% % for p = 1:length(patient)
% %     if strcmp(param.exp,patient(p).exp) == 0 || param.exp ~="Duration"
% %         continue
% %     elseif strcmp(param.name,patient(p).name) == 0
% %         continue
% %     end
% %   fprintf('\tWorking on patient %d...\n',p)
% %   cd(patient(p).name)%go into patient's directory
% %   params.Fs=patient(p).samprate;
% %   %hard-coded here to get 10 seconds (-5 to +5 around image onset)
% %   sampsbefore = round(patient(p).samprate * 5);
% %   sampsafter = round(patient(p).samprate * 5);
% %   for ph=1:3
% %     fprintf('\t\tPhase %d...\n',ph)
% %     if(ph<3)
% %       d=1;
% %     else
% %       d=2;
% %     end
% %     %load median lfp for re-referencing
% %     load(sprintf('day%d_median_lfp.mat',d));%variable called medlfp
% % 
% %     for rg = 1:length(patient(p).ipsi_region)
% %       for lnum = 1:length(patient(p).ipsi_region(rg).lfpnum)
% % 
% %         if(ph<3)
% %           tmplfpfn = sprintf('day1_lfp_%03d.mat',patient(p).ipsi_region(rg).lfpnum(lnum));
% %         else
% %           tmplfpfn = sprintf('day2_lfp_%03d.mat',patient(p).ipsi_region(rg).lfpnum(lnum));
% %         end
% % 
% %         load(tmplfpfn)%load the lfp from the .mat file; not 100% efficient to load first day's lfp twice, but whatevs
% % 
% %         %subtract median lfp from this lfp--same as digitally re-referencing
% %         lfp = lfp-medlfp;
% %         lfp=rmlinesmovingwinc(lfp,[1.5 .5],10,params,.00000001,'n', 60);%remove 60 Hz noise
% %         lfp=rmlinesmovingwinc(lfp,[2 1],10,params,.00000001,'n', 42);%remove 42 Hz noise (source?); use [2 1] since not as bad
% % 
% %         for t = 1:1:length(patient(p).phase(ph).trial)
% %           try
% %             tempindex = round(patient(p).phase(ph).trial(t).start_time*patient(p).samprate);
% %             tmplfp = lfp(tempindex-sampsbefore:tempindex+sampsafter-1);
% %           catch myerror
% %             fprintf('\t\tproblem on region %d, trial %d, lfpnum %d, filling in with NaNs...\n',rg, t, lnum)
% %             fprintf('\t\tError = %s.\n', myerror.message);
% %             tmplfp = zeros(sampsbefore+sampsafter,1) .* NaN;
% %             %patient #9, phase 2, all trials regions 1, 2, and 4 (not 3)--error matrix exceeds dimensions
% %             %patient #14, phase 1, trials 141-149, regions 1, 3, and 4 (not 2)--Nonfinite endpoints or increment for colon operator in index
% %           end
% %           if(rg<5)
% %             patient(p).phase(ph).trial(t).region(rg).lfp = tmplfp;
% %           else
% %             patient(p).phase(ph).trial(t).region(rg).lfp(lnum).data = tmplfp;
% %           end
% %         end%end of trials
% % 
% %         clear lfp
% % 
% % 
% %       end%lnum
% %     end%region
% %   end%phase
% %   cd ..
% % end%patient
% % 
% % fprintf('done with MTL subfield LFPs for Duration subjects .\n')
% % save('AMMEpatientstruct.mat','patient');

%% this section is for AMME Timing patients (no immediate test)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Set up the basic format of the                   %
%                       "patient" structure                        %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 for p = 1:length(patient)
    if strcmp(param.exp,patient(p).exp) == 0 || param.exp ~="Timing"
        continue
   % elseif strcmp(param.name,patient(p).name) == 0
    %    continue
    end
  patient(p).ipsi_region(1).name = 'ipsi CA fields';
  patient(p).ipsi_region(2).name = 'ipsi DG';
  patient(p).ipsi_region(3).name = 'ipsi PHG';
  patient(p).ipsi_region(4).name = 'ipsi BLA';
  patient(p).ipsi_region(5).name = 'all ipsi hippocampus';
  patient(p).ipsi_region(6).name = 'all ipsi erc'; %entorhinal cortex channels
  patient(p).ipsi_region(7).name = 'all ipsi prc';%perirhinal cortex channels
  patient(p).contra_region(1).name = 'contra CA fields';
  patient(p).contra_region(2).name = 'contra DG';
  patient(p).contra_region(3).name = 'contra PHG';
  patient(p).contra_region(4).name = 'contra BLA';
  patient(p).contra_region(5).name = 'all contra hippocampus';
  patient(p).contra_region(6).name = 'all contra erc'; %entorhinal cortex channels
  patient(p).contra_region(7).name = 'all contra prc';%perirhinal cortex channels
  patient(p).stimchan(1).num = [];
  patient(p).stimchan(2).num = [];
  patient(p).stimchan(3).num = [];
  patient(p).stimchan(4).num = [];

  patient(p).phase(1).name = 'study';
  patient(p).phase(2).name = 'one-day test';
  for ph = 1:2 
    patient(p).phase(ph).samprate = patient(p).samprate;
    patient(p).phase(ph).syncfn = patient(p).syncfn;
  end
  patient(p).phase(2).syncfn(4) = '2';
  
  patient(p).sync_chnum=str2num(patient(p).syncfn(end-6:end-4)); %#ok<ST2NM> ???
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 READ IN LFPS FROM EDF FILES                      %
%   NOTE: one could alter this to avoid filtering ALL the lfps     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%comment this out after running once for each patient
%FYI: this is the script in which we subtract 1 from the edf channel number (because edf channel 1 = event)
%No 60 cycle removal was done in this script.

 %filter_and_save_lfps%this will take a LONG time



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              GET THE START TIMES OF EACH TRIAL                   %
% as of 6/1/16, includes study, immediate test, and one-day test   %
%   NOTE: each one of these functions was tailored to the sync     %
%                  channel for each patient                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%From these to the end should be different - distinct loops - anywhere there is a phase specification  for each of the experiments

% % fprintf('Reading log files and getting start times for study AND both test session trials...\n')
% % for p = 1:length(patient)
% %     if strcmp(param.exp,patient(p).exp) == 0 || param.exp ~="Timing"
% %         continue
% %     elseif strcmp(param.name,patient(p).name) == 0
% %         continue
% %     end
% %   fprintf('\tWorking on %s . . .', patient(p).name)
% %   sprintf('')
% %   cd(patient(p).name)%go into patient's directory
% %   load(patient(p).syncfn)%load the lfp for the sync channel
% %   %get the sync pulse times for the STUDY SESSION
% %   fxn = sprintf('find_%s_study_trial_times(lfp)', patient(p).name); %reading in file names with '%s' as substitutable with a string variable
% %   try
% %     %if it works, just do it
% %     patient(p).phase(1).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
% %   catch
% %     %if it doesn't work, keep moving, but alert us
% %     fprintf('Could not find study session start times in %s...', fxn)
% %     patient(p).phase(1).trial_start_times = [];%nada
% %   end
% % 
% % 
% %   %load the appropriate lfp for the ONE-DAY TEST (day #2) test sync file
% %   load(patient(p).phase(2).syncfn)%load the lfp for the sync channel
% % 
% %   %get the sync pulse times for the ONE-DAY TEST session
% %   fxn = sprintf('find_%s_day2_trial_times(lfp)', patient(p).name);
% %   try
% %     %if it works, just do it
% %     patient(p).phase(2).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
% %   catch
% %     %if it doesn't work, keep moving, but alert us
% %     fprintf(' Could not find one-day test session start times in %s...', fxn)
% %     patient(p).phase(2).trial_start_times = [];%nada
% %   end
% %   clear lfp
% % 
% % 
% %   %AMME TIMING AND DURATION: THE LOG FILE NAME AND THE PATIENT NAME HAS TO
% %   %MATCH TO THE find_amyg000_phase_trials_times.m FILES
% % 
% % 
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   % read in information about STUDY SESSION from log file %
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% %   if strcmp(patient(p).name, 'amyg045') == 1 || strcmp(patient(p).name, 'amyg072') == 1
% %       logfn = sprintf('%s_Lamyg.log', patient(p).name);
% %       fprintf('Log file name is %s\n',logfn)
% %   elseif strcmp(patient(p).name, 'amyg057') ==1
% %       logfn = sprintf('%s_bipolar.log', patient(p).name);
% %       fprintf('Log file name is %s\n',logfn)
% %   else
% %       logfn = sprintf('%s.log', patient(p).name);
% %       fprintf('Log file name is %s\n',logfn)
% %   end
% % mydir = dir(logfn);
% % 
% % if isempty(mydir)
% %     fprintf('Log file name for day1 is not found for %s!!!\n')
% % end
% % 
% %   fileID = fopen(logfn);
% %   C = textscan(fileID,'%d %f %s %d %s %s %s %s %*[^\n]', 'HeaderLines',3); % reads in 3 header lines 
% %   %means skip to the next line(row) --> %*[^\n]
% %   fclose(fileID);
% % 
% %   %FYI for C = textscan above
% %   %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers %d is for double as whole number
% %   %C{2}(1:5) should be RTs for first 5 trials %f is float w a decimal
% %   %C{3}{1} should be 'in', 'out', or 'n/a' , i.e., trial type
% %   %C{4}(1:5) should be 0, 1, 2, 3 (no stim, before, during, after)
% %   %C{5}{1} should be name of image file for first trial
% %   %C{6}{1} - amplitude of stimulation in microamps
% %   %C{7}{1} - sync from starting time in seconds
% %   %C{8}{1} - GetSecs computer clock 
% % 
% %   if(length(C{1})~=200)
% %     fprintf('Error: there should be 200 trials in study session.  Check %s.\n', logfn); %fprintf displays in command window
% %   end
% %   for t = 1:length(C{1}) %trial = t
% %     patient(p).phase(1).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 200
% %     patient(p).phase(1).trial(t).rt = C{2}(t); %in/out decision rt (-1 = no button press)
% %     patient(p).phase(1).trial(t).in_or_out = C{3}{t};%indoor or outdoor (or NA if no button press), as judged by participant
% %     patient(p).phase(1).trial(t).stimulation = C{4}(t);%0 = nostim, 1=before, 2%= during,3= after
% %     patient(p).phase(1).trial(t).full_im_name = C{5}{t}; %name of image, including path on testing computer
% %     patient(p).phase(1).trial(t).amp = C{6}{t};%amplitude in microamps
% %     patient(p).phase(1).trial(t).sycnfromstart = C{7}{t}; %sync from starting time in seconds - cumulative
% %     patient(p).phase(1).trial(t).getsecs = C{8}{t}; %computer's inner clock
% % 
% %     if(length(patient(p).phase(1).trial_start_times)>=t)
% %       patient(p).phase(1).trial(t).start_time = patient(p).phase(1).trial_start_times(t);%time of sync pulse ping for this trial = image onset
% %     else
% %       patient(p).phase(1).trial(t).start_time = [];
% %     end
% %   end%trial
% % 
% % 
% % %amyg069 and added variables based on the day2 log files
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   % read in information about ONE DAY TEST  from 2nd log file %
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% %   if strcmp(patient(p).name, 'amyg045') == 1 || strcmp(patient(p).name, 'amyg072') == 1
% %       logfn = sprintf('%s_Lamyg_day2.log', patient(p).name);
% %       fprintf('Log file name is %s\n',logfn)
% %   elseif strcmp(patient(p).name, 'amyg057') ==1
% %       logfn = sprintf('%s_bipolar_day2.log', patient(p).name);
% %       fprintf('Log file name is %s\n',logfn)
% %   else
% %       logfn = sprintf('%s_day2.log', patient(p).name);
% %       fprintf('Log file name is %s\n',logfn)
% %   end
% % mydir = dir(logfn);
% % 
% % if isempty(mydir)
% %     fprintf('Log file name for day2 is not found for %s!!!\n')
% % end
% % 
% %   fileID = fopen(logfn);
% %   C = textscan(fileID,'%d %f %s %s %s %s %s %s %s %s %s %*[^\n]', 'HeaderLines',3);%skip 3 header rows
% %   %go to a new line --> %*[^\n] has to be at the end of the textscan format
% %   fclose(fileID);
% %   if(length(C{1})~=300)
% %     fprintf('Error: there should be 300 trials in one-day test session.  Check %s.\n', logfn);
% %   end
% %   %FYI
% %   %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
% %   %C{2}(1:5) should be RTs for first 5 trials
% %   %C{3}{1} should be confirmed RT 
% %   %C{4}{1} should be 'yes', 'no', or 'n/a' , i.e., trial type
% %   %C{5}{1} should be 'sure' or 'notsure'
% %   %C{6}{1} should be 'Before', 'During', 'After', 'new'
% %   %C{7}{1} should be name of image file for first trial
% %   %C{8}{1} sync from start cumulative timing in seconds of sync pulses
% %   %C{9}{1} getsecs - computer's inner clock
% %   %C{10}{1} Yes/No trial cumulative timing in seconds from the start
% %   %C{11}{1} sure/notsure tria cumulative timing in seconds from the start
% % 
% % 
% %   for t = 1:length(C{1})
% %     patient(p).phase(2).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 120
% %     patient(p).phase(2).trial(t).rt = C{2}(t); %yes/no decision rt (0 = something wrong)
% %     patient(p).phase(2).trial(t).confRT = C{3}{t}; %confirmed RT (0 = something wrong)
% %     patient(p).phase(2).trial(t).yes_or_no = C{4}{t};%yes or no (or NA if no button press), as judged by participant
% %     patient(p).phase(2).trial(t).sure_notsure = C{5}{t};%sure or not sure, as judged by participant
% %     patient(p).phase(2).trial(t).trial_type = C{6}{t}; %should be 'Before', 'During', 'After', 'new'
% %     patient(p).phase(2).trial(t).full_im_name = C{7}{t}; %name of image, including path on testing computer
% %     patient(p).phase(2).trial(t).syncfromstart = C{8}{t}; %sync from start cumulative timing in seconds of sync pulses
% %     patient(p).phase(2).trial(t).getsecs = C{9}{t};%getsecs - computer's inner clock
% %     patient(p).phase(2).trial(t).yesno_time = C{10}{t}; %Yes/No trial cumulative timing in seconds from the start
% %     patient(p).phase(2).trial(t).sure_notsure_time = C{11}{t}; %sure/notsure tria cumulative timing in seconds from the start
% % 
% % 
% %     if(length(patient(p).phase(2).trial_start_times)>=t)
% %       patient(p).phase(2).trial(t).start_time = patient(p).phase(2).trial_start_times(t);%time of sync pulse ping for this trial = image onset
% %     else
% %       patient(p).phase(2).trial(t).start_time = [];
% %     end
% % 
% %   end%trial
% % 
% %   fprintf('done.\n')
% %   cd ..
% % end%patients 


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                         PROCESS LOG FILES                        %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% fprintf('Processing data in log files...\n')
% for p = 1:length(patient)
%     if strcmp(param.exp,patient(p).exp) == 0 || param.exp ~="Timing"
%         continue
%     elseif strcmp(param.name,patient(p).name) == 0
%         continue
%     end
%   for t = 1:length(patient(p).phase(1).trial)
%     %find where the image from this study trial was tested
%     tmpstudyname = patient(p).phase(1).trial(t).full_im_name;
%     testmatch=zeros(300,2);%Number of trials by two tests - Martina chaged 120 --> 200
% 
%     for ph = 2% one-day test
%       for t2 = 1:300
%         testmatch(t2, ph) = strcmp(tmpstudyname, patient(p).phase(ph).trial(t2).full_im_name);
%       end%t2
%    end% phases
% 
% 
%     %make sure we find one and only one match - trying to make sure we had
%     %no repeated images between study and test
%     if(sum(sum(testmatch))~=1)
%       fprintf('Error: image not found for patient %s, study trial %d.\n', patient(p).name, t);
%     end
% 
%     patient(p).phase(1).trial(t).whichtest = find(sum(testmatch));
%     if(isempty(patient(p).phase(1).trial(t).whichtest))
%       fprintf('Error: no test match for patient %s, study trial %d.\n', patient(p).name, t);
%     end
% 
%     patient(p).phase(1).trial(t).whichtesttrial = find(testmatch(:,patient(p).phase(1).trial(t).whichtest));%trial number
%     if(isempty(patient(p).phase(1).trial(t).whichtesttrial))
%       fprintf('Error: no trial match for patient %s, study trial %d.\n', patient(p).name, t);
%     end
% 
%     %sanity check
%     tmpmatchname = patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).full_im_name;
%     %tmpmatchname = patient(p).phase(patient(p).phase(1).trial(t).whichtest).trial(patient(p).phase(1).trial(t).whichtesttrial).full_im_name;
%     if(~strcmp(tmpstudyname, tmpmatchname))
%       fprintf('Error: wrong image match for patient %s, study trial %d.\n', patient(p).name, t);
%     end
% 
%     %get test info to match to study image 
%     patient(p).phase(1).trial(t).test_rt = ...
%       patient(p).phase(patient(p).phase(1).trial(t).whichtest).trial(patient(p).phase(1).trial(t).whichtesttrial).rt;
% 
%     patient(p).phase(1).trial(t).test_yes_no = ...
%       patient(p).phase(patient(p).phase(1).trial(t).whichtest).trial(patient(p).phase(1).trial(t).whichtesttrial).yes_or_no;
% 
%     patient(p).phase(1).trial(t).test_sure_notsure = ...
%       patient(p).phase(patient(p).phase(1).trial(t).whichtest).trial(patient(p).phase(1).trial(t).whichtesttrial).sure_notsure;
% 
%     patient(p).phase(1).trial(t).test_trial_type = ... %sanity check
%       patient(p).phase(patient(p).phase(1).trial(t).whichtest).trial(patient(p).phase(1).trial(t).whichtesttrial).trial_type;
% 
%     %if this doesn't match, we gotta problem
%     if(patient(p).phase(1).trial(t).stimulation==1) % this might need to be updated to the types log file col F needs to be in here in an if statement
%       temptype = 'Beforestim'; %study log file matching stim condition to test log file  cond
%     elseif (patient(p).phase(1).trial(t).stimulation==2)
%       temptype = 'Duringstim'; 
%     elseif (patient(p).phase(1).trial(t).stimulation==3)
%       temptype = 'Afterstim';
%     elseif (patient(p).phase(1).trial(t).stimulation==0)
%       temptype = 'nostim';
%     else 
%         temptype = 'new';    %make sure the new trials are not considered nostim trial - is this ok?
%     end
% 
%     if(~strcmp(temptype, patient(p).phase(1).trial(t).test_trial_type)) %strcmp = string comparison
%       fprintf('Error: wrong trial type for patient %s, test %d trial %d.\n', patient(p).name, ...
%         patient(p).phase(1).trial(t).whichtest,...
%         patient(p).phase(1).trial(t).whichtesttrial);
%     end
% 
%  end%end of study trials
% end %patient
% 



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                 Find the median lfp of all lfps                  %
% %                 global median can be used later                  %
% %                 to re-reference all the channels                 %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%pause(10)%pause for 10 seconds before starting this

fprintf('Calculating median LFP ...\n')

for p = 1:length(patient)
    if strcmp(param.exp,patient(p).exp) == 0 || param.exp ~="Timing"
        continue
    %elseif strcmp(param.name,patient(p).name) == 0
     %   continue
    end
  fprintf('\tWorking on patient %d...\n',p)
  cd(patient(p).name)%go into patient's directory
  for d=1:2
    fprintf('\t\tDay %d...\n',d)
      if strcmp(patient(p).name, 'amyg045') == 1 || strcmp(patient(p).name, 'amyg048') == 1 || strcmp(patient(p).name, 'amyg054') == 1 || strcmp(patient(p).name, 'amyg060') == 1 || strcmp(patient(p).name, 'amyg072') == 1
        tmplfpfn = sprintf('day%dLamyg_lfp_%03d.mat', d,1);
        fprintf('LFP file name is %s\n',tmplfpfn)
      elseif strcmp(patient(p).name, 'amyg057') ==1
        tmplfpfn = sprintf('day%dbipolar_lfp_%03d.mat',d,1);
        fprintf('LFP file name is %s\n',tmplfpfn)
      else
        tmplfpfn = sprintf('day%d_lfp_%03d.mat',d,1);
        fprintf('LFP file name is %s\n',tmplfpfn)
      end
    load(tmplfpfn)%load the lfp from the .mat file;
    lfplen = length(lfp);
    clear lfp
    tempalllfps = zeros(patient(p).maxchan,lfplen);
    fprintf('\t\t...')
    
    for ch = 1:patient(p).maxchan
      fprintf(' %d ',ch)
      if strcmp(patient(p).name, 'amyg045') == 1 || strcmp(patient(p).name, 'amyg048') == 1 || strcmp(patient(p).name, 'amyg054') == 1 || strcmp(patient(p).name, 'amyg060') == 1 || strcmp(patient(p).name, 'amyg072') == 1
        tmplfpfn = sprintf('day%dLamyg_lfp_%03d.mat',d,ch);
      elseif strcmp(patient(p).name, 'amyg057') ==1
        tmplfpfn = sprintf('day%dbipolar_lfp_%03d.mat',d,ch);
      else
        tmplfpfn = sprintf('day%d_lfp_%03d.mat',d,ch);
      end
      load(tmplfpfn)%load the lfp from the .mat file; 
      if(length(lfp)~=lfplen)
        fprintf('\n...error: lfp %d not same length as first lfp...\n',ch)
      end
      tempalllfps(ch,:) = lfp;
      clear lfp
    end%channel
    fprintf('\n')

    %let's take out the sync channel and, on day 1, the stim channels
    tempdelch = str2num(patient(p).syncfn(end-6:end-4)); %#ok<ST2NM>
    if(d==1)
      for sc = 1:length(patient(p).stimchan)%take out stim channels on day 1
        tempdelch = [tempdelch patient(p).stimchan(sc).num]; %#ok<AGROW>
      end
    end
    tempalllfps(tempdelch, :) = [];%delete the unwanted channels
    medlfp = median(tempalllfps);
    clear tempalllfps
    tmpmedlfpfn = sprintf('day%d_median_lfp.mat',d);%file name
    save(tmpmedlfpfn,'medlfp');
    clear medlfp

  end%day
  cd ..
end%patient


fprintf('\tDone; median LFPs saved as .mat files ...\n')


 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   GET THE LFPS FOR IPSILATERAL                   %
%                 CA FIELDS, DG, AND PHG, EC, PRC                  %
%                from the study phase, if available                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Getting LFP data for ispilateral select regions...\n')

params.fpass=[1 120]; % band of frequencies to be kept
params.tapers=[1 1]; % taper parameters
params.pad=1; % pad factor for fft
params.err=[2 0.05];
params.trialave=1;
movingwin = [.5 .05];

% % for p = 1:length(patient)
% %     if strcmp(param.exp,patient(p).exp) == 0 || param.exp ~="Timing"
% %         continue
% %     elseif strcmp(param.name,patient(p).name) == 0
% %         continue
% %     end
% %   fprintf('\tWorking on patient %d...\n',p)
% %   cd(patient(p).name)%go into patient's directory
% %   params.Fs=patient(p).samprate;
% %   %hard-coded here to get 10 seconds (-5 to +5 around image onset)
% %   sampsbefore = round(patient(p).samprate * 5);
% %   sampsafter = round(patient(p).samprate * 5);
% %   for ph=1:3
% %     fprintf('\t\tPhase %d...\n',ph)
% %     if(ph<3)
% %       d=1;
% %     else
% %       d=2;
% %     end
% %     %load median lfp for re-referencing
% %     load(sprintf('day%d_median_lfp.mat',d));%variable called medlfp
% % 
% %     for rg = 1:length(patient(p).ipsi_region)
% %       for lnum = 1:length(patient(p).ipsi_region(rg).lfpnum)
% % 
% %         if(ph<3)
% %           tmplfpfn = sprintf('day1_lfp_%03d.mat',patient(p).ipsi_region(rg).lfpnum(lnum));
% %         else
% %           tmplfpfn = sprintf('day2_lfp_%03d.mat',patient(p).ipsi_region(rg).lfpnum(lnum));
% %         end
% % 
% %         load(tmplfpfn)%load the lfp from the .mat file; not 100% efficient to load first day's lfp twice, but whatevs
% % 
% %         %subtract median lfp from this lfp--same as digitally re-referencing
% %         lfp = lfp-medlfp;
% %         lfp=rmlinesmovingwinc(lfp,[1.5 .5],10,params,.00000001,'n', 60);%remove 60 Hz noise
% %         lfp=rmlinesmovingwinc(lfp,[2 1],10,params,.00000001,'n', 42);%remove 42 Hz noise (source?); use [2 1] since not as bad
% % 
% %         for t = 1:1:length(patient(p).phase(ph).trial)
% %           try
% %             tempindex = round(patient(p).phase(ph).trial(t).start_time*patient(p).samprate);
% %             tmplfp = lfp(tempindex-sampsbefore:tempindex+sampsafter-1);
% %           catch myerror
% %             fprintf('\t\tproblem on region %d, trial %d, lfpnum %d, filling in with NaNs...\n',rg, t, lnum)
% %             fprintf('\t\tError = %s.\n', myerror.message);
% %             tmplfp = zeros(sampsbefore+sampsafter,1) .* NaN;
% %             %patient #9, phase 2, all trials regions 1, 2, and 4 (not 3)--error matrix exceeds dimensions
% %             %patient #14, phase 1, trials 141-149, regions 1, 3, and 4 (not 2)--Nonfinite endpoints or increment for colon operator in index
% %           end
% %           if(rg<5)
% %             patient(p).phase(ph).trial(t).region(rg).lfp = tmplfp;
% %           else
% %             patient(p).phase(ph).trial(t).region(rg).lfp(lnum).data = tmplfp;
% %           end
% %         end%end of trials
% % 
% %         clear lfp
% % 
% % 
% %       end%lnum
% %     end%region
% %   end%phase
% %   cd ..
% % end%patient
% % 
% % fprintf('done with MTL subfield LFPs for Timing subjects .\n')
% % 
% % save('AMMEpatientstruct.mat','patient');
%save(name of output file, name of variable in workspace)