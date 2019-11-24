````@eval
using Markdown
Markdown.parse("""
$(read("../../README.md",String))
""")
````



```@autodocs
Modules = [TriangleRaw]
Pages = [ 
"ctriangulateio.jl",
"triangulateio.jl"
]
Order = [:type,:function]
```

