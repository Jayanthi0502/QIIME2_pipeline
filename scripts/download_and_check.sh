#!/usr/bin/env bash
set -euo pipefail

# ==========================
# Configuration
# ==========================
ACCESSION="SRP233274"
THREADS=8

echo "Starting download and validation for ${ACCESSION}"

# ==========================
# Download FASTQ metadata
# ==========================
echo "Downloading FASTQ metadata TSV..."
wget -O ${ACCESSION}_fastq.tsv \
"https://www.ebi.ac.uk/ena/portal/api/filereport?accession=${ACCESSION}&result=read_run&fields=run_accession,fastq_ftp&download=true"

# ==========================
# Extract FTP URLs
# ==========================
echo "Extracting FTP URLs..."
awk -F"\t" '{split($2,a,";"); for(i in a) if(a[i]!="") print "ftp://"a[i]}' \
${ACCESSION}_fastq.tsv > urls.txt

echo "Total lines (including header):"
wc -l urls.txt

# Remove header
tail -n +2 urls.txt > urls_clean.txt
echo "Total FASTQ links (no header):"
wc -l urls_clean.txt

# ==========================
# Download FASTQ files
# ==========================
echo "Downloading FASTQ files..."
cat urls_clean.txt | xargs -n 1 -P ${THREADS} \
wget -c -nc --retry-connrefused --tries=50 --timeout=60

# ==========================
# Basic sanity checks
# ==========================
echo "Listing downloaded FASTQ files:"
ls -lh *.fastq.gz | sort

echo "Counting paired-end files:"
ls *_1.fastq.gz | wc -l
ls *_2.fastq.gz | wc -l

# ==========================
# Compare file sizes between pairs
# ==========================
echo "Checking size differences between paired reads..."
paste -d'\t' <(ls *_1.fastq.gz | sort) <(ls *_2.fastq.gz | sort) \
| while read f1 f2; do
  s1=$(stat -c%s "$f1")
  s2=$(stat -c%s "$f2")
  diff=$(awk "BEGIN {print (($s1>$s2)?($s1-$s2):($s2-$s1))/$s1*100}")
  printf "%-25s vs %-25s → %.1f%% difference\n" "$f1" "$f2" "$diff"
done | sort -k6 -n

# ==========================
# Download and verify MD5 checksums
# ==========================
echo "Downloading MD5 checksums..."
wget -O checksums.tsv \
"https://www.ebi.ac.uk/ena/portal/api/filereport?accession=${ACCESSION}&result=read_run&fields=fastq_md5,fastq_ftp&download=true"

echo "Preparing MD5 checksum file..."
awk -F"\t" '{
  split($2,a,";");
  split($1,b,";");
  for(i in a) {
    fn = a[i];
    gsub(/^.*\//, "", fn);
    print b[i]"  "fn;
  }
}' checksums.tsv | sed 's/\r//g' > md5sums.txt

echo "Running MD5 verification..."
md5sum -c md5sums.txt

echo "Download and validation completed successfully."
