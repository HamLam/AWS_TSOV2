#!/bin/bash                             
ulimit -u

echo "Run Group 2 called"

working_dir=sample_path
script_path=scripts_location
table_path=tables_path
MYSQL_LOAD_WAIT=120
code_src=code_path

base_dir=$(dirname "${working_dir}")
echo $base_dir
BASE=$base_dir/mysql
echo $BASE
mysql_socket=$BASE/thesock
echo $mysql_socket

cd $working_dir

#module load parallel
#module load R/3.1.1
#module load bedtools/2.25.0/bin/bedtools
#module load python/2.7.5
#PYTHONPATH=/soft/python/2.7.1/lib/python2.7/site-packages
#export PYTHONPATH=/soft/python/2.7.5/lib/python2.7/site-packages:$PYTHONPATH
#LD_LIBRARY_PATH=/soft/python/2.7.1/lib
#export LD_LIBRARY_PATH=/soft/python/2.7.5/lib:$LD_LIBRARY_PATH

_now=$(date +"%Y-%m-%d_%H-%M")


ls -1 $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "$working_dir/completed.txt exists"
else
    echo "Started a new run on $_now" >> $working_dir/completed.txt
fi

echo ${_now} >> $working_dir/time_check
timecheck=`(date +"Date: %Y-%m-%d Time %H:%M:%S")`;
# echo ${timecheck} >> $working_dir/time_check


grep "control_pileup.sh" $working_dir/completed.txt > /dev/null 2>&1
 if [ "$?" = "0" ]; then
     echo "control_pileup.sh already run"
 else
     echo "Run control_pileup.sh"
     sh control_pileup.sh
     if [[ $? -ne 0 ]] ; then
         echo "Run control_pileup.sh failed" >&2
         exit 1
     else
         echo "g2 control_pileup.sh done"
         echo "control_pileup.sh" >> $working_dir/completed.txt
     fi
 fi
 
 echo -n "Finished control_pileup " >> $working_dir/time_check
 timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
 echo ${timecheck} >> $working_dir/time_check
 
 # Generate pileups for sample
 grep "sample_pileup.sh" $working_dir/completed.txt > /dev/null 2>&1
 if [ "$?" = "0" ]; then
     echo "sample_pileup.sh already run"
 else
     echo "Run sample_pileup.sh"
     sh sample_pileup.sh
     if [[ $? -ne 0 ]] ; then
 	echo "Run sample_pileup.sh failed" >&2
 	exit 1
     else
        echo "g2 sample_pileup.sh done"
 	echo "sample_pileup.sh" >> $working_dir/completed.txt
     fi
 fi
 
 echo -n "Finished sample_pileup " >> $working_dir/time_check
 timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
 echo ${timecheck} >> $working_dir/time_check
 
# 
# grep "base_tables_loaded" $working_dir/completed.txt > /dev/null 2>&1
# if [ "$?" = "0" ]; then
#     echo "base tables already loaded"
# else
   # CREATE DATABASE
#    mysql --socket=$BASE/thesock -u root -e "CREATE DATABASE cnv2;"
     
#     echo "Load tables"
    # find $table_path -name "*.sql" | xargs -I {} -n 1 -P 24 sh -c "mysql --socket=$BASE/thesock -u root cnv2 < \"{}\" "
  
  
 #  echo "mysql --socket=$BASE/thesock -u root cnv2 < $table_path/training_data_2016_07.sql" >> $working_dir/basetables_load_commands
 #  echo "mysql --socket=$BASE/thesock -u root cnv2 < $table_path/tso_data.sql" >> $working_dir/basetables_load_commands
 #  echo "mysql --socket=$BASE/thesock -u root cnv2 < $table_path/tso_exon_60bp_segments_main_data.sql" >> $working_dir/basetables_load_commands
 #  echo "mysql --socket=$BASE/thesock -u root cnv2 < $table_path/tso_exon_60bp_segments_pileup.sql" >> $working_dir/basetables_load_commands
 #  echo "mysql --socket=$BASE/thesock -u root cnv2 < $table_path/tso_exon_60bp_segments_window_data.sql">> $working_dir/basetables_load_commands
 #  echo "mysql --socket=$BASE/thesock -u root cnv2 < $table_path/tso_exon_contig_pileup.sql" >> $working_dir/basetables_load_commands
 #  echo "mysql --socket=$BASE/thesock -u root cnv2 < $table_path/tso_reference_exon.sql" >> $working_dir/basetables_load_commands
 #  echo "mysql --socket=$BASE/thesock -u root cnv2 < $table_path/tso_reference.sql" >> $working_dir/basetables_load_commands
 #  echo "mysql --socket=$BASE/thesock -u root cnv2 < $table_path/tso_windows_padded_pileup.sql" >> $working_dir/basetables_load_commands
 #  cat $working_dir/basetables_load_commands | parallel -j +0 

 # if [[ $? -ne 0 ]] ; then
#	echo "MySQL base table loading failed" >&2
#	exit 1
 #   else
	# echo "base_tables_loaded" >> $working_dir/completed.txt
    #fi
# fi

echo -n "Skipped loading base tables cnv2 " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

 ## Pre load control and sample tables then mysqlimport all txt files to the tables

 
grep "Pre_Load_Control.sql" $working_dir/completed.txt > /dev/null 2>&1
if  [ "$?" = "0" ]; then
    echo "Pre_Load_Control.sql already run"
else
 echo "Run Pre_Load_Control.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < Pre_Load_Control.sql
    if [[ $? -ne 0 ]] ; then
        echo "Run Pre_Load_Control.sql failed" >&2
        ## mysqladmin --socket=$BASE/thesock shutdown -u root
        exit 1
    else  
    echo "g2 Pre_Load_Control.sql done"
     echo "Pre_Load_Control.sql" >> $working_dir/completed.txt
 fi
fi

echo -n "Finished pre_load_control " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "Pre_Load_Sample.sql" $working_dir/completed.txt > /dev/null 2>&1
 if  [ "$?" = "0" ]; then
    echo "Pre_Load_Sample.sql already run"
else
 echo "Run Pre_Load_Sample.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < Pre_Load_Sample.sql
     if [[ $? -ne 0 ]] ; then
        echo "Run Pre_Load_Sample.sql failed" >&2
        ## mysqladmin --socket=$BASE/thesock shutdown -u root
        exit 1
else
     echo "g2 Pre_Load_Sample.sql done"
     echo "Pre_Load_Sample.sql" >> $working_dir/completed.txt
 fi
fi

echo -n "Finished pre_load_sample " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "mysqlimport" $working_dir/completed.txt > /dev/null 2>&1
 if [ "$?" = "0" ]; then
   echo "mysqlimport already run"
else
 echo "Run mysqlimport"

     mysqlimport --local --socket=$BASE/thesock -u root cnv2 --use-threads=5 --debug-check \
     cnv_control_name_bwa_pileup_no_dup.chr3_t \
     cnv_control_name_bwa_pileup_no_dup.chr4_t \
     cnv_control_name_bwa_pileup_no_dup.chr5_t \
     cnv_control_name_bwa_pileup_no_dup.chr1_t \
     cnv_control_name_bwa_pileup_no_dup.chr2_t \
     cnv_control_name_bwa_pileup_no_dup.chr6_t \
     cnv_control_name_bwa_pileup_no_dup.chr9_t \
     cnv_control_name_bwa_pileup_no_dup.chr10_t \
     cnv_control_name_bwa_pileup_no_dup.chr13_t \
     cnv_control_name_bwa_pileup_no_dup.chr15_t \
     cnv_control_name_bwa_pileup_no_dup.chr17_t \
     cnv_control_name_bwa_pileup.chr3_t \
     cnv_control_name_bwa_pileup.chr4_t \
     cnv_control_name_bwa_pileup.chr5_t \
     cnv_control_name_bwa_pileup.chr1_t \
     cnv_control_name_bwa_pileup.chr2_t \
     cnv_control_name_bwa_pileup.chr6_t \
     cnv_control_name_bwa_pileup.chr9_t \
     cnv_control_name_bwa_pileup.chr10_t \
     cnv_control_name_bwa_pileup.chr13_t \
     cnv_control_name_bwa_pileup.chr15_t \
     cnv_control_name_bwa_pileup.chr17_t \
     cnv_control_name_bowtie_pileup.chr3_t \
     cnv_control_name_bowtie_pileup.chr4_t \
     cnv_control_name_bowtie_pileup.chr5_t \
     cnv_control_name_bowtie_pileup.chr1_t \
     cnv_control_name_bowtie_pileup.chr2_t \
     cnv_control_name_bowtie_pileup.chr6_t \
     cnv_control_name_bowtie_pileup.chr9_t \
     cnv_control_name_bowtie_pileup.chr10_t \
     cnv_control_name_bowtie_pileup.chr13_t \
     cnv_control_name_bowtie_pileup.chr15_t \
     cnv_control_name_bowtie_pileup.chr17_t \
     cnv_sample_name_bwa_pileup_no_dup.chr3_t \
     cnv_sample_name_bwa_pileup_no_dup.chr4_t \
     cnv_sample_name_bwa_pileup_no_dup.chr5_t \
     cnv_sample_name_bwa_pileup_no_dup.chr1_t \
     cnv_sample_name_bwa_pileup_no_dup.chr2_t \
     cnv_sample_name_bwa_pileup_no_dup.chr6_t \
     cnv_sample_name_bwa_pileup_no_dup.chr9_t \
     cnv_sample_name_bwa_pileup_no_dup.chr10_t \
     cnv_sample_name_bwa_pileup_no_dup.chr13_t \
     cnv_sample_name_bwa_pileup_no_dup.chr15_t \
     cnv_sample_name_bwa_pileup_no_dup.chr17_t \
     cnv_sample_name_bwa_pileup.chr3_t \
     cnv_sample_name_bwa_pileup.chr4_t \
     cnv_sample_name_bwa_pileup.chr5_t \
     cnv_sample_name_bwa_pileup.chr1_t \
     cnv_sample_name_bwa_pileup.chr2_t \
     cnv_sample_name_bwa_pileup.chr6_t \
     cnv_sample_name_bwa_pileup.chr9_t \
     cnv_sample_name_bwa_pileup.chr10_t \
     cnv_sample_name_bwa_pileup.chr13_t \
     cnv_sample_name_bwa_pileup.chr15_t \
     cnv_sample_name_bwa_pileup.chr17_t \
     cnv_sample_name_bowtie_pileup.chr3_t \
     cnv_sample_name_bowtie_pileup.chr4_t \
     cnv_sample_name_bowtie_pileup.chr5_t \
     cnv_sample_name_bowtie_pileup.chr1_t \
     cnv_sample_name_bowtie_pileup.chr2_t \
     cnv_sample_name_bowtie_pileup.chr6_t \
     cnv_sample_name_bowtie_pileup.chr9_t \
     cnv_sample_name_bowtie_pileup.chr10_t \
     cnv_sample_name_bowtie_pileup.chr13_t \
     cnv_sample_name_bowtie_pileup.chr15_t \
     cnv_sample_name_bowtie_pileup.chr17_t 

  if [[ $? -ne 0 ]]; then
   echo "Run mysqlimport failed" >&2
   echo "g2 Run mysqlimport failed"
       ## mysqladmin --socket=$BASE/thesock shutdown -u root
        exit 1
     else
      echo "g2 mysqlimport done"
      echo "mysqlimport " >> $working_dir/completed.txt
    fi
 fi
  
echo -n "Finished mysqlimport tables " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check
  
grep "load_control.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "load_control.sql already run"
else
    echo "Run load_control.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < load_control.sql
    if [[ $? -ne 0 ]] ; then
	echo "Run load_control.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	# exit 1
    else
        echo "g2 load_control.sql done"
	echo "load_control.sql" >> $working_dir/completed.txt
    fi
fi

echo -n "Finished load_control " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check


grep "load_sample.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "load_sample.sql already run"
else
    echo "Run load_sample.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < load_sample.sql
    if [[ $? -ne 0 ]] ; then
	echo "Run load_sample.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	# exit 1
    else
        echo "g2 load_sample.sql done"
	echo "load_sample.sql" >> $working_dir/completed.txt
    fi
fi

echo -n "Finished load_sample " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "create_reference.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "create_reference.sql already run"
else
    echo "Run create_reference.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < create_reference.sql
    if [[ $? -ne 0 ]] ; then
	echo "Run create_reference.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
       echo "g2 create_reference.sql done"
	echo "create_reference.sql" >> $working_dir/completed.txt
    fi
fi

echo -n "Finished create_reference.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "find_median.R" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "find_median.R already run"
else
    echo "Run  find_median.R"
    R CMD BATCH find_median.R
    if [[ $? -ne 0 ]] ; then
	echo "Run find_median.R failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
        echo "g2 find_median.R done"
	echo "find_median.R" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished find_median.R " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "create_tables_part1.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "create_tables_part1.sql already run"
else
    echo "Run  create_tables_part1.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < create_tables_part1.sql
    if [[ $? -ne 0 ]] ; then
	echo "Run create_tables_part1.sql failed" >&2
	# ## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
        echo "g2 create_tables_part1.sql done"
	echo "create_tables_part1.sql" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished create_table_part1.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "normalize_coverage.R" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "normalize_coverage.R already run"
else
    echo "Run  normalize_coverage.R"
    R CMD BATCH normalize_coverage.R
    if [[ $? -ne 0 ]] ; then
	echo "Run normalize_coverage.R failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
        echo "g2 normalize_coverage.R done"
	echo "normalize_coverage.R" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished normalize_coverage.R " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "smooth_coverage.R" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "smooth_coverage.R already run"
else
    echo "Run  smooth_coverage.R"
    R CMD BATCH smooth_coverage.R
    if [[ $? -ne 0 ]] ; then
	echo "Run smooth_coverage.R failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
        echo "g2 smooth_coverage.R done"
	echo "smooth_coverage.R" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished smooth_coverage.R " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "get_three_ref.R" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "get_three_ref.R already run"
else
    echo "Run  get_three_ref.R"
    R CMD BATCH get_three_ref.R
    if [[ $? -ne 0 ]] ; then
	echo "Run get_three_ref.R failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
        echo "g2 get_three_ref.R done"
	echo "get_three_ref.R" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished get_three_ref.R " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "create_tables_ref_v1.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "create_tables_ref_v1.sql already run"
else
    echo "Run  create_tables_ref_v1.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < create_tables_ref_v1.sql
    if [[ $? -ne 0 ]] ; then
	echo "Run create_tables_ref_v1.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
        echo "g2 create_tables_ref_v1.sql done"
	echo "create_tables_ref_v1.sql" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished create_tables_ref_v1.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "create_tables_ref.R" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "create_tables_ref.R already run"
else
    echo "Run  create_tables_ref.R"
    R CMD BATCH create_tables_ref.R
    if [[ $? -ne 0 ]] ; then
	echo "Run create_tables_ref.R failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
     echo "g2 create_tables_ref.R done"
	echo "create_tables_ref.R" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished create_tables_ref.R " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "create_tables_ref_v2.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "create_tables_ref_v2.sql already run"
else
    echo "Run  create_tables_ref_v2.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < create_tables_ref_v2.sql
    if [[ $? -ne 0 ]] ; then
	echo "Run create_tables_ref_v2.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
       echo "g2 create_tables_ref_v2.sql done"
	echo "create_tables_ref_v2.sql" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished create_tables_ref_v2.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "create_coverage.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "create_coverage.sql already run"
else
    echo "Run  create_coverage.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < create_coverage.sql
    if [[ $? -ne 0 ]] ; then
	echo "Run create_coverage.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
        echo "g2 create_coverage.sql done"
	echo "create_coverage.sql" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished create_coverage.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "create_sample_coverage.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "create_sample_coverage.sql already run"
else
    echo "Run  create_sample_coverage.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < create_sample_coverage.sql
    if [[ $? -ne 0 ]] ; then
	echo "Run create_sample_coverage.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
        echo "g2 create_sample_coverage.sql done"
	echo "create_sample_coverage.sql" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished create_sample_coverage.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "create_control_coverage.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "create_control_coverage.sql already run"
else
    echo "Run  create_control_coverage.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < create_control_coverage.sql
    if [[ $? -ne 0 ]] ; then
	echo "Run create_control_coverage.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
       echo "g2 create_control_coverage.sql done"
	echo "create_control_coverage.sql" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished create_control_coverage.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "cnv_tables.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "cnv_tables.sql already run"
else
    echo "Run  cnv_tables.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < cnv_tables.sql
    if [[ $? -ne 0 ]] ; then
	echo "Run cnv_tables.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
        echo "g2 cnv_tables.sql done"
	echo "cnv_tables.sql" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished cnv_tables.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "cnv_tables_amplifications.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "cnv_tables_amplifications.sql already run"
else
    echo "Run  cnv_tables_amplifications.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < cnv_tables_amplifications.sql
    if [[ $? -ne 0 ]] ; then
	echo "Run cnv_tables_amplifications.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
       echo "g2 cnv_tables_amplifications.sql done"
	echo "cnv_tables_amplifications.sql" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished cnv_tables_amplications.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "ordered_genes.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "ordered_genes.sql already run"
else
    echo "Run ordered_genes.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < ordered_genes.sql
    if [[ $? -ne 0 ]] ; then
	echo "Run ordered_genes.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
        echo "g2 ordered_genes.sql done"
	echo "ordered_genes.sql" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished ordered_genes.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "create_data.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "create_data.sql already run"
else
    echo "Run create_data.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < create_data.sql
    if [[ $? -ne 0 ]] ; then
	echo "Run create_data.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
        echo "g2 create_data.sql done"
	echo "create_data.sql" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished create_data.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "get_machine_learning_data.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "get_machine_learning_data.sql already run"
else
    echo "Run get_machine_learning_data.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < get_machine_learning_data.sql > sample_name_raw_data_$_now.txt
    if [[ $? -ne 0 ]] ; then
	echo "Run get_machine_learning_data.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
       echo "g2 get_machine_learning_data.sql done"
	echo "get_machine_learning_data.sql" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished get_machine_learning_data.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "aggregate_window.R" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "aggregate_window.R already run"
else
    echo "Run aggregate_window.R"
    R CMD BATCH aggregate_window.R
    if [[ $? -ne 0 ]] ; then
	echo "Run aggregate_window.R failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
        echo "g2 aggregate_window.R done"
	echo "aggregate_window.R" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished aggregate_window.R " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "combine_data.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "combine_data.sql already run"
else
    echo "Run combine_data.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < combine_data.sql
    if [[ $? -ne 0 ]] ; then
	echo "Run combine_data.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
       echo "g2 combine_data.sql done"
	echo "combine_data.sql" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished combine_data.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "cnv_randomForest_predict.R" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "cnv_randomForest_predict.R already run"
else
    echo "Run cnv_randomForest_predict.R"
    R CMD BATCH cnv_randomForest_predict.R
    if [[ $? -ne 0 ]] ; then
	echo "Run cnv_randomForest_predict.R failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else
       echo "g2 cnv_randomForest_predict.R done"
	echo "cnv_randomForest_predict.R" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished cnv_randomForest_predict.R " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "get_predicted.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "get_predicted.sql already run"
else
    echo "Run get_predicted.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < get_predicted.sql > sample_name_predicted_$_now.txt
    if [[ $? -ne 0 ]] ; then
	echo "Run get_predicted.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	exit 1
    else 
     echo "g2 get_predicted.sql done"
	echo "get_predicted.sql" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished get_predicted.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

# Raw data
if [ -s sample_name_raw_data_$_now.txt ]
then
    mkdir -p archive_path/raw_data
    chmod 775 archive_path/raw_data
    mv  sample_name_raw_data_$_now.txt archive_path/raw_data
    chmod 664 archive_path/raw_data/sample_name_raw_data_$_now.txt
else
    echo "sample_name_raw_data_$_now.txt is empty."
    # do something as file is empty 
fi

if [ -s sample_name_raw_data_amp_$_now.txt ]
then
    mv  sample_name_raw_data_amp_$_now.txt archive_path/raw_data
    chmod 664 archive_path/raw_data/sample_name_raw_data_amp_$_now.txt
else
    echo "sample_name_raw_data_amp_$_now.txt is empty."
    # do something as file is empty 
fi


# Predicted
if [ -s sample_name_predicted_$_now.txt ]
then
    mkdir -p archive_path/predicted_data
    chmod 775 archive_path/predicted_data
    mv  sample_name_predicted_$_now.txt  archive_path/predicted_data
    chmod 664 archive_path/predicted_data/sample_name_predicted_$_now.txt
else
    echo "sample_name_predicted_$_now.txt is empty"
fi

if [ -s sample_name_predicted_amp_$_now.txt ]
then
    mv  sample_name_predicted_amp_$_now.txt  archive_path/predicted_data
    chmod 664 archive_path/predicted_data/sample_name_predicted_amp_$_now.txt
else
    echo "sample_name_predicted_amp_$_now.txt is empty"
fi

grep "plot_script.pl" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "plot_script.pl cnv2 already run"
else
    echo "plot_script.pl"
    perl $script_path/plot_script.pl -t cnv_sample_name_tso_over_control_name_n_bowtie_bwa_ratio_gene_out -s sample_name -c cnv_sample_name_ordered_genes -k cnv_sample_name_ordered_genes -h localhost -u root -d cnv2 -o plot_genes_ordered_cnv2.py -ms $mysql_socket -a 1
    if [[ $? -ne 0 ]] ; then
	echo "Run plot_script.pl cnv2 failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	#exit 1
    else
	echo "plot_script.pl cnv2" >> $working_dir/completed.txt
    fi
fi
#
grep "plot_genes_ordered_cnv2.py" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "plot_genes_ordered_cnv2.py already run"
else
    echo "plot_genes_ordered_cnv2.py"
    #R CMD BATCH plot_genes_ordered.R
    python plot_genes_ordered_cnv2.py
    if [[ $? -ne 0 ]] ; then
	echo "Run plot_genes_ordered_cnv2.py failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	#exit 1
    else
	echo "plot_genes_ordered_cnv2.py" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished plot_genes_ordered.py " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check


grep "get_ordered_genes.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "get_ordered_genes.sql already run"
else
    echo "get_ordered_genes.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < get_ordered_genes.sql  > sample_name_cnv_calls_on_ordered_genes_$_now.txt
    if [[ $? -ne 0 ]] ; then
	echo "Run get_ordered_genes.sql failed" >&2
	## mysqladmin --socket=$BASE/thesock shutdown -u root
	#exit 1
    else
	echo "get_ordered_genes.sql" >> $working_dir/completed.txt
	sed -e s,NULL,,g < sample_name_cnv_calls_on_ordered_genes_$_now.txt > sample_name_cnv_calls_on_ordered_genes_$_now.txt.bak
	mv sample_name_cnv_calls_on_ordered_genes_$_now.txt.bak sample_name_cnv_calls_on_ordered_genes_$_now.txt
    fi
fi
echo -n "Finished get_ordered_genes.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

if [ -s sample_name_cnv_calls_on_ordered_genes_$_now.txt ]
then
    cp  sample_name_cnv_calls_on_ordered_genes_$_now.txt sample_result
else
    echo "sample_name_cnv_calls_on_ordered_genes_$_now.txt is empty."
# do nothing as file is empty
fi

grep "move_script.pl" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "move_script.pl already run"
else
    echo "move_script.pl"
    perl $script_path/move_script.pl -c cnv_sample_name_ordered_genes -p sample_result -h localhost -u root -d cnv2 -o move_plots_cnv2.sh -ms $mysql_socket
    if [[ $? -ne 0 ]] ; then
        echo "Run move_script.pl failed" >&2
        ## mysqladmin --socket=$BASE/thesock shutdown -u root
        #exit 1
    else
        echo "move_script.pl cnv2 ran successfully"
    fi
fi
#
echo -n "Finished move_script.pl " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check
#
## Run script to move plots for ordered genes
#
grep "move_plots_cnv2.sh" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "move_plots_cnv2.sh already run"
else
    echo "Run move_plots_cnv2.sh"
    sh move_plots_cnv2.sh
    if [[ $? -ne 0 ]] ; then
        echo "Run move_plots_cnv2.sh failed" >&2
        #exit 1
    else
    	echo "move_script.pl" >> $working_dir/completed.txt
        echo "move_plots_cnv2.sh" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished move_plots.pl " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

grep "cnv2vcf.py" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "cnv2vcf.py already run"
else
    echo "cnv2vcf.py"
    python $script_path/cnv2vcf.py sample_name_cnv_calls_on_ordered_genes_$_now.txt 4 17 16 seq_db > sample_name_cnv.vcf
    if [[ $? -ne 0 ]] ; then
	echo "Run cnv2vcf.py failed" >&2
	exit 1
    else
       echo "g2 cnv2vcf.py done"
	echo "cnv2vcf.py" >> $working_dir/completed.txt
    fi 
fi
echo -n "Finished cnv2vcf.py " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

if [ -s sample_name_cnv.vcf ]
then
    cp  sample_name_cnv.vcf sample_result
else
    echo "sample_name_cnv.vcf is empty."
fi

grep "get_qc_data.sql" $working_dir/completed.txt > /dev/null 2>&1
if [ "$?" = "0" ]; then
    echo "get_qc_data.sql already run"
else
    echo "get_qc_data.sql"
    mysql --socket=$BASE/thesock -u root cnv2 < get_qc_data.sql > sample_name_qc_data_$_now.txt
    if [[ $? -ne 0 ]] ; then
        echo "Run get_qc_data.sql failed" >&2
        exit 1
    else
      echo "g2 get_qc_data.sql done"
        echo "get_qc_data.sql" >> $working_dir/completed.txt
    fi
fi
echo -n "Finished get_qc_data.sql " >> $working_dir/time_check
timecheck=`(date +"%Y-%m-%d [ %H:%M:%S ]")`;
echo ${timecheck} >> $working_dir/time_check

if [ -s sample_name_qc_data_$_now.txt ]
then
    cp  sample_name_qc_data_$_now.txt  archive_path/QC
    chmod 664 archive_path/QC/sample_name_qc_data_$_now.txt
else
    echo "sample_name_qc_data_$_now.txt is empty"
fi

# don't shutdown mysql here, shutdown via the master 
# SHUT DOWN MySQL 
# echo "Shutdown MySQL"
# ## mysqladmin --socket=$BASE/thesock shutdown -u root
