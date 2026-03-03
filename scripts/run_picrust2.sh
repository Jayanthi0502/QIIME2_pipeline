#!/usr/bin/env bash
set -e

#############################################
# PICRUSt2 Complete Processing Script
#############################################

# Adjust this path to where your QIIME2 outputs are
BASE_DIR="../raw_data/qiime"

REP_SEQS="$BASE_DIR/rep-seqs.qza"
TABLE="$BASE_DIR/table.qza"

EXPORT_DIR="$BASE_DIR/picrust2_export"
PICRUST_OUT="$BASE_DIR/picrust2_out"

THREADS=1
MIN_ALIGN=0.6

echo "Starting PICRUSt2 pipeline..."

# Create directories
mkdir -p "$EXPORT_DIR"
mkdir -p "$PICRUST_OUT"

#############################################
# Step 1: Export sequences
#############################################

echo "Exporting representative sequences..."
qiime tools export \
  --input-path "$REP_SEQS" \
  --output-path "$EXPORT_DIR/seqs"

#############################################
# Step 2: Export feature table
#############################################

echo "Exporting feature table..."
qiime tools export \
  --input-path "$TABLE" \
  --output-path "$EXPORT_DIR/table"

#############################################
# Step 3: Rename files for PICRUSt2
#############################################

mv "$EXPORT_DIR/seqs/dna-sequences.fasta" "$EXPORT_DIR/study_seqs.fna"
mv "$EXPORT_DIR/table/feature-table.biom" "$EXPORT_DIR/study_table.biom"

#############################################
# Step 4: Run PICRUSt2
#############################################

echo "Running PICRUSt2..."

picrust2_pipeline.py \
  -s "$EXPORT_DIR/study_seqs.fna" \
  -i "$EXPORT_DIR/study_table.biom" \
  -o "$PICRUST_OUT" \
  -p "$THREADS" \
  --min_align "$MIN_ALIGN" \
  --verbose

echo "PICRUSt2 completed successfully."
echo "Results located in: $PICRUST_OUT"
