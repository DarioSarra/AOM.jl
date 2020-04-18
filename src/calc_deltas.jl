function calc_delta(df,col)
    calc = by(df,:name) do dd
        (current = dd[:,col] - lag(dd[:,col]),
        date = dd.date)
    end
    rename!(calc,:current=>col)
end

function deltas(full)
    elab = DataFrame()
    for c in deltas_cols
        df = calc_delta(full,c)
        if isempty(elab)
            elab = df
        else
            elab = join(elab,df, on =[:name,:date])
        end
    end
    return elab
end
