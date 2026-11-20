"""Coupling hierarchy diagram for the GCMR core + BOP multiphysics model.

Replaces the right-hand side of coupling_hierarchy_strategy.png.
Transfers follow microreactors/gcmr/core/Multiphysics/bop_base/MP_BISON_bop_base.i and
common/MP_Griffin_base.i.

Usage: python coupling_hierarchy.py coupling_hierarchy.png
"""
import sys
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

out_path = sys.argv[1]

INK, MUTED = "#1f2a36", "#5b6773"
C_GRIF, C_BISON, C_SAM, C_THM = "#7b2d8e", "#3f9a3a", "#1f8bd1", "#2b2f36"
C_DOWN, C_UP = "#d9822b", "#2f7d32"   # data going down / up the hierarchy

fig = plt.figure(figsize=(14, 7.2), dpi=200, facecolor="white")
ax = fig.add_axes([0, 0, 1, 1])
ax.set_xlim(0, 140)
ax.set_ylim(0, 72)
ax.axis("off")


CAPTION = {"Griffin": "neutronics", "BISON": "solid heat conduction",
           "SAM": "per-channel coolant", "THM": "balance-of-plant loop"}


def app(cx, cy, w, h, name, color):
    h = 11
    ax.add_patch(FancyBboxPatch((cx - w / 2, cy - h / 2), w, h,
                                boxstyle="round,pad=0,rounding_size=1.2", fc=color, ec="none",
                                zorder=3))
    ax.text(cx, cy + 1.3, name, ha="center", va="center", fontsize=24, weight="bold",
            color="white", zorder=4)
    ax.text(cx, cy - 2.8, CAPTION[name], ha="center", va="center", fontsize=11.5,
            color="white", style="italic", alpha=0.92, zorder=4)


def link(p0, p1, color, rad=0.0):
    ax.add_patch(FancyArrowPatch(p0, p1, arrowstyle="-|>", mutation_scale=20, lw=2.4,
                                 color=color, shrinkA=0, shrinkB=0, zorder=2,
                                 connectionstyle=f"arc3,rad={rad}"))


def label(x, y, text, color, ha="center", fs=14):
    ax.text(x, y, text, ha=ha, va="center", fontsize=fs, color=color, weight="bold",
            linespacing=1.25, zorder=5)


# ---- levels (labels on the left, light bands behind) ----
bands = [(58, "Level 1", "main app"), (36, "Level 2", "child app"), (11, "Level 3", "grandchild apps")]
for y, lv, role in bands:
    ax.add_patch(FancyBboxPatch((1.5, y - 8.5), 137, 17, boxstyle="round,pad=0,rounding_size=1.5",
                                fc="#f5f7f9", ec="none", zorder=0))
    ax.text(4, y + 1.2, lv, fontsize=15, weight="bold", color=INK, va="center")
    ax.text(4, y - 1.8, role, fontsize=12.5, color=MUTED, va="center")

# ---- apps ----
G = (76, 58)
B = (76, 36)
S = (44, 11)
T = (108, 11)
app(*G, 28, 9, "Griffin", C_GRIF)
app(*B, 90, 9, "BISON", C_BISON)
app(*S, 28, 9, "SAM", C_SAM)
app(*T, 28, 9, "THM", C_THM)

# ---- Griffin <-> BISON ----
link((70, 52), (70, 41.8), C_DOWN)
link((82, 41.8), (82, 52), C_UP)
label(67.5, 47, "power\ndensity", C_DOWN, ha="right")
label(84.5, 47, "fuel & moderator\ntemperature", C_UP, ha="left")

# ---- BISON -> THM (heat) and THM -> BISON (core BCs) ----
link((101, 30.2), (101, 16.8), C_DOWN)
link((115, 16.8), (115, 30.2), C_UP)
label(99, 23.5, "heating density\nin coolant channels", C_DOWN, ha="right", fs=13)
label(117, 23.5, "core inlet T, v\noutlet P", C_UP, ha="left", fs=13)

# ---- BISON <-> SAM ----
link((38, 30.2), (38, 16.8), C_DOWN)
link((50, 16.8), (50, 30.2), C_UP)
label(36, 23.5, "wall temperature\n+ core inlet T, v,\noutlet P (relayed)", C_DOWN, ha="right",
      fs=13)
label(52, 23.5, "fluid temperature\n+ convective HTC", C_UP, ha="left", fs=13)

# ---- legend ----
ax.add_patch(FancyArrowPatch((112, 61), (117, 61), arrowstyle="-|>", mutation_scale=16, lw=2.2,
                             color=C_DOWN))
ax.text(118.5, 61, "parent → child", fontsize=12, color=INK, va="center")
ax.add_patch(FancyArrowPatch((112, 56.5), (117, 56.5), arrowstyle="-|>", mutation_scale=16, lw=2.2,
                             color=C_UP))
ax.text(118.5, 56.5, "child → parent", fontsize=12, color=INK, va="center")

fig.savefig(out_path, dpi=200, facecolor="white")
print("wrote", out_path)
