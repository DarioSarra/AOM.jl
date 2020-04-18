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
    elab_zd = colwise_op(elab_diff,ZScores,deltas_cols)
    elab_z = colwise_op(full,ZScores,z_cols)
    elab = join(elab_zd,elab_z, on =[:name,:date])
    return elab
end
