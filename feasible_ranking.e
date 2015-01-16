include initial_ranking.e
include tight_tree.e
include std/math.e


--
-- Feasible ranking first uses initial ranking to assign ranks and then
-- uses maximal_tight_tree to keep adjusting the lengthy edges
-- that can be shrunk in size.
--
global function feasible_ranking(object G)
    G = initial_ranking(G)
    --printf(1, "DEBUG Initial Ranking: ") ?G[RANKING]
    while 1 do
        object T = maximal_tight_tree(G)
        --printf(1,"DEBUG NODES ") ?T[NODES]
        if T[GRAPH_SIZE] = G[GRAPH_SIZE] then
            exit
        end if

        sequence e = minimum_non_tree_edge(G, T)
	--printf(1, "DEBUG Non-Tree Edge: ") ?e
        integer delta = edge_slack(G, e)

        --
        -- Negate delta if e is an out edge from T
        --
        if not find(e, G[EDGES]) then
            delta = -delta
        end if

        for i = 1 to length(T[NODES]) do
            G[RANKING][T[NODES][i]] -= delta
        end for

        --printf(1,"DEBUG Adjusted Ranking ") ?G[RANKING]
    end while

    return normalize_ranking(G)
end function


    function normalize_ranking(object G)
        integer offset = minimum_ranking(G)
        for i = 1 to G[GRAPH_SIZE] do
            G[RANKING][i] -= offset
        end for
        return G
    end function


    function non_tree_edges(object G, object T)
        sequence edges = {}

        for i = 1 to length(T[NODES]) do
            integer v = T[NODES][i]
            --
            -- Find nodes in G that touches v but not in T
            --
            for j = 1 to length(G[IN_NODES][v]) do
                integer n = G[IN_NODES][v][j]
                if not find(n, T[NODES]) then
                    edges = append(edges, {n, v})
                end if
            end for
            for j = 1 to length(G[OUT_NODES][v]) do
                integer n = G[OUT_NODES][v][j]
                if not find(n, T[NODES]) then
                    edges = append(edges, {v, n})
                end if
            end for
        end for

        return edges
    end function


    function minimum_non_tree_edge(object G, object T)
        sequence edges = non_tree_edges(G, T)
        integer min_edge = 1
        for i = 2 to length(edges) do
            if edge_slack(G, edges[i]) < edge_slack(G, edges[min_edge]) then
                min_edge = i
            end if
        end for

        return edges[min_edge]
    end function

