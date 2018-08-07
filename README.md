# AWS_TSOV2
AWS cnv tsov2

This repo. contains source code for the NovaSeq data processing pipeline. 

scripts folder: contains R and perl scripts used by the pipeline

template_trim folder: main sql, pl, py scripts are found here

hcl_launcher_* scripts: each script initializes a pipeline that processes a specific number of chromosomes. 

my.conf: setting for MySQL database used in the pipeline

### Dependencies:

gnu parallel

R

bwa

bowtie2

picard-tools

samtools

### Here are lists of required packages for the pipeline:

R packages:

MASS [http://cran.r-project.org/src/contrib/MASS_7.3-40.tar.gz]

calibrate [http://cran.r-project.org/src/contrib/calibrate_1.7.2.tar.gz]

getopt [http://cran.r-project.org/src/contrib/getopt_1.20.0.tar.gz]

optparse [http://cran.r-project.org/src/contrib/optparse_1.3.0.tar.gz]

plotrix [http://cran.r-project.org/src/contrib/plotrix_3.5-11.tar.gz]

DBI [http://cran.r-project.org/src/contrib/DBI_0.3.1.tar.gz]

RMySQL [http://cran.r-project.org/src/contrib/RMySQL_0.10.3.tar.gz]

zoo [http://cran.r-project.org/src/contrib/zoo_1.7-12.tar.gz]

diptest [http://cran.r-project.org/src/contrib/diptest_0.75-6.tar.gz]

randomForest [http://cran.r-project.org/src/contrib/randomForest_4.6-10.tar.gz]

Perl packages:

DBD [http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.031.tar.gz]

Exporter-Tiny [http://search.cpan.org/CPAN/authors/id/T/TO/TOBYINK/Exporter-Tiny-0.042.tar.gz]

DBI [http://search.cpan.org/CPAN/authors/id/T/TI/TIMB/DBI-1.633.tar.gz]

List::MoreUtils [http://search.cpan.org/CPAN/authors/id/R/RE/REHSACK/List-MoreUtils-0.413.tar.gz]

MySQL:

MariaDB: https://mariadb.org/

### Chromosome grouping scheme and reference genes used for each group

cnv group/chromosomes	3 reference genes
cnv1: 1,2	SYNE1,BRCA2,TP53
cnv2: 3,4,5	SYNE1,BRCA2,TP53
cnv3: 6,7,8	BRCA2,TP53,TOR1A
cnv4: 9,10,11,12	SYNE1,BRCA2,TP53
cnv5: 13,14,15,16	SYNE1,TP53,TOR1A
cnv6: 17,18.19,20	SYNE1,BRCA2,TOR1A
cnv7: 21,22,X,Y SYNE1,BRCA2,TP53
