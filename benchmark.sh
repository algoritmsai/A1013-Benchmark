#!/bin/bash

# === CONFIG ===
MODEL="algoritms-a1013.model"  # Change this to your .model file if needed
LOGFILE="benchmark_times.txt"

# Clear old log
echo "Benchmark Results:" > "$LOGFILE"
echo "" >> "$LOGFILE"

# === Function to Run Benchmark ===
run_benchmark() {
    INPUT="$1"
    OUTPUT="$2"

    echo "Running tokenizer on: $INPUT"
    START=$(date +%s)

    spm_encode --model="$MODEL" < "$INPUT" > "$OUTPUT"

    END=$(date +%s)
    DIFF=$((END - START))

    # Format time
    if ((DIFF < 60)); then
        TIME_TAKEN="${DIFF}s"
    else
        MIN=$((DIFF / 60))
        SEC=$((DIFF % 60))
        TIME_TAKEN="${MIN}m ${SEC}s"
    fi

    echo "$INPUT: $TIME_TAKEN" >> "$LOGFILE"
    echo "✅ $INPUT -> $OUTPUT in $TIME_TAKEN"
    echo ""
}

# === Run Benchmarks ===

run_benchmark "ds_1k.txt" "ds_1k.tokens.txt"
run_benchmark "ds_10k.txt" "ds_10k.tokens.txt"
run_benchmark "ds_100k.txt" "ds_100k.tokens.txt"
run_benchmark "ds_100m.jsonl" "ds_100m.tokens.jsonl"

echo "🏁 All benchmarks completed. Log saved to $LOGFILE"
