#!/usr/bin/env bash
set -e

BASE_DIR="/mnt/g/QIIME/raw_reads/qiime"
INPUT_TABLE="$BASE_DIR/cluster-table.qza"
INPUT_TAXONOMY="$BASE_DIR/taxonomy.qza"

ABS_DIR="$BASE_DIR/absfreq"
REL_DIR="$BASE_DIR/relfreq"

mkdir -p "$ABS_DIR" "$REL_DIR"

for LEVEL in {1..7}; do
  echo "Processing taxonomy level ${LEVEL}..."

  # Collapse taxonomy
  qiime taxa collapse \
    --i-table "$INPUT_TABLE" \
    --i-taxonomy "$INPUT_TAXONOMY" \
    --p-level "$LEVEL" \
    --o-collapsed-table "$BASE_DIR/table_collapsed_absfreq_level${LEVEL}.qza"

  # Export collapsed table
  qiime tools export \
    --input-path "$BASE_DIR/table_collapsed_absfreq_level${LEVEL}.qza" \
    --output-path "$ABS_DIR/level${LEVEL}"

  # Convert to TSV
  biom convert \
    -i "$ABS_DIR/level${LEVEL}/feature-table.biom" \
    -o "$ABS_DIR/feature-table_absfreq_level${LEVEL}.tsv" \
    --to-tsv --table-type 'Taxon table'

  # Relative frequency
  qiime feature-table relative-frequency \
    --i-table "$BASE_DIR/table_collapsed_absfreq_level${LEVEL}.qza" \
    --o-relative-frequency-table "$BASE_DIR/table_collapsed_relfreq_level${LEVEL}.qza"

  qiime tools export \
    --input-path "$BASE_DIR/table_collapsed_relfreq_level${LEVEL}.qza" \
    --output-path "$REL_DIR/level${LEVEL}"

  biom convert \
    -i "$REL_DIR/level${LEVEL}/feature-table.biom" \
    -o "$REL_DIR/feature-table_relfreq_level${LEVEL}.tsv" \
    --to-tsv --table-type 'Taxon table'

done

echo "All taxonomy levels processed successfully."
