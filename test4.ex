include initial_ranking.e
include tight_tree.e
include feasible_ranking.e
include std/sequence.e
include std/search.e
include std/math.e

sequence V = {
    "A", "B", "C", "D", "E", "F", "G", "H"
}

sequence E = {
    {"A", "B"},
    {"B", "C"},
    {"C", "D"},
    {"D", "H"},
    {"A", "E"},
    {"A", "F"},
    {"E", "G"},
    {"F", "G"},
    {"G", "H"}
}

sequence G = convert_graph(V, E)

G = initial_ranking(G)
? G[RANKING]

G = feasible_ranking(G)
? G[RANKING]

sequence R = G[RANKING]
for i = 0 to max(R) do
    printf(1, "Rank %d: ", i)
    sequence L = find_all(i, R)
    for j = 1 to length(L) do
        printf(1, "%s ", {V[L[j]]})
    end for
    printf(1, "\n")
end for
