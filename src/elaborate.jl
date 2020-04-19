const deltas_cols = [:arena_place,:arena_victories,:arena_defences,:total_power,:maxed_heroes]
const z_cols = [:clan_tokens,:raid_points,:portal_stones]

function colwise_op(dd,f,cols)
    elab = DataFrame()
    for c in cols
        df = f(dd,c)
        if isempty(elab)
            elab = df
        else
            elab = join(elab,df, on =[:name,:date])
        end
    end
    return elab
end

function elaborate(full)
    elab_diff = colwise_op(full,calc_delta,deltas_cols)
    elab_diff.arena_place = elab_diff.arena_place .* -1
    elab_zd = colwise_op(elab_diff,ZScores,deltas_cols)
    elab_z = colwise_op(full,ZScores,z_cols)
    elab = join(elab_zd,elab_z, on =[:name,:date])
    sort!(elab,[:name,:date])
    elab.total = elab.arena_place + elab.arena_victories + elab.arena_defences +
        elab.maxed_heroes + elab.clan_tokens + elab.raid_points + elab.portal_stones
    select!(elab,[:date,:name,:arena_place,:arena_victories,:arena_defences,
        :maxed_heroes,:clan_tokens,:raid_points,:portal_stones,:total])
    return elab
end

function update_results()
    full = get_stats()
    elab = elaborate(full)
    rank_df = by(elab,:date,[names(elab)...] =>
        x -> (name = x.name,
        arena_place = tiedrank(x.arena_place,rev = true),
        arena_victories = tiedrank(x.arena_victories,rev = true),
        arena_defences = tiedrank(x.arena_defences,rev = true),
        maxed_heroes = tiedrank(x.maxed_heroes,rev = true),
        clan_tokens = tiedrank(x.clan_tokens,rev = true),
        raid_points = tiedrank(x.raid_points,rev = true),
        portal_stones = tiedrank(x.portal_stones,rev = true),
        total = tiedrank(x.total,rev = true),
        ))
    return elab, rank_df
end

function last_week(df)
    l_w = union(df.date)[end]
    last_df = filter(row -> row[:date] == l_w, df)
end
