#!/bin/bash
#PBS -q batch
#PBS -N proc_ica         
#PBS -l walltime=50:00:00
#PBS -l nodes=1:ppn=4,mem=50gb
#PBS -o proc_fmri.out
#PBS -j oe




cd /Users/xinyizhou/Downloads/kirby
ICn=('1,4')
Ind=0
for d in 20210326_7T_RA.ica/; do
	echo "$d"
	cd $d
        echo ${ICn[$Ind]}
	
	#fsl_regfilt -i ./filtered_func_data.nii.gz -o ./denoised.nii -d ./filtered_func_data.ica/melodic_mix -f ${ICn[$Ind]}
         fsl_regfilt -i ./filtered_func_data.nii.gz -o ./denoised.nii -d ./filtered_func_data.ica/melodic_mix -f 1,4
       # fslchfiletype NIFTI mean_func.nii.gz 
Ind=$Ind+1
       cd ..

done
