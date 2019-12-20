module test_examples
include("../examples/example_pointsets.jl")
include("../examples/example_domains.jl")

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

# 
# Called by make_pngs.jl
#
function make_pngs(;Plotter=nothing)
    if ispyplot(Plotter)
        # Call all functions in this module whose names start with "example"
        for symbol in names(@__MODULE__,all=true)
            if findfirst("example_", String(symbol))==1:length("example_")
                getfield(@__MODULE__,symbol)(Plotter=Plotter)
                Plotter.savefig(String(symbol)*".png")
            end
        end
    end
end


# End of module
end
