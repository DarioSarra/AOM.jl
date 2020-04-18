module AOM
using Reexport

@reexport using DataFrames, Dates
using CSV: read

const stats_path = joinpath(dirname(@__DIR__),"stats")

include("load_results.jl")
export append_stats

end # module
