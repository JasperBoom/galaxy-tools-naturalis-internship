#!/usr/bin/env bash

# Copyright (C) 2018 Jasper Boom

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License version 3 as
# published by the Free Software Foundation.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

# Prequisites:
# - sudo cpan JSON
# - Add "sanitize_all_html: false" to galaxy.yml 

# The runPrinseq function.
# This function calls the prinseq-lite tool in order to generate the data
# needed to create a html and graph file. The output of this tool is the input
# of the prinseq-graphs-noPCA tool, which generates the html file. The
# html file is send to the expected output location and the temporary storage
# directory is deleted.
runPrinseq() {
    prinseq-lite -${disExtension} ${flInput} -out_bad null -out_good null \
                 -graph_data ${strDirectory}_temp/flPrinseqOne.txt
    prinseq-graphs-noPCA -i ${strDirectory}_temp/flPrinseqOne.txt \
                         -html_all \
                         -o ${strDirectory}_temp/flPrinseqTwo
    cat ${strDirectory}_temp/flPrinseqTwo.html > ${fosOutput}
    rm -rf ${strDirectory}_temp
}

# The getZipSummary function.
# This function loops through all fastQ/fastA files extracted from the input
# file. It takes all lines from every file and copies these into
# flZipSummary.fastq/fasta. After the summary file has been created, the correct
# input variable is named and the runPrinseq function is called.
getZipSummary() {
    for strFile in ${strDirectory}_temp/*.${disExtension};
    do
        cat ${strFile} >> ${strDirectory}_temp/flZipSummary.${disExtension}
    done
    flInput=${strDirectory}_temp/flZipSummary.${disExtension}
    runPrinseq
}

# The getZipFile function.
# This function copies the input file to the temporary storage directory. The
# input file is searched for, based on its .dat extension. This search will
# output the name of the input file which is used to unzip it into the
# temporary storage directory. After unzipping, the getZipSummary function is
# called.
getZipFile() {
    cp ${fisInput} ${strDirectory}_temp
    strZipName=$(find ${strDirectory}_temp -name "*.dat" -printf "%f\n")
    unzip -q ${strDirectory}_temp/${strZipName} -d ${strDirectory}_temp
    getZipSummary
}

# The getFormatFlow function.
# This function creates a temporary storage directory in the output directory.
# It then initiates the correct function chain depending on the file format.
# When processing a single fastQ/fastA file, the correct input variable is named
# and the runPrinseq function is called. When processing a zip file, the
# getZipFile function is called.
getFormatFlow() {
    strDirectory=${fosOutput::-4}
    mkdir -p "${strDirectory}_temp"
    if [ "${disFormat}" = "single" ]
    then
        flInput=${fisInput}
        runPrinseq
    elif [ "${disFormat}" = "zip" ]
    then
        getZipFile
    fi
}

# The main function.
main() {
    getFormatFlow
}

# The getopts function.
while getopts ":i:o:f:e:vh" opt; do
    case ${opt} in
        i)
            fisInput=${OPTARG}
            ;;
        o)
            fosOutput=${OPTARG}
            ;;
        f)
            disFormat=${OPTARG}
            ;;
        e)  
            disExtension=${OPTARG}
            ;;
        v)
            echo ""
            echo "getPrinseqAnalysis.sh [0.1.0]"
            echo ""

            exit
            ;;
        h)
            echo ""
            echo "Usage: getPrinseqAnalysis.sh [-h] [-v] [-i INPUT]"
            echo "                             [-o OUTPUT] [-f FORMAT]"
            echo "                             [-e EXTENSION]"
            echo ""
            echo "Optional arguments:"
            echo " -h                    Show this help page and exit"
            echo " -v                    Show the software's version number"
            echo "                       and exit"
            echo " -i                    The location of the input file(s)"
            echo " -o                    The location of the output file(s)"
            echo " -f                    The format of the input" 
            echo "                       file(s) [single/zip]"
            echo " -e                    The extension of the input"
            echo "                       file(s) [fastq/fasta]"
            echo ""
            echo "The PRINSEQ tool will do quality control checks on raw"
            echo "sequence data. These checks include summary graphs and"
            echo "tables."
            echo ""
            echo "Files in fastA format should always have a .fasta extension."
            echo "Files in fastQ format should always have a .fastq extension."
            echo ""
            echo "Current PRINSEQ version:"
            prinseq-lite -version
            echo ""
            echo "Source(s):"
            echo " - Schmieder R, Edwards R, Quality control and preprocessing" 
            echo "   of metagenomic datasets."
            echo "   Bioinformatics. 2011; 27(6): 863-864."
            echo "   doi: 10.1093/bioinformatics/btr026"
            echo "   http://prinseq.sourceforge.net/"
            echo ""

            exit
            ;;
        \?)
            echo ""
            echo "You've entered an invalid option: -${OPTARG}."
            echo "Please use the -h option for correct formatting information."
            echo ""

            exit
            ;;
        :)
            echo ""
            echo "You've entered an invalid option: -${OPTARG}."
            echo "Please use the -h option for correct formatting information."
            echo ""

            exit
            ;;
    esac
done

main

# Additional information:
# =======================
#
# Files in fastA format should always have a .fasta extension.
# Files in fastQ format should always have a .fastq extension.
