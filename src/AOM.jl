module AOM
using Reexport

@reexport using DataFrames, Dates, ShiftedArrays
using Statistics: mean, std
using StatsBase: tiedrank
using CSV: read

const stats_path = joinpath(dirname(@__DIR__),"stats")

include(joinpath(dirname(@__DIR__),"members","members.jl"))
include("load_results.jl")
include("calc_deltas.jl")
include("calc_zscores.jl")
include("elaborate.jl")

export past_members, curr_members
export append_stats, get_stats
export calc_delta, deltas, ZScores
export deltas_cols, z_cols, colwise_op, elaborate, last_week_results

end # module
