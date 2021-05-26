function validate(options::Comonicon)
    if options.sysimg !== nothing
        isabspath(options.sysimg.path) && error("system image path must be project relative")
    end

    if options.application !== nothing
        isabspath(options.application.path) && error("application build path must project relative")
    end
    return
end

"""
    find_comonicon_toml(path::String, files=["Comonicon.toml", "JuliaComonicon.toml"])

Find `Comonicon.toml` or `JuliaComonicon.toml` in given path.
"""
function find_comonicon_toml(path::String, files=["Comonicon.toml", "JuliaComonicon.toml"])
    # user input file path
    basename(path) in files && return path

    # user input dir path
    for file in files
        path = joinpath(path, file)
        if ispath(path)
            return path
        end
    end
    return
end

"""
    read_toml(path::String)

Read `Comonicon.toml` or `JuliaComonicon.toml` in given path.
"""
function read_toml(path::String)
    file = find_comonicon_toml(path)
    file === nothing && return Dict{String,Any}()
    return TOML.parsefile(file)
end

"""
    read_toml(mod::Module)

Read `Comonicon.toml` or `JuliaComonicon.toml` in given module's project path.
"""
function read_toml(mod::Module)
    return read_toml(pkgdir(mod))
end

function has_comonicon_toml(m::Module)
    path = pkgdir(m)
    isnothing(path) && return false
    !isnothing(find_comonicon_toml(path))
end

"""
    read_options(comonicon; kwargs...)

Read in Comonicon build options. The argument `comonicon` can be:

- a module of a Comonicon CLI project.
- a path to a Comonicon CLI project that contains either `JuliaComonicon.toml` or `Comonicon.toml`.
- a path to a Comonicon CLI build configuration file named either `JuliaComonicon.toml` or `Comonicon.toml`.

In some cases, you might want to change the configuration written in the TOML file temporarily, e.g for writing
build tests etc. In this case, you can modify the configuration using corresponding keyword arguments.

keyword arguments of [`Application`](@ref) and [`SysImg`](@ref) are the same, thus keys like `filter_stdlibs`
are considered ambiguous in `read_options`, but you can specifiy them by specifiy the specific [`Application`](@ref)
or [`SysImg`](@ref) object, e.g

```julia
read_options(MyCLI; sysimg=SysImg(filter_stdlibs=false))
```

See also [`Comonicon`](@ref), [`Install`](@ref), [`SysImg`](@ref), [`Application`](@ref),
[`Download`](@ref), [`Precompile`](@ref).
"""
function read_options(m::Union{Module,String}; kwargs...)
    d = read_toml(m)
    if !haskey(d, "name")
        d["name"] = default_cmd_name(m)
    end

    options = from_dict(Comonicon, d; kwargs...)
    validate(options)
    return options
end

default_cmd_name(m::Module) = lowercase(string(nameof(m)))
default_cmd_name(m) = error("command name is not specified")
