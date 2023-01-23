#!/usr/bin/env python

##Import libraries used in script
import os
import glob
import argparse
import subprocess
import re

##Set arguments used in script
parser = argparse.ArgumentParser(description='Run srst2. If loop is being used, ensure extension is *_1.fq, *_2.fq for for and forward and reverse reads respectively')
#parser.add_argument('-sr', '--srst2_path', dest='srst2', help='path to srst2 executable', required==True)
parser.add_argument('-l', '--loop', dest=('loop'), help='directory of paired fastq files to loop through') #"y" for yes and "n" for no', choices=('y','n')

args = parser.parse_args()

##variables and datasets that will be used in script
srst2 = 'srst2'
inp = '--input_pe'
output = '--output'
gene_db = '--gene_db'
threads = '--threads'

if args.loop:
	os.chdir(args.loop)
	for pe_1 in list(glob.glob('*_1.fq')):
		pe_2 = re.sub('_1.*fq', '_2.fq', pe_1)
		subprocess.Popen(f"bash -c 'source activate srst2; srst2 {inp} {pe_1} {pe_2} {output} {args.output} {gene_db} {args.database} {threads} {args.threads} '", shell=True)

else:
    parser.add_argument('-1', '--reads_1', dest='pe_1', help='name of forward paired read', required=True)
    parser.add_argument('-2', '--reads_2', dest='pe_2', help='name of reverse paired read', required=True)
    parser.add_argument('-d', '--working_directory', dest='directory', help='directory input reads are kept in', required=True)
    parser.add_argument('-o', '--output', dest='out_filename', help='name of output file, including extension', required=True)
    parser.add_argument('-od', '--output_directory', dest='out_directory', help='specify directory for output file if different')
    parser.add_argument('-dbd', '--database_directory', dest='database_directory', help='specify directory to database if different from working')
    parser.add_argument('-db', '--database_filename', dest='database', help='name of database, including extension', required=True)
    parser.add_argument('-th', '--threads', dest='threads', help='number of threads used in analysis', type=int)
    args = parser.parse_args()

    ##variables
    os.chdir(args.directory)

    if args.out_directory:
        os.chdir(args.out_directory)
        subprocess.Popen(
            f"bash -c 'source activate srst2; srst2 {inp} {args.pe_1} {args.pe_2} {outout} {args.output} {gene_db} {args.database} {threads} {args.threads} '", shell=True)

    else:
        subprocess.Popen(
            f"bash -c 'source activate srst2; srst2 {inp} {args.pe_1} {args.pe_2} {outout} {args.output} {gene_db} {args.database} {threads} {args.threads} '", shell=True)
