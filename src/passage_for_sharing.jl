function lastweek(df)
    l_w = union(df.date)[end]
    last_df = filter(row -> row[:date] == l_w, df)
end

# const to_keep = [:name,
#     :rank_zscore_delta_arena_place,
#     :rank_zscore_delta_arena_victories,
#     :rank_zscore_delta_arena_defences,
#     :rank_zscore_delta_total_power,
#     :rank_zscore_delta_maxed_heroes,
#     :rank_zscore_clan_tokens,
#     :rank_zscore_raid_points,
#     :rank_zscore_portal_stones,
#     :rank_zscore_total]
const to_keep = [:name,
    :zscore_delta_arena_victories,
    :zscore_delta_total_power,
    :zscore_delta_maxed_heroes,
    :zscore_clan_tokens,
    :zscore_raid_points,
    :zscore_portal_stones,
    :zscore_total]
const new_names = [:name,
    :arena_victories,
    :total_power,
    :maxed_heroes,
    :clan_tokens,
    :raid_points,
    :portal_stones,
    :total]

function adjust_to_show(df)
    to_show = select(df,to_keep)
    rename!(to_show, new_names)
    round_names = filter(n-> n != :name, new_names)
    for n in round_names
        println(n)
        to_show[!,n] = round.(to_show[!,n];digits = 2)
    end
    sort!(to_show, :total, rev = true)
end
