cust_z(x,μ,σ) = ismissing(x) ? 0.0 : (x - μ)/σ

function ZScores(x::AbstractArray)
    μ = mean(skipmissing(x))
    σ = std(skipmissing(x))
    cust_z.(x,μ,σ)
end

function ZScores(df::AbstractDataFrame,col::Symbol)
    calc = by(df,:date) do dd
        (current = ZScores(dd[!,col]),
        name = dd.name)
    end
    rename!(calc,:current=>col)
end
