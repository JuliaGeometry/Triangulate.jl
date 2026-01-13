using Test
using Triangulate
using ExplicitImports, Aqua

modname(fname) = splitext(basename(fname))[1]

#
# Include all Julia files in `testdir` whose name starts with `prefix`,
# Each file `prefixModName.jl` must contain a module named
# `prefixModName` which has a method test() returning true
# or false depending on success.
#
function run_tests_from_directory(testdir, prefix)
    return @testset "all tests" begin
        println("Directory $(testdir):")
        examples = modname.(readdir(testdir))
        for example in examples
            if example[1:length(prefix)] == prefix
                println("  $(example):")
                path = joinpath(testdir, "$(example).jl")
                @eval begin
                    include($path)
                    # Compile + run test
                    print("   compile:")
                    @time @test eval(Meta.parse("$($example).test()"))
                    # Second run: pure execution time.
                    print("       run:")
                    @time eval(Meta.parse("$($example).test()"))
                end
            end
        end
    end
end

@testset "functionality" begin
    run_tests_from_directory(@__DIR__, "test_")
end


@testset "ExplicitImports" begin
    @test ExplicitImports.check_no_implicit_imports(Triangulate, skip = (Base, Core)) === nothing
    @test ExplicitImports.check_all_explicit_imports_via_owners(Triangulate) === nothing
    @static if VERSION >= v"1.11.0"
        @test ExplicitImports.check_all_explicit_imports_are_public(Triangulate) === nothing
        @test ExplicitImports.check_all_qualified_accesses_are_public(Triangulate) === nothing
    end
    @test ExplicitImports.check_no_stale_explicit_imports(Triangulate, ignore = (:README,)) === nothing
    @test ExplicitImports.check_all_qualified_accesses_via_owners(Triangulate) === nothing
    @test ExplicitImports.check_no_self_qualified_accesses(Triangulate) === nothing
end

@testset "Aqua" begin
    Aqua.test_all(Triangulate)
end

if isdefined(Docs, :undocumented_names)
    @testset "UndocumentedNames" begin
        @test isempty(Docs.undocumented_names(Triangulate))
    end
end
