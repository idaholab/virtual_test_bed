#!/usr/bin/env bash
# Multi-pass welding + cooldown pipeline (BlackBear / Grizzly).
#
#   ./run_pipeline.sh            welding, then cooldown (default)
#   ./run_pipeline.sh welding    welding stage only   (t = 0 -> 9625 s)
#   ./run_pipeline.sh cooldown   cooldown stage only  (t = 9625 -> 720000 s), from an existing welding run
#   any further arguments are passed to MOOSE, e.g.  ./run_pipeline.sh welding Executioner/num_steps=20
#
# Welding -> cooldown transfer happens inside the cooldown input (no values passed by this script):
#   * restart:  Problem/restart_file_base = ../welding/40mm/weld_cp/LATEST
#   * BCs:      the three bottom-node displacements are PiecewiseLinear functions read from
#               ../welding/40mm/scl.csv (ADFunctionDirichletBC), i.e. their welding-end values.
# Before the cooldown this script only checks that the pairing is valid:
#   * LATEST is the final (highest-numbered) welding checkpoint,
#   * the welding CSV ends at the time of that checkpoint (t = 9625 s for the full pipeline),
#   * the cooldown uses the checkpoint's rank count (a MOOSE restart needs the same rank count).
#
# Environment: MOOSE_EXEC (default blackbear-opt; e.g. grizzly-opt), MPIEXEC (default mpiexec),
#              NP (welding ranks, default 12), WELD_END_TIME (default 9625).
# CUDA builds of PETSc/SuperLU_DIST: SuperLU_DIST GPU offload is disabled (SUPERLU_ACC_OFFLOAD=0,
# CPU factorization, as validated); set SUPERLU_ACC_OFFLOAD=1 explicitly to re-enable it.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
die() { echo "ERROR: $*" >&2; exit 1; }

EXEC="${MOOSE_EXEC:-blackbear-opt}"
MPIEXEC="${MPIEXEC:-mpiexec}"
WELD_END_TIME="${WELD_END_TIME:-9625}"   # 8 passes x 1200 s + 25 s delay (welding/weld_config.i)
export SUPERLU_ACC_OFFLOAD="${SUPERLU_ACC_OFFLOAD:-0}"

stage="${1:-all}"; [ $# -gt 0 ] && shift
case "$stage" in welding|cooldown|all) ;; *) die "usage: $0 [welding|cooldown|all] [MOOSE args...]";; esac

run_welding() {
  echo "[welding] $MPIEXEC -n ${NP:-12} $EXEC -i weld.i $*"
  (cd welding && "$MPIEXEC" -n "${NP:-12}" "$EXEC" -i weld.i "$@" 2>&1 | tee weld.log)
}

run_cooldown() {
  local cp_dir=welding/40mm/weld_cp csv=welding/40mm/scl.csv step newest np t_end
  [ -d "$cp_dir" ] || die "no welding checkpoint directory: $cp_dir (run the welding stage first)"
  step=$(ls "$cp_dir" | sed -n 's/^\([0-9][0-9]*\)-mesh\.cpa\.gz$/\1/p' | sort -n | tail -1)
  newest=$(ls -t "$cp_dir" | sed -n 's/^\([0-9][0-9]*\)-mesh\.cpa\.gz$/\1/p' | head -1)
  [ -n "$step" ] || die "no checkpoint in $cp_dir"
  [ "$step" = "$newest" ] || die "LATEST would resolve to step $newest, but the final step is $step \
(checkpoint directory copied without preserving timestamps? use cp -a)"
  np=$(ls -d "$cp_dir/$step"-restart-*.rd | wc -l)
  [ -f "$csv" ] || die "no welding CSV: $csv"
  t_end=$(tail -1 "$csv" | cut -d, -f1)
  awk -v a="$t_end" -v b="$WELD_END_TIME" 'BEGIN{exit !(a-b<1e-6 && b-a<1e-6)}' \
    || die "welding CSV ends at t = $t_end, expected $WELD_END_TIME (welding run incomplete?)"
  echo "[cooldown] restart from $cp_dir step $step ($np ranks); BCs from $csv at t = $t_end"
  echo "[cooldown] $MPIEXEC -n $np $EXEC -i cooldown.i $*"
  (cd cooldown && "$MPIEXEC" -n "$np" "$EXEC" -i cooldown.i "$@" 2>&1 | tee cooldown.log)
}

case "$stage" in
  welding)  run_welding "$@" ;;
  cooldown) run_cooldown "$@" ;;
  all)      run_welding "$@"; run_cooldown "$@" ;;
esac
