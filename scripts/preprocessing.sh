#!/usr/bin/env bash
# run_qc_pipeline.sh
# Runs FastQC (before), fastp, and FastQC (after)

set -e

INPUT_DIR="raw_data"
TRIM_DIR="fastp_out"
QC_BEFORE="fastqc_results_before"
QC_AFTER="fastqc_results_after"
THREADS=4

mkdir -p "$TRIM_DIR" "$QC_BEFORE" "$QC_AFTER"

echo "Running FastQC on raw reads..."
fastqc ${INPUT_DIR}/*.fastq.gz -o "$QC_BEFORE"

echo "Starting fastp trimming..."

for f1 in ${INPUT_DIR}/*_1.fastq.gz; do
    f2="${f1/_1.fastq.gz/_2.fastq.gz}"
    sample=$(basename "$f1" _1.fastq.gz)

    echo "Processing $sample ..."

    fastp \
        -i "$f1" \
        -I "$f2" \
        -o "${TRIM_DIR}/${sample}_1.trimmed.fastq.gz" \
        -O "${TRIM_DIR}/${sample}_2.trimmed.fastq.gz" \
        --html "${TRIM_DIR}/${sample}.html" \
        --json "${TRIM_DIR}/${sample}.json" \
        --thread $THREADS
done

echo "Running FastQC on trimmed reads..."
fastqc ${TRIM_DIR}/*.fastq.gz -o "$QC_AFTER"

echo "Preprocessing complete."
