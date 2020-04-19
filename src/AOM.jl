module AOM

using DataFrames, Dates, ShiftedArrays
using Statistics: mean, std
using StatsBase: tiedrank
using CSV: read

const stats_path = joinpath(dirname(@__DIR__),"stats")

include(joinpath(dirname(@__DIR__),"members","members.jl"))
include("load_results.jl")

include("elaborate.jl")

export past_members, curr_members
export append_stats, get_stats
export repeat_by!, delta, cust_z, ZScores, elaborate, update_results, last_week


end # module
