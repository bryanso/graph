include std/sequence.e
include std/math.e

object V = {
    "A", "B", "C", "D", "E", "F"
}


object E = {
    {"A", "B"},
    {"B", "C"},
    {"C", "D"},
    {"D", "E"},
    {"A", "E"},
    {"A", "F"},
    {"F", "E"}
}

sequence V1 = {1, 2, 3, 4, 5, 6}

? apply(E, routine_id("map"), V)

function map(sequence edge, sequence V)
    return {find(edge[1], V), find(edge[2], V)}
end function

function count(sequence x, object dummp)
    return length(x)
end function

? apply({{1,2,3}, {1}}, routine_id("count"))

? max({1, 2, 3, 0})

sequence s = {1, 2, 3}
? head(s)
? tail(s)
