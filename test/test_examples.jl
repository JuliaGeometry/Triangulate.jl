module test_examples
include("example_pointsets.jl")
include("example_domains.jl")

# 
# Called by runtest.
#
function test()
    # Call all functions in this module whose names start with "example"
    for symbol in names(@__MODULE__,all=true)
        if findfirst("example_", String(symbol))==1:length("example_")
            println("Testing $(String(symbol))...")
            getfield(@__MODULE__,symbol)()
        end
    end
    true
end



# End of module
end
