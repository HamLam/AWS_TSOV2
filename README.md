# AWS_TSOV2
AWS cnv tsov2

This repo. contains source code for the NovaSeq data processing pipeline. 

scripts folder: contains R and perl scripts used by the pipeline

template_trim folder: main sql, pl, py scripts are found here

hcl_launcher_* scripts: each script initializes a pipeline that processes a specific number of chromosomes. 

my.conf: setting for MySQL database used in the pipeline

Here are lists of required packages for the pipeline:

R packages:

MASS [http://cran.r-project.org/src/contrib/MASS_7.3-40.tar.gz]
calibrate [http://cran.r-project.org/src/contrib/calibrate_1.7.2.tar.gz]
getopt [http://cran.r-project.org/src/contrib/getopt_1.20.0.tar.gz]
