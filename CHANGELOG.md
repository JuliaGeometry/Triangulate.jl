# Major changes

## v3.0 planned
- Remove plotting code (`plot_in_out`, `plot_triangulateio`)
- Remove deprecated `triunsuitable`

## v2.5 June 13, 2025
- Deprecate plotting code in Triangulate.jl
  - `plot_triangulateio` is now exported from GridVisualize.jl
  - See example notebook how to replace the deprecated code.
- Update example notebook

## v2.4.1 June 12, 2025
- Bump Makie compat
- Compathelper
- Fix dependabot


## v2.4.0 Jan 23, 2025
- Introduce Changelog
- Bump Makie compat
- Pre-commit
- Runic formatting

## v2.3.0 Nov 13, 2023
- Allow for Makie plots
- @deprecate triunsuitable triunsuitable!
- Remove PyPlot dependency for docs, replace by CairoMakie
- JuliaFormatter

## v2.2.0 Oct 10, 2022
- Fix ReadOnlyMemoryError occurring sometimes on windows for Julia <=1.8 and consistently for 1.9
- New upstream repo for Triangle c source: https://github.com/JuliaGeometry/Triangle

## v2.1.0  Oct 7, 2021
- switch Julia wrapper to MIT license
- Explain licensing terms of Triangle similar to the cases of FFTW and TetGen

## v2.0.0, June 16, 2021
Breaking (but not for core functionality): don't export plot anymore
- rename plot to plot_triangulateio
- keep Triangulate.plot (not exported)

## v1.0.1, Dec. 16, 2020
- Add option to plot circumcenters with PyPlot

## v0.4.0, Dec. 20, 2019
- bug fix: ownerships of regionlist, holelist
- bug fix: dimension of region list
- added several numberof... methods
- modified constructor: now we can write TriangulateIO(pointlist=...)
- added Base.show method for triangulateio compatible with modified constructor
- plot more stuff (regionlist, triangleattributes)
- export plot things

## v0.3.0, Dec. 17 2019
- throw TriangulateError instead of exiting Julia

## V0.2.0, Dec. 15 2019
- use binaries built with binary builder

## V0.1.0, Dec. 15 2019
- Initial release
