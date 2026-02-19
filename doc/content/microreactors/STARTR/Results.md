# Results

To fully characterize the underlying physics for STARTR, a comprehensive test suite was performed in both OpenMC and MCNP. Details on testing configurations and plots can be found in the STARTR companion milestone report for NRIC.

## Testing Suite

The list of tests that were performed is as follows:

1. k-eigenvalue

    - Hot (900K), control drums (CD) full out
   
    - Hot, CD critical position (HFP)
   
    - Cold (294K), CD full in
   
    - Cold, CD critical position (CZP)

2. Flux Spectrum

    - HFP

    - CZP

3. 2D Power Peaking

    - Radial HFP and CZP

    - Axial HFP and CZP

4. CD Worth Curves\*

    - HFP and CZP

5. Shutdown Margin

6. Temperature Reactivity Coefficients

    - Isothermal whole-model

    - Isolated material effects

    - Sodium density

\*There is one unresolved open item for the MCNP and OpenMC analysis of STARTR. There are significant and unexpected differences in the calculated control drum worths for MCNP compared to OpenMC for partially rotated control drum positions. Due to time and funding restraints, the models are being released with this open item unresolved and will be updated when additional analysis can be made to identify the source of the differences. 

