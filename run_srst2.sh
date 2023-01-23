#!/bin/bash

#### Script to run SRST2 on filtered reads ####

##Set variables used in script
set_variables(){

	echo "Setting variables"
	source activate srst2
	export read_dir=/home/jahcubtrew/outbreak_projects/ST_DT99_MR_231122/working_reads/trimmed
	export output=/home/jahcubtrew/outbreak_projects/ST_DT99_MR_231122/working_srst2
	export mlst_db=/home/jahcubtrew/data_bases/mlst_db
	export genes_db=/home/jahcubtrew/packages/srst2/data
	export vf_db=/home/jahcubtrew/data_bases/vf_db
	export phage_db=/home/jahcubtrew/data_bases/phage_db
	export spi_db=/home/jahcubtrew/data_bases/spi_db
	export insertion_db=/home/jahcubtrew/data_bases/insertion_db
	echo "Variables set"
}

##Downloald MLST allele  database for specific genus
grab_mlstdb(){
getmlst.py --species 'Salmonella'
}

##Downlaod full virulence database unzip and extract salmonelle virulence associated genes
grab_vf_db(){
wget 'http://www.mgc.ac.cn/VFs/Down/VFDB_setB_nt.fas.gz'
gunzip VFDB_setB_nt.fas.gz
python VFDBgenus.py --infile ~/data_bases/vf_db/VFDB_setB_nt.fas --genus Salmonella
python /home/jahcubtrew/packages/srst2/database_clustering/VFDB_cdhit_to_csv.py --cluster_file sal_vf_cdhit90.clstr --infile Salmonella.fsa --outfile sal_vf_cdhit90.csv
python /home/jahcubtrew/packages/srst2/database_clustering/csv_to_gene_db.py -t sal_vf_cdhit90.csv -o sal_vf_clustered.fasta -s 5
}

##Prepare virulence database for use in srst2 (cluster sequesnces that are 90% similar)
post_vf_db(){
cd-hit -i ~/data_bases/vf_db/Salmonella.fsa -o ~/data_bases/vf_db/sal_vf_cdhit90 -c 0.9 > ~/data_bases/vf_db/sal_vf_cdhit90.stdout
}

##Run ST analysis on reads
run_srst2(){

	echo "Running SRST2 check"

	for a in ${read_dir}/*1.fastq.gz
	do
		base=${a%_1*}
		file_name=$(basename ${a%_1*})
		srst2 \
		--output ${output}/${file_name}_phage_default \
		--input_pe ${a} ${base}_2.fastq.gz \
		--gene_db ${phage_db}/PhageJul21_clustered.fasta \
		--threads 8
	done

	echo "SRST2 check done"
}

set_variables
run_srst2
