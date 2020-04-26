function lastweek(df)
    l_w = union(df.date)[end]
    last_df = filter(row -> row[:date] == l_w, df)
end

const to_keep = [:name,
    :rank_zscore_delta_arena_place,
    :rank_zscore_delta_arena_victories,
    :rank_zscore_delta_arena_defences,
    :rank_zscore_delta_total_power,
    :rank_zscore_delta_maxed_heroes,
    :rank_zscore_clan_tokens,
    :rank_zscore_raid_points,
    :rank_zscore_portal_stones,
    :rank_zscore_total]
const new_names = [:name,
    :arena_place,
    :arena_victories,
    :arena_defences,
    :total_power,
    :maxed_heroes,
    :clan_tokens,
    :raid_points,
    :portal_stones,
    :total]

function adjust_to_show(df)
    to_show = select(df,to_keep)
    rename!(to_show, new_names)
    sort!(to_show, :total)
end
