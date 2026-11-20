"""Compose a showcase figure for the GCMR core + BOP model:
3-D BISON temperature wedge (left) coupled to a redrawn THM Brayton-cycle plant (right).

Usage: python coupling_domains.py gcmr_ss.png coupling_domains.png
The wedge and colorbar are cropped from gcmr_ss.png (ParaView render of the baseline steady state).
"""
import sys
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, Polygon, FancyArrowPatch
from matplotlib.colors import ListedColormap, Normalize
from PIL import Image

src_path, out_path = sys.argv[1], sys.argv[2]
src = Image.open(src_path).convert("RGB")

# Wedge crop and the exact ParaView colormap sampled from the rendered colorbar
wedge = np.array(src.crop((600, 80, 1110, 960)))
bar = np.array(src.crop((550, 980, 1050, 1065)))[70]
nonwhite = np.where(bar.sum(axis=1) < 740)[0]
cmap = ListedColormap(bar[nonwhite[0] + 1:nonwhite[-1]] / 255.0)
norm = Normalize(850, 1250)

INK, MUTED, EDGE = "#1f2a36", "#5b6773", "#34495e"
HE, AIR = "#b83227", "#1f6fa8"
COMP = "#e9edf1"
AIR_COLD, AIR_WARM, AIR_HOT = "#8dbfe6", "#e8a556", "#d0583a"

fig = plt.figure(figsize=(16, 9), dpi=150, facecolor="white")

# ---------------- left: 3-D core wedge ----------------
ax_w = fig.add_axes([0.025, 0.12, 0.25, 0.73])
ax_w.imshow(wedge)
ax_w.axis("off")

ax_cb = fig.add_axes([0.045, 0.085, 0.21, 0.018])
cb = fig.colorbar(plt.cm.ScalarMappable(norm=norm, cmap=cmap), cax=ax_cb, orientation="horizontal")
cb.set_ticks([850, 950, 1050, 1150, 1250])
cb.outline.set_visible(False)
cb.ax.tick_params(labelsize=11, colors=INK, length=0, pad=4)
cb.set_label("Temperature (K)", fontsize=12, color=INK, labelpad=6)

TITLE_Y, SUB_Y = 0.935, 0.898
fig.text(0.15, TITLE_Y, "3-D core", ha="center", fontsize=21, weight="bold", color=INK)
fig.text(0.15, SUB_Y, "Griffin neutronics + BISON heat conduction", ha="center",
         fontsize=12.5, color=MUTED)
fig.text(0.665, TITLE_Y, "Balance of plant", ha="center", fontsize=21, weight="bold", color=INK)
fig.text(0.665, SUB_Y, "SAM + THM", ha="center", fontsize=12.5, color=MUTED)

# ---------------- right: plant schematic ----------------
ax = fig.add_axes([0.335, 0.03, 0.66, 0.86])
ax.set_xlim(0, 100)
ax.set_ylim(0, 60)
ax.set_aspect("equal")
ax.axis("off")

ax.add_patch(FancyBboxPatch((2, 2), 50, 54, boxstyle="round,pad=0,rounding_size=2.5",
                            fc="#fbefed", ec="none", zorder=0))
ax.add_patch(FancyBboxPatch((54, 2), 44, 54, boxstyle="round,pad=0,rounding_size=2.5",
                            fc="#ebf3fa", ec="none", zorder=0))
ax.text(5, 53, "Primary loop · helium", fontsize=15, weight="bold", color=HE, va="top")
ax.text(57, 53, "Secondary loop · air Brayton", fontsize=15, weight="bold", color=AIR, va="top")


def pipe(pts, color, lw=6.5, z=1):
    pts = np.array(pts)
    ax.plot(pts[:, 0], pts[:, 1], color=color, lw=lw, solid_capstyle="butt",
            solid_joinstyle="round", zorder=z)


def arrow(p0, p1):
    ax.add_patch(FancyArrowPatch(p0, p1, arrowstyle="-|>", mutation_scale=16, color=EDGE,
                                 lw=0, zorder=5))


def box(x, y, w, h, label, fc=COMP, fs=12, sub=None):
    ax.add_patch(FancyBboxPatch((x, y), w, h, boxstyle="round,pad=0,rounding_size=0.8",
                                fc=fc, ec=EDGE, lw=1.4, zorder=3))
    ax.text(x + w / 2, y + h / 2 + (1.0 if sub else 0), label, ha="center", va="center",
            fontsize=fs, color=INK, weight="bold", zorder=4)
    if sub:
        ax.text(x + w / 2, y + h / 2 - 1.4, sub, ha="center", va="center", fontsize=10,
                color=MUTED, zorder=4)


def tag(x, y, text, color):
    ax.text(x, y, text, fontsize=11.5, color="white", weight="bold", ha="center", va="center",
            zorder=6, bbox=dict(boxstyle="round,pad=0.35", fc=color, ec="none"))


# ---- primary loop ----
T_in, T_out = 797.0, 1050.0  # used only to colour the pipes/core (no numeric labels)
c_hot, c_cold = cmap(norm(T_out)), cmap(norm(T_in))
core = (8, 12, 9, 28)

pipe([(12.5, 38), (12.5, 46), (32, 46), (32, 34.5), (40, 34.5)], c_hot)
pipe([(40, 31.5), (35, 31.5), (35, 12)], c_cold)
pipe([(32, 10.5), (12.5, 10.5), (12.5, 14)], c_cold)
arrow((19, 46), (24, 46))
arrow((35, 25), (35, 20))
arrow((25, 10.5), (20, 10.5))

grad = np.linspace(T_in, T_out, 256)[:, None]
ax.imshow(grad, extent=(core[0], core[0] + core[2], core[1], core[1] + core[3]),
          origin="lower", cmap=cmap, norm=norm, zorder=2, aspect="auto")
ax.add_patch(FancyBboxPatch(core[:2], core[2], core[3], boxstyle="round,pad=0,rounding_size=0.5",
                            fc="none", ec=EDGE, lw=1.6, zorder=3))
for xc in np.linspace(core[0] + 1.8, core[0] + core[2] - 1.8, 5):
    ax.plot([xc, xc], [core[1] + 1, core[1] + core[3] - 1], color="white", lw=0.9, alpha=0.6,
            zorder=3)
ax.text(core[0] + core[2] / 2, core[1] + core[3] / 2, "Core", rotation=90, ha="center",
        va="center", fontsize=15, weight="bold", color="white", zorder=4)

ax.add_patch(Polygon([(30, 7), (39, 8.5), (39, 12.5), (30, 14)], closed=True, fc=COMP, ec=EDGE,
                     lw=1.4, zorder=3))
ax.text(34.3, 10.5, "Pump", ha="center", va="center", fontsize=11.5, weight="bold", color=INK,
        zorder=4)
ax.plot([39, 42], [10.5, 10.5], color=EDGE, lw=3, zorder=2)
box(42, 7.8, 8, 5.4, "Motor", fs=11.5)

# ---- heat exchanger spanning both loops ----
box(38, 30, 22, 7, "Heat exchanger", fc="white", fs=12.5)

# ---- secondary loop: generator | turbine | compressor | motor on one shaft ----
SH = 40          # shaft height
TX, CX = 75, 84.5  # turbine / compressor centerlines
ax.plot([65, 93], [SH, SH], color=EDGE, lw=3.5, zorder=2)
turb = Polygon([(TX - 1.5, 45.5), (TX + 1.5, 45.5), (TX + 3.5, 34.5), (TX - 3.5, 34.5)],
               closed=True, fc=COMP, ec=EDGE, lw=1.4, zorder=3)
comp = Polygon([(CX - 3.5, 45.5), (CX + 3.5, 45.5), (CX + 1.5, 34.5), (CX - 1.5, 34.5)],
               closed=True, fc=COMP, ec=EDGE, lw=1.4, zorder=3)
ax.add_patch(turb)
ax.add_patch(comp)
box(61, 37.0, 8.6, 6.0, "Generator", fs=10.5)
box(89.5, 37.0, 8, 6.0, "Motor", fs=11)
ax.text(TX, SH - 0.3, "Turbine", rotation=90, ha="center", va="center", fontsize=11.5,
        weight="bold", color=INK, zorder=4)
ax.text(CX, SH - 0.3, "Compressor", rotation=90, ha="center", va="center", fontsize=11.5,
        weight="bold", color=INK, zorder=4)

box(62, 8, 24, 7, "Recuperator", fc="white", fs=12.5)

# All pipe ends run underneath the components (components are drawn on top).
# HX (hot air) -> turbine inlet
pipe([(57, 35), (57, 49), (TX, 49), (TX, 42)], AIR_HOT)
arrow((59.5, 49), (63, 49))
# turbine exhaust -> recuperator hot side
pipe([(TX - 2, 37), (TX - 2, 12)], AIR_WARM)
arrow((TX - 2, 26), (TX - 2, 21))
# ambient air -> compressor
pipe([(97, 49), (CX, 49), (CX, 42)], AIR_COLD)
arrow((93, 49), (89, 49))
ax.text(95.5, 51, "Air in", fontsize=11.5, color=AIR, weight="bold", ha="center")
# compressor -> recuperator cold side
pipe([(CX, 37), (CX, 12)], AIR_COLD)
arrow((CX, 26), (CX, 21))
# recuperator (preheated) -> HX
pipe([(64, 11.5), (57, 11.5), (57, 32)], AIR_WARM)
arrow((57, 18), (57, 23))
# recuperator -> exhaust stack
pipe([(84, 11.5), (92, 11.5), (92, 22)], AIR_COLD)
ax.add_patch(Polygon([(90.4, 22), (93.6, 22), (92, 24.6)], closed=True, fc=AIR_COLD, ec="none",
                     zorder=5))
arrow((92, 15), (92, 19))
ax.text(92, 25.6, "Exhaust", fontsize=11.5, color=AIR, weight="bold", ha="center")

# ---------------- coupling between the 3-D core and the loop ----------------
fig.patches.append(FancyArrowPatch((0.282, 0.52), (0.378, 0.52), transform=fig.transFigure,
                                   arrowstyle="-|>", mutation_scale=20, color=INK, lw=2))
fig.patches.append(FancyArrowPatch((0.378, 0.43), (0.282, 0.43), transform=fig.transFigure,
                                   arrowstyle="-|>", mutation_scale=20, color=INK, lw=2))
fig.text(0.330, 0.540, "channel heat\nsource", ha="center", va="bottom", fontsize=10.5,
         color=INK, linespacing=1.15)
fig.text(0.330, 0.410, "inlet T, v\noutlet P", ha="center", va="top", fontsize=10.5,
         color=INK, linespacing=1.15)

fig.savefig(out_path, dpi=150, facecolor="white")
print("wrote", out_path)
