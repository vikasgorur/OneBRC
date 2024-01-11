module OneBRC

# https://github.com/gunnarmorling/1brc

# %%
# Generate n records

include("stations.jl")

# Same as https://github.com/gunnarmorling/1brc/blob/main/src/main/java/dev/morling/onebrc/CreateMeasurementsFast.java
function generate(n::Int, out::String)
    N = length(STATIONS)
    open(out, "w") do f
        for i in 1:n
            station = STATIONS[rand(1:N)]
            temp = round(station[2] + 10.0 * randn() * 10.0) / 10.0
            println(f, "$(station[1]);$temp")
        end
    end
end

generate(1_000_000, "rows.txt")

# %%

using Statistics

function calcavg(in::String)::Dict{String, Vector{Float64}}
    "Calculate avg temperature per city"
    data = Dict{String, Vector{Float64}}()
    # vector of (min, mean, max, n)
    open(in) do f
        for line in eachline(f)
            city, temp = split(line, ';')
            temp = parse(Float64, temp)
            if haskey(data, city)
                min_, mean_, max_, n = data[city]
                data[city][1] = min(temp, min_)
                data[city][2] = (mean_ * n + temp) / (n+1)
                data[city][3] = max(temp, max_)
                data[city][4] = n+1
            else
                data[city] = [temp, temp, temp, 1]
            end
        end
    end
    return data
end

@time calcavg("rows.txt")

# %%

end # module OneBRC
