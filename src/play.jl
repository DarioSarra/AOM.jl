using Revise
using AOM
using BrowseTables
using StatsBase: tiedrank

res = update_results()

open_html_table(res)

##
df = get_stats()
repeat_by!(df,delta,:name,deltas_cols,"delta")
cc = deltas_cols
c_list = [Symbol(join(["delta", x],"_")) for x in deltas_cols]
cc = vcat(c_list,z_cols)
repeat_by!(df,ZScores,:date,cc,"zscore")
cc = names(df)
filter!(t -> occursin("zscore",string(t)),cc)
repeat_by!(df,tiedrank,:date,cc,"rank")
open_html_table(df)

#need a dataframe, a function, a column to group, columns to repeat, new name for cols


function repeat_by!(df,f,b,cc, n)
    c_list = [Symbol(join([n, x],"_")) for x in deltas_cols]
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
##
df = get_stats()
cc = deltas_cols
c_list = [Symbol(join(["delta", x],"_")) for x in deltas_cols]
cc = vcat(c_list,z_cols)
for c in c_list
    df[!,c] = Vector{Union{Float64,Missing}}(undef,nrow(df))
end
by(df,:name) do dd
    for (col,rcol) in zip(cc,c_list)
        dd[:,rcol] = dd[:,col] - lag(dd[:,col])
    end
end


df
open_html_table(df)
cc = names(Zdf)
filter!(t -> (t != :name) & (t != :date), cc)
c_list = [Symbol(join(["rank", x],"_")) for x in cc]
for c in c_list
    Zdf[!,c] = Vector{Union{Float64,Missing}}(undef,nrow(Zdf))
end

by(Zdf,:date) do dd
    for (col,rcol) in zip(cc,c_list)
        dd[:,rcol] = tiedrank(dd[:,col];rev=true)
    end
end
end

open_html_table(Zdf)

using Plots
elab.total

y = 30 .- elab.total
x = elab.name
bar(x,y,xrotation=45)

bar(y, xticks = (1:nrow(elab),
    elab[:name]),xrotation=45)
