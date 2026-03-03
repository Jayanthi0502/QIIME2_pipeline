#!/usr/bin/env bash
set -e

BASE_DIR="/mnt/g/QIIME/raw_reads/qiime"
METADATA="$BASE_DIR/metadata.tsv"
HEATMAP_DIR="$BASE_DIR/heatmap"

mkdir -p "$HEATMAP_DIR"

for LEVEL in {1..7}; do
  echo "Generating heatmap for level ${LEVEL}..."

  qiime feature-table heatmap \
    --i-table "$BASE_DIR/table_collapsed_absfreq_level${LEVEL}.qza" \
    --m-sample-metadata-file "$METADATA" \
    --m-sample-metadata-column Host_disease \
    --o-visualization "$HEATMAP_DIR/heatmap_level${LEVEL}.qzv"

done

echo "Heatmaps created successfully."
