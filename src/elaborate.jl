cust_z(x,μ,σ) = ismissing(x) ? 0.0 : (x - μ)/σ

function ZScores(x::AbstractArray)
    μ = mean(skipmissing(x))
    σ = std(skipmissing(x))
    cust_z.(x,μ,σ)
end

delta(vec) = vec - lag(vec)

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

function elaborate(df)
    # df = get_stats()
    repeat_by!(df,delta,:name,deltas_cols,"delta")
    cc = deltas_cols
    c_list = [Symbol(join(["delta", x],"_")) for x in deltas_cols]
    cc = vcat(c_list,z_cols)
    repeat_by!(df,ZScores,:date,cc,"zscore")
    df.zscore_delta_arena_place = df.zscore_delta_arena_place .* -1
    df.zscore_total = df.zscore_delta_arena_place .+ df.zscore_delta_arena_victories .+
        df.zscore_delta_arena_defences .+ df.zscore_delta_maxed_heroes .+
        df.zscore_clan_tokens .+ df.zscore_raid_points .+
        df.zscore_portal_stones
    cc = names(df)
    filter!(t -> occursin("zscore",string(t)),cc)
    repeat_by!(df,t->tiedrank(t;rev = true),:date,cc,"rank")
    return df
end

function update_results(clan::AbstractDict)
    full = get_stats(clan)
    elab = elaborate(full)
    return elab
end
