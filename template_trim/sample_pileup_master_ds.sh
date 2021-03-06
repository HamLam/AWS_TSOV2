#!/bin/bash

# module load parallel

orig_S1_R1=s_s1r1Fastq
orig_S1_R2=s_s1r2Fastq

s_S1_R1=s_s1r1Fastq
s_S1_R2=s_s1r2Fastq

# Check to see if fastq files are compressed. If they are
# uncompress them into the working directory
#
# NOTE: The copying in the ELSE clause is not necessary. The files should be readable from data release. However, 
# there are instances where files permission are not set properly and user is unable to read files from data release. 
# This copying is a precautionary measure to make sure the program does not break if that happens. 


chrfiles_path=exo_chrfiles
script_path=scripts_location
WORKING_PATH=working_dir
BWA_DB=bwa_db_value
BOWTIE2_DB=bowtie2_db_value
S_DB=seq_db
ref=/panfs/roc/rissdb/genomes/Homo_sapiens/hg19_canonical/seq/hg19_canonical.fa

BASECOUNT=50000000
CUTOFF_VALUE=60000000
num=0

readcount=$(zcat ${orig_S1_R1} | awk 'NR%4==1' | wc -l)
echo "sample size read count: $readcount"
g=$(echo "$readcount > $CUTOFF_VALUE" | bc -l)
if [ ${g} -gt ${num} ]; then
chmod ug+rwx $script_path/seqtk
## down sample here before mapping with 2 pass mode
$script_path/seqtk sample -s100 -2 ${orig_S1_R1} 50000000 > ${WORKING_PATH}/sample_R1_sub1.fastq
$script_path/seqtk sample -s100 -2 ${orig_S1_R2} 50000000 > ${WORKING_PATH}/sample_R2_sub2.fastq
s_S1_R1=${WORKING_PATH}/sample_R1_sub1.fastq
s_S1_R2=${WORKING_PATH}/sample_R2_sub2.fastq
else
 echo "No down sampling needed for sample fastqs"
fi
 
bwacommand="bwa mem -M -t 24 $BWA_DB $s_S1_R1 $s_S1_R2 | samtools view -q 10 -bS - > s_bwa_s1.bam"
btcommand="bowtie2 -p 24 -k 5 -x $BOWTIE2_DB -1 $s_S1_R1 -2 $s_S1_R2 | samtools view -q 10 -bS - > s_bowtie2_s1.bam"

echo ${bwacommand} > $WORKING_PATH/saligncommands
echo ${btcommand} >> $WORKING_PATH/saligncommands
cat ${WORKING_PATH}/saligncommands | parallel -j +0 $1

#mkdir /mnt/tmp/tso_launcher_v3.0.0/javatmp
#  echo "mkdir javatmp done"
  


#set _JAVA_OPTIONS=-Djava.io.tmpdir=/mnt/tmp/tso_launcher_v3.0.0/javatmp

export _JAVA_OPTIONS='-Djava.io.tmpdir=/mnt/tmp/tso_launcher_v3.0.0/javatmp'

java -Xmx4g -Djava.io.tmpdir=/mnt/tmp/tso_launcher_v3.0.0/javatmp -jar  $CLASSPATH/picard.jar FixMateInformation SORT_ORDER=coordinate INPUT=s_bwa_s1.bam OUTPUT=s_bwa.fixed.bam

picard1="java -Xmx4g -Djava.io.tmpdir=/mnt/tmp/tso_launcher_v3.0.0/javatmp -jar  $CLASSPATH/picard.jar MarkDuplicates REMOVE_DUPLICATES=true ASSUME_SORTED=true METRICS_FILE=s_bwa_duplicate_stats.txt INPUT=s_bwa.fixed.bam OUTPUT=s_bwa.fixed_nodup.bam"
picard2="java -Xmx4g -Djava.io.tmpdir=/mnt/tmp/tso_launcher_v3.0.0/javatmp -jar  $CLASSPATH/picard.jar FixMateInformation SORT_ORDER=coordinate INPUT=s_bowtie2_s1.bam OUTPUT=s_bowtie2.fixed.bam"

echo ${picard1} > $WORKING_PATH/spicardcommands
echo ${picard2} >> $WORKING_PATH/spicardcommands
cat ${WORKING_PATH}/spicardcommands | parallel -j 3 


 indexcomm1="samtools index s_bwa.fixed.bam"
 indexcomm2="samtools index s_bwa.fixed_nodup.bam"
 indexcomm3="samtools index s_bowtie2.fixed.bam"
# 
 echo ${indexcomm1} > $WORKING_PATH/sindexcommands
 echo ${indexcomm2} >> $WORKING_PATH/sindexcommands
 echo ${indexcomm3} >> $WORKING_PATH/sindexcommands
 cat ${WORKING_PATH}/sindexcommands | parallel -j 3 
# 
# 
# 
# samtools view -H s_bwa.fixed.bam | grep "\@SQ" | sed 's/^.*SN://g' | cut -f1 |  xargs -I {} -n 1 -P 24 sh -c "samtools mpileup -BQ0 -d10000000 -f $S_DB  -r \"{}\" s_bwa.fixed.bam | cut -f 1,2,4 > cnv_sample_name_bwa_pileup.\"{}\""
# chr1_files=($WORKING_PATH/cnv_sample_name_bwa_pileup.chr*)
# chr2_files=($chrfiles_path/file.*)
# for ((i=0;i<${#chr1_files[@]};i++)); do
# echo "perl $script_path/trimfile_t.pl "${chr1_files[i]}" "${chr2_files[i]}" " >> schopcommands
# done
# cat ${WORKING_PATH}/schopcommands | parallel -j 8
# 
# cat *.s_bwa_count | awk '{FS=" ";print $1,"\t",$2,"\t",$4}' - >> cnv_sample_name_bwa_pileup.txt
# 
# samtools view -H s_bwa.fixed_nodup.bam | grep "\@SQ" | sed 's/^.*SN://g' | cut -f1 |  xargs -I {} -n 1 -P 24 sh -c "samtools mpileup -BQ0 -d10000000 -f $S_DB  -r \"{}\" s_bwa.fixed_nodup.bam | cut -f 1,2,4 > cnv_sample_name_bwa_pileup_no_dup.\"{}\""
# chr1a_files=($WORKING_PATH/cnv_sample_name_bwa_pileup_no_dup.chr*)
# chr2a_files=($chrfiles_path/file.*)
# for ((i=0;i<${#chr1a_files[@]};i++)); do
# echo "perl $script_path/trimfile_t.pl "${chr1a_files[i]}" "${chr2a_files[i]}" " >> schopcommands2
# done
# cat ${WORKING_PATH}/schopcommands2 | parallel -j 8
# 
# cat *.s_bwa_nodup_count | awk '{FS=" ";print $1,"\t",$2,"\t",$4}' - >> cnv_sample_name_bwa_pileup_no_dup.txt
# 
# 
# samtools view -H s_bowtie2.fixed.bam | grep "\@SQ" | sed 's/^.*SN://g' | cut -f1 |  xargs -I {} -n 1 -P 24 sh -c "samtools mpileup -BQ0 -d10000000 -f $S_DB  -r \"{}\" s_bowtie2.fixed.bam | cut -f 1,2,4 > cnv_sample_name_bowtie_pileup.\"{}\""
# chr1b_files=($WORKING_PATH/cnv_sample_name_bowtie_pileup.chr*)
# chr2b_files=($chrfiles_path/file.*)
# for ((i=0;i<${#chr1b_files[@]};i++)); do
# echo "perl $script_path/trimfile_t.pl "${chr1b_files[i]}" "${chr2b_files[i]}" " >> schopcommands3
# done
# cat ${WORKING_PATH}/schopcommands3 | parallel -j 8
# 
# 
# cat *.s_bowtie2_count | awk '{FS=" ";print $1,"\t",$2,"\t",$4}' - >> cnv_sample_name_bowtie2_pileup.txt
