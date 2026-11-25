#!/usr/bin/env pvpython
"""
Render the steady-state SEL SAM solution as 3D tubes colored by temperature.

Usage (needs ParaView's Python, which provides `paraview.simple`):

    pvpython sel_loop_temp.py [OnepinSS_out_displaced.e] [sel_loop_temp.png]

The Exodus file comes from the steady-state case: run `sam-opt -i OnepinSS.i` in
msr/sel. With no arguments the script reads it from the current directory and
writes sel_loop_temp.png next to this script.

Molten salt has its own colormap/colorbar; air and water share another.

This is a schematic rendering of a 1D system model, not true geometry:
  - Tube radii are proportional to each component's hydraulic diameter (`Dh` in
    OnepinSS.i), exaggerated so the network reads as piping, with a minimum radius.
  - SAM models the IHX as a single straight 5.7 m pipe, much longer than the rest
    of the loop. It is compressed along its own axis so it spans the gap between
    the pipes it couples to (end of Pipe2 -> start of Pipe3). Temperatures along
    the pipe are the SAM values; only the drawn length changes.
  - Where two fluids share a heat exchanger (IHX, SHX) the secondary side is drawn
    slightly above the primary side so both stay visible.
Solid blocks (heater pin, heat-exchanger walls) are not drawn.
"""
import os
import sys

from paraview.simple import (
    Tube, MergeBlocks, ExtractSurface, ProgrammableFilter, OpenDataFile, ColorBy,
    CreateView, Show, GetColorTransferFunction, GetScalarBar, SaveScreenshot, Text,
    GetAnimationScene, AppendGeometry,
)

exodus_path = sys.argv[1] if len(sys.argv) > 1 else 'OnepinSS_out_displaced.e'
out_png = (sys.argv[2] if len(sys.argv) > 2
           else os.path.join(os.path.dirname(os.path.abspath(__file__)), 'sel_loop_temp.png'))

RADIUS_EXAGGERATION = 1.4   # tube radius = this * Dh / 2 ...
MIN_RADIUS = 0.006          # ... but never thinner than this [m]
SECONDARY_DZ = 0.03         # draw secondary sides this far above the primary [m]

# Times, not the default Arial: ParaView 6.1's Arial draws '[' and ']' as '(' and ')'.
FONT = 'Times'

# group -> (colormap, range [K], colorbar title)
GROUPS = {
    'salt':      ('Inferno', (772.0, 784.0), 'Molten salt temperature [K]'),
    'air_water': ('Turbo',   (300.0, 790.0), 'Air/water temperature [K]'),
}

# IHX as modeled in OnepinSS.i: starts at the end of Pipe2 and runs along IHX_DIR
# for IHX_LENGTH. It is drawn instead as a straight run to the start of Pipe3.
IHX_START = (0.0, 0.9, 0.8)
IHX_DIR = (0.996180782, -0.087314654, 0.0)
IHX_LENGTH = 5.7264
IHX_DRAWN_END = (0.0, 0.4, 0.8)

# Exodus block -> (color group, hydraulic diameter [m], compress to fit (IHX)?, z offset [m])
BLOCKS = {
    'CH1:pipe':           ('salt', 0.015494, False, 0.0),
    'Pipe1':              ('salt', 0.040894, False, 0.0),
    'Pipe2':              ('salt', 0.040894, False, 0.0),
    'IHX:primary_pipe':   ('salt', 0.021184, True,  0.0),
    'Pipe3':              ('salt', 0.040894, False, 0.0),
    'Pipe4':              ('salt', 0.040894, False, 0.0),
    'Pipe5':              ('salt', 0.040894, False, 0.0),
    'Pipe6':              ('salt', 0.040894, False, 0.0),
    'Pipe7':              ('salt', 0.040894, False, 0.0),
    'Pipe8':              ('air_water', 0.003048, False, 0.0),
    'IHX:secondary_pipe': ('air_water', 0.003048, True,  SECONDARY_DZ),
    'Pipe9':              ('air_water', 0.003048, False, 0.0),
    'SHX:primary_pipe':   ('air_water', 0.01,     False, 0.0),
    'SHX:secondary_pipe': ('air_water', 0.01,     False, SECONDARY_DZ),
}

# Runs inside a ProgrammableFilter: optionally compress the IHX onto the straight
# gap between its neighbors, then shift in z. Placeholders are filled by .replace().
MOVE_SCRIPT = """
import numpy as np
from vtkmodules.util.numpy_support import numpy_to_vtk, vtk_to_numpy

src_data = self.GetInputDataObject(0, 0)
dst_data = self.GetOutputDataObject(0)
dst_data.DeepCopy(src_data)
p = vtk_to_numpy(src_data.GetPoints().GetData()).astype(float)

if @FIT@:
    start = np.array(@START@)
    end = np.array(@END@)
    axis = np.array(@DIR@)
    s = np.clip(((p - start) @ axis) / @LENGTH@, 0.0, 1.0)   # 0..1 along the IHX
    p = start + s[:, None] * (end - start)

p = p + np.array([0.0, 0.0, @DZ@])
dst_data.GetPoints().SetData(numpy_to_vtk(p, deep=True))
"""

view = CreateView('RenderView')
view.ViewSize = [2400, 1200]
view.OrientationAxesVisibility = 0
view.Background = [1, 1, 1]
try:  # newer ParaView needs this to honor a custom background color
    view.UseColorPaletteForBackground = 0
except AttributeError:
    pass

scene = GetAnimationScene()
tubes = {}
for block, (group, dh, fit, dz) in BLOCKS.items():
    reader = OpenDataFile(exodus_path)
    reader.ElementBlocks = [block]
    # last time step = converged steady state (the run pseudo-transients from t < 0)
    scene.UpdateAnimationUsingDataTimeSteps()
    scene.AnimationTime = reader.TimestepValues[-1]

    src = MergeBlocks(Input=reader)
    if fit or dz:
        src = ProgrammableFilter(Input=src)
        src.OutputDataSetType = 'vtkUnstructuredGrid'
        src.Script = (MOVE_SCRIPT
                      .replace('@FIT@', repr(fit))
                      .replace('@START@', repr(IHX_START))
                      .replace('@END@', repr(IHX_DRAWN_END))
                      .replace('@DIR@', repr(IHX_DIR))
                      .replace('@LENGTH@', repr(IHX_LENGTH))
                      .replace('@DZ@', repr(dz)))
    # Tube needs polydata; feeding the reader's multiblock unstructured grid to
    # Tube directly segfaults pvpython 6.1.
    lines = ExtractSurface(Input=src)
    tube = Tube(Input=lines)
    # (no builtin max(): pvpython's numpy_interface shadows it and rejects floats)
    radius = RADIUS_EXAGGERATION * dh / 2
    tube.Radius = radius if radius > MIN_RADIUS else MIN_RADIUS
    tube.NumberofSides = 24
    tube.Capping = 1

    tubes.setdefault(group, []).append(tube)

# One actor per color group (many separate actors exhaust the GPU's texture units,
# which makes the text and colorbars silently disappear).
displays = {}
for group, group_tubes in tubes.items():
    merged = AppendGeometry(Input=group_tubes)
    display = Show(merged, view)
    ColorBy(display, ('POINTS', 'temperature'))
    display.Specular = 0.4
    display.Ambient = 0.25
    displays[group] = [display]

# The loop lies in the y-z plane (x ~ 0); view it from +x, turned slightly for depth.
view.CameraFocalPoint = [0.0, 0.62, 0.55]
view.CameraPosition = [3.2, -0.8, 1.3]
view.CameraViewUp = [0, 0, 1]
view.CameraViewAngle = 30

IMG_W, IMG_H = 2400, 1200   # layout size; the saved image is SCALE times larger
SCALE = 3
CHAR_W = 0.0068   # approx. text width per character as a fraction of image width


def to_screen(point):
    """Project a world point to (x, y) fractions of the image for the current camera."""
    cam = view.GetActiveCamera()
    m = cam.GetCompositeProjectionTransformMatrix(IMG_W / IMG_H, -1, 1)
    v = [point[0], point[1], point[2], 1.0]
    # (no builtin sum(): pvpython's numpy_interface shadows it and rejects floats)
    c = [m.GetElement(r, 0) * v[0] + m.GetElement(r, 1) * v[1]
         + m.GetElement(r, 2) * v[2] + m.GetElement(r, 3) * v[3] for r in range(4)]
    return (c[0] / c[3] + 1) / 2, (c[1] / c[3] + 1) / 2


# Colorbar placement [x, y of lower-left corner, length], as image fractions.
# Salt bar sits inside the loop; air/water bar in the white space at the upper left.
sx0, sy0 = to_screen((0.0, 0.15, 0.30))
sx1, _ = to_screen((0.0, 0.95, 0.30))
# Air/water bar: same length as the salt bar, right end just left of the right-hand
# air pipe (y = 0.9), extending left over the salt loop's top-left corner region.
AIR_BAR_LEN = sx1 - sx0
ax_right, ay0 = to_screen((0.0, 0.80, 0.90))
BAR_POSITIONS = {
    'salt':      (sx0, sy0, sx1 - sx0),
    'air_water': (ax_right - AIR_BAR_LEN, ay0, AIR_BAR_LEN),
}

# One lookup table and colorbar per group (salt / air+water).
for group, (cmap, rng, title) in GROUPS.items():
    lut = GetColorTransferFunction(f'temperature_{group}')
    lut.ApplyPreset(cmap, True)
    lut.AutomaticRescaleRangeMode = 'Never'
    lut.RescaleTransferFunction(*rng)
    for display in displays[group]:
        display.LookupTable = lut

    bx, by, blen = BAR_POSITIONS[group]
    bar = GetScalarBar(lut, view)
    bar.Title = title
    bar.ComponentTitle = ''
    bar.Orientation = 'Horizontal'
    bar.WindowLocation = 'Any Location'
    bar.Position = [bx, by]
    bar.ScalarBarLength = blen
    bar.ScalarBarThickness = 22
    bar.TitleFontFamily = bar.LabelFontFamily = FONT
    bar.TitleFontSize = 26
    bar.LabelFontSize = 22
    bar.TitleColor = bar.LabelColor = [0.1, 0.1, 0.1]
    bar.RangeLabelFormat = '{:.0f}'
    bar.Visibility = 1


def label(txt, x, y, size=34, angle=0.0):
    """Screen-space text; x, y are fractions of the image."""
    t = Text(Text=txt)
    d = Show(t, view)
    d.WindowLocation = 'Any Location'
    d.Position = [x, y]
    d.FontFamily = FONT
    d.FontSize = size
    d.Color = [0.1, 0.1, 0.1]
    if angle:
        d.Orientation = angle
    return t


def label_left_of(txt, point):
    x, y = to_screen(point)
    label(txt, x - 0.012 - CHAR_W * len(txt), y - 0.015)


def label_right_of(txt, point):
    x, y = to_screen(point)
    label(txt, x + 0.02, y - 0.015)


def label_centered_at(txt, point):
    x, y = to_screen(point)
    label(txt, x - CHAR_W * len(txt) / 2, y - 0.015)


# Inlet arrows are annotations drawn onto the screenshot (see draw_arrow below), not
# 3D geometry. Each is (tip, direction): the tip stops ARROW_GAP short of the pipe end.
ARROW_LENGTH = 0.14   # [m] in the loop's coordinates
ARROW_GAP = 0.05
# Air enters the bottom of Pipe8 flowing up (+z); water enters the SHX end flowing +y.
AIR_TIP = (0.0, 0.32, 0.73)   # beside Pipe8 (y = 0.4), left of it
WATER_TIP = (0.0, 0.4 - ARROW_GAP, 1.2 + SECONDARY_DZ)
ARROWS = [(AIR_TIP, (0, 0, 1)), (WATER_TIP, (0, 1, 0))]


def arrow_tail(tip, direction):
    return tuple(tip[i] - direction[i] * ARROW_LENGTH for i in range(3))


label_left_of('Water', arrow_tail(WATER_TIP, (0, 1, 0)))
label_left_of('Air', (0.0, 0.32, 0.665))
label_centered_at('Pump', (0.0, 1.085, 0.125))
# Rotated 90 degrees to run along the vertical test section (CH1: z = 0.1 .. 0.6)
hx, hy = to_screen((0.0, 1.25, 0.35))
label('Heated section', hx - 0.018, hy - 0.09, angle=90.0)
label_centered_at('Primary HX', (0.0, 0.65, 0.73))
label_centered_at('Secondary HX', (0.0, 0.65, 1.155))

SaveScreenshot(out_png, view, ImageResolution=[IMG_W * SCALE, IMG_H * SCALE],
               TransparentBackground=0)

import numpy as np
from vtkmodules.vtkCommonDataModel import vtkImageData
from vtkmodules.vtkIOImage import vtkPNGReader, vtkPNGWriter
from vtkmodules.util.numpy_support import numpy_to_vtk, vtk_to_numpy

png = vtkPNGReader()
png.SetFileName(out_png)
png.Update()
img = png.GetOutput()
width, height, _ = img.GetDimensions()
scalars = img.GetPointData().GetScalars()
ncomp = scalars.GetNumberOfComponents()
pix = vtk_to_numpy(scalars).reshape(height, width, ncomp).copy()   # row 0 = bottom

ARROW_COLOR = np.array([26, 26, 26])
SHAFT_HALF_WIDTH = 3.0 * SCALE   # [px]
HEAD_LENGTH = 22.0 * SCALE       # [px]
HEAD_HALF_WIDTH = 11.0 * SCALE   # [px]


def draw_arrow(tip_world, direction):
    """Antialiased 2D arrow drawn onto `pix`; projected from 3D so it follows the camera."""
    tail_world = arrow_tail(tip_world, direction)
    tx, ty = to_screen(tip_world)
    sx, sy = to_screen(tail_world)
    tip = np.array([tx * width, ty * height])
    tail = np.array([sx * width, sy * height])
    u = tip - tail
    u = u / np.hypot(u[0], u[1])
    n = np.array([-u[1], u[0]])
    base = tip - u * HEAD_LENGTH
    pad = int(HEAD_HALF_WIDTH) + 4
    # (np.min/np.max, not builtins: pvpython's numpy_interface shadows those)
    x0 = int(np.min([tip[0], tail[0]])) - pad
    x1 = int(np.max([tip[0], tail[0]])) + pad
    y0 = int(np.min([tip[1], tail[1]])) - pad
    y1 = int(np.max([tip[1], tail[1]])) + pad
    yy, xx = np.mgrid[y0:y1, x0:x1]
    pts = np.stack([xx + 0.5, yy + 0.5], axis=-1) - tail           # relative to tail
    along = pts @ u
    across = pts @ n
    shaft_len = float(np.dot(base - tail, u))
    # shaft: distance to the segment tail -> base
    clamped = np.clip(along, 0.0, shaft_len)
    d_shaft = np.hypot(along - clamped, across)
    cov = np.clip(SHAFT_HALF_WIDTH + 0.5 - d_shaft, 0.0, 1.0)
    # head: triangle base -> tip, half width shrinking linearly to zero at the tip
    a = along - shaft_len                       # [px] from the head's base toward the tip
    half = HEAD_HALF_WIDTH * (1.0 - a / HEAD_LENGTH)
    inside = np.clip(half + 0.5 - np.abs(across), 0.0, 1.0)
    inside = inside * np.clip(a + 0.5, 0.0, 1.0) * np.clip(HEAD_LENGTH - a + 0.5, 0.0, 1.0)
    cov = np.maximum(cov, inside)
    region = pix[y0:y1, x0:x1, :3].astype(float)
    pix[y0:y1, x0:x1, :3] = (region * (1 - cov[..., None]) + ARROW_COLOR * cov[..., None]).astype(np.uint8)


for arrow_tip, arrow_dir in ARROWS:
    draw_arrow(arrow_tip, arrow_dir)

# Trim the white border, keeping a small margin on every side.
MARGIN_PX = 30 * SCALE

content = (pix[:, :, :3] < 250).any(axis=2)
rows = np.nonzero(content.any(axis=1))[0]
cols = np.nonzero(content.any(axis=0))[0]
r0 = int(rows[0]) - MARGIN_PX
r1 = int(rows[-1]) + MARGIN_PX + 1
c0 = int(cols[0]) - MARGIN_PX
c1 = int(cols[-1]) + MARGIN_PX + 1
r0 = r0 if r0 > 0 else 0
c0 = c0 if c0 > 0 else 0
r1 = r1 if r1 < height else height
c1 = c1 if c1 < width else width
crop = np.ascontiguousarray(pix[r0:r1, c0:c1])

out_img = vtkImageData()
out_img.SetDimensions(crop.shape[1], crop.shape[0], 1)
vtk_pix = numpy_to_vtk(crop.reshape(-1, ncomp), deep=True)
out_img.GetPointData().SetScalars(vtk_pix)
writer = vtkPNGWriter()
writer.SetFileName(out_png)
writer.SetInputData(out_img)
writer.Write()
print(f'wrote {out_png} ({crop.shape[1]}x{crop.shape[0]})')
