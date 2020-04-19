const deltas_cols = [:arena_place,:arena_victories,:arena_defences,:total_power,:maxed_heroes]
const z_cols = [:clan_tokens,:raid_points,:portal_stones]


function repeat_by!(df,f,b,cc, n)
    c_list = [Symbol(join([n, x],"_")) for x in cc]
    for c in c_list
        df[!,c] = Vector{Union{Float64,Missing}}(undef,nrow(df))
    end
    by(df,b) do dd
        for (col,rcol) in zip(cc,c_list)
            dd[:,rcol] = f(dd[:,col])
        end
    end
    return df
end


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

function elaborate(df)
    # repeat_by!(full,delta,:name,deltas_cols,"delta_")
    # full.delta_arena_place = full.delta_arena_place .* -1
    # # elab_diff = colwise_op(full,calc_delta,deltas_cols)
    # # elab_diff.arena_place = elab_diff.arena_place .* -1
    # elab_zd = colwise_op(elab_diff,ZScores,deltas_cols)
    # elab_z = colwise_op(full,ZScores,z_cols)
    # elab = join(elab_zd,elab_z, on =[:name,:date])
    # sort!(elab,[:name,:date])
    # elab.total = elab.arena_place + elab.arena_victories + elab.arena_defences +
    #     elab.maxed_heroes + elab.clan_tokens + elab.raid_points + elab.portal_stones
    # select!(elab,[:date,:name,:arena_place,:arena_victories,:arena_defences,
    #     :maxed_heroes,:clan_tokens,:raid_points,:portal_stones,:total])
    df = get_stats()
    repeat_by!(df,delta,:name,deltas_cols,"delta")
    cc = deltas_cols
    c_list = [Symbol(join(["delta", x],"_")) for x in deltas_cols]
    cc = vcat(c_list,z_cols)
    repeat_by!(df,ZScores,:date,cc,"zscore")
    cc = names(df)
    filter!(t -> occursin("zscore",string(t)),cc)
    repeat_by!(df,tiedrank,:date,cc,"rank")
    return df
end

function update_results()
    full = get_stats()
    elab = elaborate(full)
    rank_weeks!(elab)
    return elab
end

function rank_weeks!(df)
    cc = names(df)
    filter!(t -> (t != :name) & (t != :date), cc)
    c_list = [Symbol(join(["rank", x],"_")) for x in cc]
    for c in c_list
        df[!,c] = Vector{Union{Float64,Missing}}(undef,nrow(df))
    end
    by(df,:date) do dd
        for (col,rcol) in zip(cc,c_list)
            dd[:,rcol] = tiedrank(dd[:,col];rev=true)
        end
    end
    df
end

function last_week(df)
    l_w = union(df.date)[end]
    last_df = filter(row -> row[:date] == l_w, df)
end
