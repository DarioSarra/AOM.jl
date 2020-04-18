module AOM
using Reexport

@reexport using DataFrames, Dates, ShiftedArrays
using CSV: read

const stats_path = joinpath(dirname(@__DIR__),"stats")

include(joinpath(dirname(@__DIR__),"members","members.jl"))
include("load_results.jl")
include("calc_deltas.jl")

export past_members, curr_members
export append_stats, get_stats
export deltas

end # module
