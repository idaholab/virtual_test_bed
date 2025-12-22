# Sodium-cooled Thermal-spectrum Advanced Research Test Reactor (STARTR)

*Contacts: Travis Lange (Travis.Lange.at.inl.gov), Daniel Grammer (grammer_daniel.at.berkeley.edu)*

<!-- Update link when model is actually uploaded to make sure it's correct -->
*Model link: [STARTR](https://github.com/idaholab/virtual_test_bed/tree/devel/sfr/STARTR)*

<!-- TODO: ADD image to website and put correct link here -->
!tag name=STARTR
	description=A "starter" sodium-cooled thermal reactor model based on MARVEL geometry
	image=https://mooseframework.inl.gov/virtual_test_bed/media/STARTR/index_image.png
	pairs=reactor_type:microreactor
		reactor:STARTR
		geometry:core
		simulation_type:neutronics
		transient:steady_state
		codes_used:OpenMC;MCNP
		open_source:true
		computing_needs:workstation
		fiscal_year:2025
		institution:INL
		sponsor:NRIC

[Model Description](Model_Description.md)

[OpenMC Model](OpenMC_Model.md)

[MCNP Model](MCNP_Model.md)

[Results](Results.md)
