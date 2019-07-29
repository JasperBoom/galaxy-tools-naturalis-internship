# galaxy-tools-naturalis-internship
These tools were made for the Naturalis Galaxy instance with a main focus on metabarcoding analysis.  
Either an existing software package is used or new scripts were written for desired functionalities.  
Some inputs for these tools are Naturalis Galaxy specific and depend on various other software packages used by Naturalis.  
The newest version of the Naturalis Galaxy instance can be found [here](https://github.com/naturalis/Galaxy-Installation).

## Table of contents:
* [Prerequisites](https://github.com/JasperBoom/galaxy-tools-naturalis-internship#prerequisites)
* [Galaxy configuration](https://github.com/JasperBoom/galaxy-tools-naturalis-internship#galaxy-configuration)
* [Tool descriptions](https://github.com/JasperBoom/galaxy-tools-naturalis-internship#tool-descriptions)
* [Source(s)](https://github.com/JasperBoom/galaxy-tools-naturalis-internship#sources)

1. [UMI isolation](https://github.com/JasperBoom/galaxy-tools-naturalis-internship#umi-isolation)
2. [Taxonomic accumulator](https://github.com/JasperBoom/galaxy-tools-naturalis-internship#taxonomic-accumulator)
3. [Accepted taxonomic name](https://github.com/JasperBoom/galaxy-tools-naturalis-internship#accepted-taxonomic-name)
4. [Metadata](https://github.com/JasperBoom/galaxy-tools-naturalis-internship#metadata)
5. [Phyloseq visual reporter](https://github.com/JasperBoom/galaxy-tools-naturalis-internship#phyloseq-visual-reporter)
6. [FastQC analysis](https://github.com/JasperBoom/galaxy-tools-naturalis-internship#fastqc-analysis)
7. [PRINSEQ analysis](https://github.com/JasperBoom/galaxy-tools-naturalis-internship#prinseq-analysis)
8. [PRINSEQ trimmer](https://github.com/JasperBoom/galaxy-tools-naturalis-internship#prinseq-trimmer)
9. [CutAdapt trimmer](https://github.com/JasperBoom/galaxy-tools-naturalis-internship#cutadapt-trimmer)
10. [Read counter](https://github.com/JasperBoom/galaxy-tools-naturalis-internship#read-counter)
11. [FastQ to fastA](https://github.com/JasperBoom/galaxy-tools-naturalis-internship#fastq-to-fasta)

## Getting started

### Prerequisites
Download and install the following software:
```
* Python3 (apt-get install python3)
* Python3 pip (apt-get install python3-pip)
* Python3 pandas (pip3 install pandas)
* Python3 xlrd (pip3 install xlrd)
* Python3 xlsxwriter (pip3 install xlsxwriter)
* CutAdapt (pip3 install cutadapt)
* PRINSEQ (https://sourceforge.net/projects/prinseq/files/)
* FastQC (https://www.bioinformatics.babraham.ac.uk/projects/download.html#fastqc)
* R (apt-get install r-base)
* R required libraries (apt-get install libcurl4-gnutls-dev & apt-get install libssl-dev)
* R packages (biocLite("phyloseq") & biocLite("optparse"))
* Java (apt-get install default-jre)
* JSON (cpan JSON)
* VSEARCH required libraries (apt-get install libargtable2-dev)
* VSEARCH (https://github.com/torognes/vsearch)
```
Make sure both PRINSEQ and FastQC are added to the systems PATH (CutAdapt should take care of that automatically).

### Galaxy configuration
The galaxyXML files and the bashWrapper files should either be copied to the Galaxy tool shed folder or be symbolically linked there.  
The tool files should be reachable by the bashWrappers, either by being present in the same folder or by adding the tool files to the systems PATH.

Edit the Galaxy tool_conf.xml file to add the tools to the Galaxy tool shed.  
The read quality analysis tools need a small galaxy.yml adjustment to correctly show their HTML output files. This adjustment concerns the "sanitize_all_html" option, which should be set to FALSE.

## Tool descriptions

### UMI isolation
Use a python script to cluster all UMIs and output a tabular file, a BLAST file and a zip file.  
Use a python script to accumulate all UMIs and output a tabular file, a BLAST file and a zip file.

The tabular file will contain all unique UMI nucleotides, a count of the number of reads that are associated with that UMI and a unique identifier for every UMI.

The BLAST file can be used to identify all UMI clusters.

The zip file will contain fastA files for every unique UMI and contain reads associated with that UMI, this zip file is created before VSEARCH is used for a final check.

Files in fastA format should always have a .fasta extension.  
Files in fastQ format should always have a .fastq extension.

### Taxonomic accumulator
Use a python script to accumulate all identifications based on taxonomy.  
The TaxonomicAccumulator tool will count all occurrences of the identifications for every taxonomic level, for every file used as input.

The tool will handle either a BLAST file, OTU file with old BLAST output, OTU file with new BLAST output, a zip file containing multiple BLAST files or a OTU file with LCA processing added to it.

Sample names can not start with a "#".  
All columns in a OTU table should have a header starting with "#".

### Accepted taxonomic name
Use a python script to utilize either the Global Names API or the TNRS api to collect accepted taxonomic names.  
The AcceptedTaxonomicName tool will utilize either the Global Names API or the Taxonomic Name Resolution Service API to collect accepted taxonomic names based on BLAST identifications.

Global Names is for every kingdom.  
TNRS is for plants only.

Sample names can not start with a "#".  
All columns in a OTU table should have a header starting with "#".

### Metadata
Use a python script to utilize the Naturalis, BOLD and ALA API's to collect meta data.  
The MetaData tool will utilize the Naturalis, BOLD and ALA API's to collect meta data such as occurrence status and images based on BLAST identifications or accepted taxonomic names.

Definitions for all occurrence status codes can be found on this [page](https://www.nederlandsesoorten.nl/content/occurrence-status).

Sample names can not start with a "#".  
All columns in a OTU table should have a header starting with "#".

### Phyloseq visual reporter
Use Phyloseq to a statistical analysis resulting in multiple plots.  
The Statistical Analysis tool will utilize the Phyloseq R package to create multiple plots based on a OTU table.

Sample names can not start with a "#".  
All columns in a OTU table should have a header starting with "#".

### FastQC analysis
Use FastQC to do quality control checks on raw sequence data.  
The FastQC tool will do quality control checks on raw sequence data. These checks include summary graphs and tables.

Files in fastQ format should always have a .fastq extension.

### PRINSEQ analysis
Use PRINSEQ to do quality control checks on raw sequence data.  
The PRINSEQ tool will do quality control checks on raw sequence data. These checks include summary graphs and tables.

Files in fastA format should always have a .fasta extension.  
Files in fastQ format should always have a .fastq extension.

### PRINSEQ trimmer
Use PRINSEQ to trim and discard reads and read sections.  
The PRINSEQ tool will trim and discard reads and read sections based on user input and quality thresholds.

Files in fastQ format should always have a .fastq extension.

### CutAdapt trimmer
Use CutAdapt to trim and discard reads and read sections.  
The CutAdapt tool will trim and discard reads and read sections based on user input and quality thresholds.

Files in fastQ format should always have a .fastq extension.

### Read counter
Use a bash script to count the reads of fastQ or fastA files.  
The ReadCount tool will count the number of reads in a file or multiple [zip] files and output these numbers to a text file.

Files in fastA format should always have a .fasta extension.  
Files in fastQ format should always have a .fastq extension.

### FastQ to fastA
Use a bash script to convert fastQ files to fastA files.  
The FastqToFasta tool will convert one or multiple [zip] fastQ files to fastA files using sed.

Files in fastQ format should always have a .fastq extension.

## Source(s)
* __Giardine B, Riemer C, Hardison RC, Burhans R, Elnitski L, Shah P__,  
  Galaxy: A platform for interactive large-scale genome analysis.  
  Genome Research. 2005; 15(10) 1451-1455 __doi: 10.1101/gr.4086505__  
  [GALAXY](https://www.galaxyproject.org/)
* __Schmieder R, Edwards R__,  
  Quality control and preprocessing of metagenomic datasets.  
  Bioinformatics. 2011; 27(6): 863-864. __doi: 10.1093/bioinformatics/btr026__  
  [PRINSEQ](http://prinseq.sourceforge.net/)
* __Martin M__,  
  Cutadapt Removes Adapter Sequences From High-throughput Sequencing Reads.  
  EMBnet.journal. 2011. __doi: 10.14806/ej.17.1.200__  
  [CutAdapt](http://cutadapt.readthedocs.io/en/stable/guide.html)
* __McMurdie PJ, Holmes S__,  
  Phyloseq: An R Package for Reproducible Interactive Analysis and Graphics of Microbiome Census Data.  
  PLOS One. 2013; 8(4). __doi: 10.1371/journal.pone.0061217__  
  [Phyloseq](https://joey711.github.io/phyloseq/)
* __Rognes T, Flouri T, Nichols B, Quince C, Mahe F__,  
  VSEARCH: a versatile open source tool for metagenomics.  
  Peerj. 2016. __doi: 10.7717/peerj.2584__  
  [VSEARCH](https://github.com/torognes/vsearch)
* __Ratnasingham S, Hebert PDN__,  
  BOLD: The Barcode of Life Data System.  
  Molecular Ecology Notes. 2007; 7(3). __doi: 10.1111/j.1471-8286.2007.01678.x__  
  [BOLD](http://www.boldsystems.org/index.php/resources/api)
* __Pyle RL__,  
  Towards a Global Names Architecture: The future of indexing scientific names.  
  ZooKeys. 2016; 550: 261-281. __doi: 10.3897/zookeys.550.10009__  
  [Global Names](https://resolver.globalnames.org/api)
* __Boyle B, Hopkins N, Lu Z, Garay JAR, Mozzherin D, Rees T__,  
  The taxonomic name resolution service: an online tool for automated standardization of plant names.  
  BMC Bioinformatics. 2013; 14(16). __doi: 10.1186/1471-2105-14-16__  
  [TNRS](http://tnrs.iplantcollaborative.org/api.html)
* __Andrews S__,  
  FastQC: A quality control tool for high throughput sequence data.  
  Babraham Bioinformatics. 2010.  
  [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
* Naturalis API [website](http://docs.biodiversitydata.nl/en/latest/introduction/)
* Nederlands Soortenregister [website](https://www.nederlandsesoorten.nl/)
* Atlas of Living Australia API [website](https://api.ala.org.au/)

## Author(s)
* [Jasper Boom](https://github.com/JasperBoom)

## Citation
* __Boom J__, galaxy-tools-naturalis-internship. 2018-2019.  
  GitHub repository: https://github.com/JasperBoom/galaxy-tools-naturalis-internship
