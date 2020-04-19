const deltas_cols = [:arena_place,:arena_victories,:arena_defences,:total_power,:maxed_heroes]
const z_cols = [:clan_tokens,:raid_points,:portal_stones]

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
    return elab
end

function last_week(df)
    l_w = union(df.date)[end]
    last_df = filter(row -> row[:date] == l_w, df)
end
