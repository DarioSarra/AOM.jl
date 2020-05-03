module AOM

using DataFrames, Dates, ShiftedArrays
using Statistics: mean, std
using StatsBase: tiedrank
using CSV: read
using Plots, Plots.PlotMeasures



include("constants.jl")
include("clans.jl")
include("load_results.jl")
include("elaborate.jl")
include("passage_for_sharing.jl")
include("plotting.jl")

export savefig
export past_members, curr_members
export append_stats, get_stats
export repeat_by!, delta, cust_z, ZScores, elaborate, update_results
export lastweek, adjust_to_show
export plot_results
export RequiemFusion

end # module
