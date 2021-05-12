using ComoniconOptions
using Test

@testset "load options" begin
    options = read_options(joinpath(pkgdir(ComoniconOptions), "test"))
    display(options)
    @test options == ComoniconOptions.Comonicon(;
        name = "foo",
        install = ComoniconOptions.Install(;
            compile = "min",
        ),
        sysimg = ComoniconOptions.SysImg(;
            cpu_target = "native",
            precompile = ComoniconOptions.Precompile(;
                execution_file = ["deps/precopmile.jl"],
            ),
        ),
        download = ComoniconOptions.Download(;
            user = "Roger-luo",
            repo = "Foo.jl",
        ),
        application = ComoniconOptions.Application(;
            assets = ComoniconOptions.Asset[asset"PkgTemplate: templates", asset"assets/images"],
            incremental = true,
            filter_stdlibs = false,
        ),
    )
end
