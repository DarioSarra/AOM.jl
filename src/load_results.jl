function append_stats()
    files = joinpath.(stats_path,readdir(stats_path))
    filter!(t -> !occursin.("DS_Store",t),files)
    full = DataFrame()
    for f in files
        df = read(f;normalizenames=true) |> DataFrame
        df.date = [Date(x,"dd-mm-yyyy") for x in df.date]
        if isempty(full)
            full = df
        else
            append!(full,df)
        end
    end
    return full
end
