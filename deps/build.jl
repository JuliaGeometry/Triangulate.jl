using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libtriangle"], :libtriangle),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaGeometry/TriangleBuilder/releases/download/v0.2.0"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc) => ("$bin_prefix/Triangle.v1.6.0.aarch64-linux-gnu.tar.gz", "23f03cb92f6c9f7cc32d31d48886ecd763f23e9df30e670195acf2ebb772f37b"),
    Linux(:aarch64, libc=:musl) => ("$bin_prefix/Triangle.v1.6.0.aarch64-linux-musl.tar.gz", "3d7c59408eeab95857720f947cb3a4ee06dcd73ad24cc8119bb5dfa559509058"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf) => ("$bin_prefix/Triangle.v1.6.0.arm-linux-gnueabihf.tar.gz", "6dc920f4697d220da39a57766839e30ae1feb5bdcca80604ffaca8af54d3cfd0"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf) => ("$bin_prefix/Triangle.v1.6.0.arm-linux-musleabihf.tar.gz", "20e533c1f54167e396165825e3b3a5d5b98b627d03acc7297d6c79bc1befe6d3"),
    Linux(:i686, libc=:glibc) => ("$bin_prefix/Triangle.v1.6.0.i686-linux-gnu.tar.gz", "917d08ccbd87bd84f27bee24e021cb7d3b4e66b2f2d23f00df72c13df788f6a2"),
    Linux(:i686, libc=:musl) => ("$bin_prefix/Triangle.v1.6.0.i686-linux-musl.tar.gz", "db4ea1404299bef5f025cef7fb9da172d5d674b6be3964256a9d83ecba7f70f0"),
    Windows(:i686) => ("$bin_prefix/Triangle.v1.6.0.i686-w64-mingw32.tar.gz", "2ca288c0a918f174a706cb3c2188e3b96bb5490de3a685f217e567718ce6f287"),
    Linux(:powerpc64le, libc=:glibc) => ("$bin_prefix/Triangle.v1.6.0.powerpc64le-linux-gnu.tar.gz", "e734bbfe3aa2e4be447a665464f3566b95c90fd796a3e3919eec0a151923e8e1"),
    MacOS(:x86_64) => ("$bin_prefix/Triangle.v1.6.0.x86_64-apple-darwin14.tar.gz", "0eea003a508eca29be08b581f606e1c342cba5090c6b890d6ba1c9e24a938c9d"),
    Linux(:x86_64, libc=:glibc) => ("$bin_prefix/Triangle.v1.6.0.x86_64-linux-gnu.tar.gz", "1c4800d8913a9ac556e8c9a464a5b2e195b5b66c9aaf603564f3f543e1b3f042"),
    Linux(:x86_64, libc=:musl) => ("$bin_prefix/Triangle.v1.6.0.x86_64-linux-musl.tar.gz", "7efd7ff381596849e6aa68141bd62107f763d8eebec64c806c5544cf0db0e08c"),
    FreeBSD(:x86_64) => ("$bin_prefix/Triangle.v1.6.0.x86_64-unknown-freebsd11.1.tar.gz", "b1de36c1a600f5f4b7b3d69888feb2657f386cc79d148b06a44a800af28bf1a7"),
    Windows(:x86_64) => ("$bin_prefix/Triangle.v1.6.0.x86_64-w64-mingw32.tar.gz", "62e9a5914708a5670011a7c8f9364ece2f8635c0225b2773957c2a2493f8ef11"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

# If we have a download, and we are unsatisfied (or the version we're
# trying to install is not itself installed) then load it up!
if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
    # Download and install binaries
    install(dl_info...; prefix=prefix, force=true, verbose=verbose)
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)