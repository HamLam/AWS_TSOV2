## ./run_exome_groups.sh group folder sample_path control_path
## e.g. ./run_exome_groups.sh g1 14-24882 /home/lmnp/lamx0031/CNV_Pipeline/Exome_Data/exome_data/Project_13-13928_May_29_2015_1 /home/lmnp/lamx0031/CNV_Pipeline/Exome_Data/exome_data/Project_14-24882_May_29_2015_1 

#!/bin/bash

PWD=$(pwd);
Option=$1;
folder=$2;
mkdir $folder;
SamplePath=$3;
ControlPath=$4;

FIND=find;

cr1=$(${FIND} $ControlPath | grep R1)
echo $cr1
cr2=$(${FIND} $ControlPath | grep R2)
echo $cr2
sr1=$(${FIND} $SamplePath | grep R1)
echo $sr1
sr2=$(${FIND} $SamplePath | grep R2)
echo $sr2

if [ "$Option" = "g1" ]; then
  echo " Option: $Option "
  sed -e s,e_grp,"$Option",g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > $folder/g1.ini
  sh ${PWD}/hcl_launcher_trim_chr1_chr2.sh ${PWD}/$folder/g1.ini
  qsub -n -q small /scratch.global/lamx0031/${folder}/g1/run_cnv_g1.pbs
  cp /scratch.global/lamx0031/${folder}/g1/run_cnv_g1.pbs ${PWD}/$folder/
 elif [ "$Option" = "g2" ]; then
 echo " Option: $Option "
 sed -e s,e_grp,"$Option",g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > $folder/g2.ini
 sh ${PWD}/hcl_launcher_trim_chr3_chr4_chr5.sh ${PWD}/${folder}/g2.ini
 qsub -n -q small /scratch.global/lamx0031/${folder}/g2/run_cnv_g2.pbs
 cp /scratch.global/lamx0031/${folder}/g2/run_cnv_g2.pbs ${PWD}/${folder}/run_cnv_g2.pbs
 elif [ "$Option" = "g3" ]; then
 echo " Option: $Option "
 sed -e s,e_grp,"$Option",g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > $folder/g3.ini 
 sh ${PWD}/hcl_launcher_trim_chr6_chr7_chr8.sh ${folder}/g3.ini
 qsub -n -q small /scratch.global/lamx0031/${folder}/g3/run_cnv_g3.pbs
 cp /scratch.global/lamx0031/${folder}/g3/run_cnv_g3.pbs ${PWD}/${folder}/run_cnv_g3.pbs
 elif [ "$Option" = "g4" ]; then
 echo " Option: $Option "
 sed -e s,e_grp,"$Option",g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > $folder/g4.ini
 sh ${PWD}/hcl_launcher_trim_chr9_chr10_chr11_chr12.sh ${folder}/g4.ini
 qsub -n -q small /scratch.global/lamx0031/${folder}/g4/run_cnv_g4.pbs
 cp /scratch.global/lamx0031/${folder}/g4/run_cnv_g4.pbs ${PWD}/${folder}/run_cnv_g4.pbs
 elif [ "$Option" = "g5" ]; then
 echo " Option: $Option "
 sed -e s,e_grp,"$Option",g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > $folder/g5.ini 
 sh ${PWD}/hcl_launcher_trim_chr13_chr14_chr15_chr16.sh ${folder}/g5.ini
 qsub -n -q small /scratch.global/lamx0031/${folder}/g5/run_cnv_g5.pbs
cp /scratch.global/lamx0031/${folder}/g5/run_cnv_g5.pbs ${PWD}/${folder}/run_cnv_g5.pbs 
 elif [ "$Option" = "g6" ]; then
 echo " Option: $Option "
 sed -e s,e_grp,"$Option",g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > $folder/g6.ini 
 sh ${PWD}/hcl_launcher_trim_chr17_chr18_chr19_chr20.sh ${folder}/g6.ini
 qsub -n -q small /scratch.global/lamx0031/${folder}/g6/run_cnv_g6.pbs
cp /scratch.global/lamx0031/${folder}/g6/run_cnv_g6.pbs ${PWD}/${folder}/run_cnv_g6.pbs

 elif [ "$Option" = "g7" ]; then
 echo " Option: $Option "
 sed -e s,e_grp,"$Option",g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > $folder/g7.ini 
 sh ${PWD}/hcl_launcher_trim_chr21_chr22_chrX_chrY.sh ${folder}/g7.ini
 qsub -n -q small /scratch.global/lamx0031/${folder}/g7/run_cnv_g7.pbs
 cp /scratch.global/lamx0031/${folder}/g7/run_cnv_g7.pbs ${PWD}/${folder}/run_cnv_g7.pbs

 elif [ "$Option" = "all" ]; then
 echo "All chromosome groups"

 sed -e s,e_grp,${folder}g1,g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > ${folder}/g1.ini
 sh ${PWD}/hcl_launcher_trim_chr1_chr2.sh ${folder}/g1.ini
 qsub -n -q small /scratch.global/lamx0031/${folder}/${folder}g1/run_cnv_${folder}g1.pbs
 cp /scratch.global/lamx0031/${folder}/${folder}g1/run_cnv_${folder}g1.pbs ${PWD}/$folder/run_cnv_${folder}g1.pbs  

 sed -e s,e_grp,${folder}g2,g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > ${folder}/g2.ini
 sh ${PWD}/hcl_launcher_trim_chr3_chr4_chr5.sh ${folder}/g2.ini
 qsub -n -q small /scratch.global/lamx0031/${folder}/${folder}g2/run_cnv_${folder}g2.pbs 
cp /scratch.global/lamx0031/${folder}/${folder}g2/run_cnv_${folder}g2.pbs ${PWD}/${folder}/run_cnv_${folder}g2.pbs

 sed -e s,e_grp,${folder}g3,g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > ${folder}/g3.ini
 sh ${PWD}/hcl_launcher_trim_chr6_chr7_chr8.sh ${folder}/g3.ini
 qsub -n -q small /scratch.global/lamx0031/${folder}/${folder}g3/run_cnv_${folder}g3.pbs
cp /scratch.global/lamx0031/${folder}/g3/run_cnv_g3.pbs ${PWD}/${folder}/run_cnv_g3.pbs

 sed -e s,e_grp,${folder}g4,g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > ${folder}/g4.ini
 sh ${PWD}/hcl_launcher_trim_chr9_chr10_chr11_chr12.sh ${folder}/g4.ini
 qsub -n -q small /scratch.global/lamx0031/${folder}/${folder}g4/run_cnv_${folder}g4.pbs
cp /scratch.global/lamx0031/${folder}/${folder}g4/run_cnv_${folder}g4.pbs ${PWD}/${folder}/run_cnv_${folder}g4.pbs

 sed -e s,e_grp,${folder}g5,g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > ${folder}/g5.ini
 sh ${PWD}/hcl_launcher_trim_chr13_chr14_chr15_chr16.sh ${folder}/g5.ini
 qsub -n -q small /scratch.global/lamx0031/${folder}/${folder}g5/run_cnv_${folder}g5.pbs
cp /scratch.global/lamx0031/${folder}/${folder}g5/run_cnv_${folder}g5.pbs ${PWD}/${folder}/run_cnv_${folder}g5.pbs

 sed -e s,e_grp,${folder}g6,g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > ${folder}/g6.ini
 sh ${PWD}/hcl_launcher_trim_chr17_chr18_chr19_chr20.sh ${folder}/g6.ini
 qsub -n -q small /scratch.global/lamx0031/${folder}/${folder}g6/run_cnv_${folder}g6.pbs
cp /scratch.global/lamx0031/${folder}/g6/run_cnv_g6.pbs ${PWD}/${folder}/run_cnv_${folder}g6.pbs

 sed -e s,e_grp,${folder}g7,g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > ${folder}/g7.ini
 sh ${PWD}/hcl_launcher_trim_chr21_chr22_chrX_chrY.sh ${folder}/g7.ini
 qsub -n -q small /scratch.global/lamx0031/${folder}/${folder}g7/run_cnv_${folder}g7.pbs
 cp /scratch.global/lamx0031/${folder}/${folder}g7/run_cnv_${folder}g7.pbs ${PWD}/${folder}/run_cnv_${folder}g7.pbs

 elif [ "$Option" = "master" ]; then
 echo "Generate master script"
 
 ## master.ini
 sed -e s,e_grp,${folder},g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > ${folder}/master.ini
 sh ${PWD}/hcl_launcher_master.sh ${folder}/master.ini
 
 sed -e s,e_grp,${folder}g7,g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > ${folder}/g7.ini
 sh ${PWD}/hcl_launcher_trim_chr21_chr22_chrX_chrY.sh ${folder}/g7.ini

 sed -e s,e_grp,${folder}g6,g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > ${folder}/g6.ini 
 sh ${PWD}/hcl_launcher_trim_chr17_chr18_chr19_chr20.sh ${folder}/g6.ini

 sed -e s,e_grp,${folder}g5,g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > ${folder}/g5.ini
 sh ${PWD}/hcl_launcher_trim_chr13_chr14_chr15_chr16.sh ${folder}/g5.ini

 sed -e s,e_grp,${folder}g4,g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > ${folder}/g4.ini
 sh ${PWD}/hcl_launcher_trim_chr9_chr10_chr11_chr12.sh ${folder}/g4.ini

 sed -e s,e_grp,${folder}g3,g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > ${folder}/g3.ini
 sh ${PWD}/hcl_launcher_trim_chr6_chr7_chr8.sh ${folder}/g3.ini

  sed -e s,e_grp,${folder}g2,g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > ${folder}/g2.ini
  sh ${PWD}/hcl_launcher_trim_chr3_chr4_chr5.sh ${folder}/g2.ini

 sed -e s,e_grp,${folder}g1,g -e s,ExomeRun,"$folder",g -e s,cr1,"$cr1",g -e s,cr2,"$cr2",g -e s,sr1,"$sr1",g -e s,sr2,"$sr2",g < ${PWD}/exome_g.ini > ${folder}/g1.ini
  sh ${PWD}/hcl_launcher_trim_chr1_chr2.sh ${folder}/g1.ini

 else
 echo "run_exome_groups.sh group folder control_path sample_path"
  
fi


