Triangulate
===========

[![Build status](https://github.com/JuliaGeometry/Triangulate.jl/workflows/linux-macos-windows/badge.svg)](https://github.com/JuliaGeometry/Triangulate.jl/actions)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliageometry.github.io/Triangulate.jl/stable)
[![PkgEval](https://juliaci.github.io/NanosoldierReports/pkgeval_badges/T/Triangulate.svg)](https://juliaci.github.io/NanosoldierReports/pkgeval_badges/report.html)

Julia wrapper for Jonathan Richard Shewchuk's Triangle mesh generator. The package tries to provide a 1:1 mapping of Triangle's functionality to Julia.

## Useful information about Triangle:
- Triangle home page   [https://www.cs.cmu.edu/~quake/triangle.html](https://www.cs.cmu.edu/~quake/triangle.html)
  with instructions for using Triangle
   - [Research credit, references, and online papers](https://www.cs.cmu.edu/~quake/triangle.research.html)
   - [Troubleshooting](https://www.cs.cmu.edu/~quake/triangle.trouble.html)
   - [Command line switches](https://www.cs.cmu.edu/~quake/triangle.switch.html)


## Licensing

When installing Triangulate.jl, a compiled library version of the Triangle library will be downloaded from the [Triangle_jll.jl](https://github.com/JuliaBinaryWrappers/Triangle_jll.jl) repository.  This library is freely available with Commercial Use Restriction,  but the bindings to the library in this package, Triangulate.jl, are licensed under MIT. This means that code using the Triangle library via the Triangulate.jl bindings is subject to Triangle's licensing terms reproduced here:

````
These programs may be freely redistributed under the condition that the
copyright notices (including the copy of this notice in the code comments
and the copyright notice printed when the `-h' switch is selected) are
not removed, and no compensation is received.  Private, research, and
institutional use is free.  You may distribute modified versions of this
code UNDER THE CONDITION THAT THIS CODE AND ANY MODIFICATIONS MADE TO IT
IN THE SAME FILE REMAIN UNDER COPYRIGHT OF THE ORIGINAL AUTHOR, BOTH
SOURCE AND OBJECT CODE ARE MADE FREELY AVAILABLE WITHOUT CHARGE, AND
CLEAR NOTICE IS GIVEN OF THE MODIFICATIONS.  Distribution of this code as
part of a commercial system is permissible ONLY BY DIRECT ARRANGEMENT
WITH THE AUTHOR.  (If you are not directly supplying this code to a
customer, and you are instead telling them how they can obtain it for
free, then you are not required to make any arrangement with me.)
````



## Acknowledgement
This package uses ideas from  [TriangleMesh.jl](https://github.com/konsim83/TriangleMesh.jl)
and [Triangle.jl](https://github.com/cvdlab/Triangle.jl).


