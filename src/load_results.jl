const col_types = Dict(
    :date => String,
    :name => String,
    :role => String,
    :arena_place => Union{Missing, Float64},
    :arena_victories => Union{Missing, Float64},
    :arena_defences => Union{Missing, Float64},
    :total_power => Union{Missing, Float64},
    :maxed_heroes => Union{Missing, Float64},
    :clan_tokens => Union{Missing, Float64},
    :raid_points => Union{Missing, Float64},
    :portal_stones => Union{Missing, Float64},
    :Artus => Union{Missing, Float64},
    :Trorin => Union{Missing, Float64}
    )

function append_stats(clan::AbstractDict)
    dir = joinpath(stats_path,clan[:name])
    files = joinpath.(dir,readdir(dir))
    filter!(t -> !occursin.("DS_Store",t),files)
    full = DataFrame()
    for f in files
        df = read(f;types = col_types, normalizenames=true) |> DataFrame
        df.date = [Date(x,"dd-mm-yyyy") for x in df.date]
        if isempty(full)
            full = df
        else
            append!(full,df)
        end
    end
    filter!(r -> !in(r[:name],clan[:past_members]),full)
    if :Artus in names(full)
        select!(full,Not([:Artus,:Trorin]))
    end
    return full
end

## add missing values for dates were new members have no data
function complete_stats(full)
    sort!(full,(:date,:name))
    df = combine(groupby(full,:name)) do dd
        days = union(full.date)
        for d in days
            if !in(d,dd.date)
                println("missing data for $(dd.name[1]) day $(dd.date[1])")
                push!(full,[d,dd.name[1],dd.role[end], missings(ncol(full)-3)...])
            end
        end
    end
    sort!(full,(:date,:name))
end

function get_stats(clan::AbstractDict)
    df = append_stats(clan)
    complete_stats(df)
end
