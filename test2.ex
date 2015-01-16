include initial_ranking.e
include tight_tree.e
include feasible_ranking.e
include std/sequence.e

sequence V = {
   1, 2, 3, 4, 5, 6, 7, 8
}

sequence E = {
    {1, 2},
    {2, 3},
    {3, 4},
    {4, 5},
    {6, 7},
    {7, 4},
    {8, 5}
}

sequence G = new_graph(V, E)

G = initial_ranking(G)
? G[RANKING]

G = feasible_ranking(G)
? G[RANKING]
