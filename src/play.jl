using Revise
using AOM
using BrowseTables

##
res = update_results()
lw = lastweek(res)
open_html_table(lw)
##
p = AOM.plot_results(lw)
savefig(p,"/Users/dariosarra/Documents/House/AOM/Stats/19-Apr-2020.png")
##
using DataFrames
ns = names(lw)
filter!(n->occursin("rank", string(n)), ns)
println.(ns)
to_keep = [:rank_zscore_delta_arena_place,
    :rank_zscore_delta_arena_victories,
    :rank_zscore_delta_arena_defences,
    :rank_zscore_delta_total_power,
    :rank_zscore_delta_maxed_heroes,
    :rank_zscore_clan_tokens,
    :rank_zscore_raid_points,
    :rank_zscore_portal_stones,
    :rank_zscore_total]
new_names = [:arena_place,
    :arena_victories,
    :arena_defences,
    :total_power,
    :maxed_heroes,
    :clan_tokens,
    :raid_points,
    :portal_stones,
    :total]
to_show = select(lw,to_keep)
rename!(to_show, new_names)
