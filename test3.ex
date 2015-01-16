include initial_ranking.e
include tight_tree.e
include feasible_ranking.e
include std/sequence.e
include std/search.e
include std/math.e

sequence V = {
    "A", "B", "C", "D", "E", "F", "V", 
    "Nab", "Nbc", "Ncd", "Nae", "Nev", "Nvd", "Nfd"
}

sequence E = {
    {"Nae", "A"},
    {"Nae", "E"},
    {"Nab", "A"},
    {"Nab", "B"},
    {"Nbc", "B"},
    {"Nbc", "C"},
    {"Ncd", "C"},
    {"Ncd", "D"},
    {"Nfd", "F"},
    {"Nfd", "D"},
    {"Nev", "E"},
    {"Nev", "V"},
    {"Nvd", "V"},
    {"Nvd", "D"},
    {"E", "B"},
    {"V", "C"},
    {"C", "F"}
}
 

sequence G = convert_graph(V, E)

G = feasible_ranking(G)

sequence R = G[RANKING]
for i = 0 to max(R) do
    printf(1, "Rank %d: ", i)
    sequence L = find_all(i, R)
    for j = 1 to length(L) do
        printf(1, "%s ", {V[L[j]]})
    end for
    printf(1, "\n")
end for
