const col_types = Dict(
    :date=>String,
    :name => String,
    :role => String,
    :arena_place => Union{Missing, Float64},
    :arena_victories => Union{Missing, Float64},
    :arena_defences => Union{Missing, Float64},
    :total_power => Union{Missing, Float64},
    :maxed_heroes => Union{Missing, Float64},
    :clan_tokens => Union{Missing, Float64},
    :raid_points => Union{Missing, Float64},
    :portal_stones => Union{Missing, Float64})

function append_stats()
    files = joinpath.(stats_path,readdir(stats_path))
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
    filter!(r -> !in(r[:name],past_members),full)
    return full
end

function complete_stats(full)
    sort!(full,(:date,:name))
    df = by(full,:name) do dd
        days = union(full.date)
        for d in days
            if !in(d,dd.date)
                println("missing data for $(dd.name[1]) day $(dd.date[1])")
                push!(full,[d,dd.name[1],dd.role[end], missings(8)...])
            end
        end
    end
    sort!(full,(:date,:name))
end

function get_stats()
    df = append_stats()
    complete_stats(df)
end
