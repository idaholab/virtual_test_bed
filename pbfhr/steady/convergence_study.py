# General Python packages
import numpy as np
import unittest
import matplotlib.pyplot as plt

# Moose imports
import mms


class ConvergenceStudy(unittest.TestCase):
    def test(self):
        # 1 -> uniform_refine = 0
        # Desktop can run up to refine=3 -> 4
        df1 = mms.run_spatial('ss1_combined.i', 4, y_pp=['pressure_drop', 'max_Tf', 'bypass_fraction'], mpi=56, executable="/home/guillaume/projects/pronghorn/pronghorn-opt")

        plt.figure()
        plt.xlabel('Element Size ($h$ in m)', fontsize=16)
        plt.ylabel('Relative error (-)', fontsize=16)

        labels = ['pressure_drop', 'max_Tf', 'bypass_fraction']
        for i in range(1, df1.shape[1]):
            print(labels[i - 1])
            df = df1.values
            plt.loglog(df[:-1, 0], np.abs( (df[:-1, i] - df[-1, i]) / df[-1, i]), label=labels[i - 1], marker='o',
                markersize=8)

        plt.grid(True, which="both", ls="-")
        plt.tight_layout()
        plt.savefig('convergence.png')


if __name__ == '__main__':
    unittest.main(__name__, verbosity=2)
