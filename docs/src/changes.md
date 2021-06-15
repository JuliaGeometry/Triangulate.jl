# Changes
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
