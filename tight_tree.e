include internal.e
include std/search.e
include std/math.e

--
-- Given a graph and a node, find the tight tree with node
-- as first search node.  Do not consider edge direction.
-- Tight tree has all edges with edge length 1.
--
global function tight_tree(object G, integer v)
    object R = G[RANKING]

    if not sequence(R) then
        printf(2, "Ranking must be computed using initial_ranking() ")
        printf(2, "before using tight_tree()")
        printf(2, "\n")
        abort(1)
    end if

    --
    -- Depth first search with duplicate removal.
    --
    sequence open_nodes = {v}
    sequence closed_nodes = {}
    sequence V = {v}
    sequence E = {}
    while not equal(open_nodes, {}) do
        v = open_nodes[1]
        open_nodes = tail(open_nodes)
        closed_nodes = append(closed_nodes, v)
        sequence in_out_nodes = G[IN_NODES][v] & G[OUT_NODES][v]
        for i = 1 to length(in_out_nodes) do
            integer v2 = in_out_nodes[i]
            --
            -- Duplicate check and length check
            --
            if find(v2, closed_nodes) > 0 then
                continue
            end if
          
            if edge_length(G, {v, v2}) = 1 then
                --
                -- New tight edge found
                --
                E = append(E, {v, v2})
		--
		-- Add to V only if not already there
		-- in case of multiple sources, one sink.
		--
		if find(v2, V) = 0 then
                    V = append(V, v2)
		end if
                open_nodes = prepend(open_nodes, v2)
            end if
        end for
    end while

    return new_graph(V, E)
end function


global function tight_tree_internal(integer v, object G)
--
-- Useful for "apply" to use this function
--
    return tight_tree(G, v)
end function


global function maximal_tight_tree(object G)
--
-- Return the maximal tight tree
--
    object R = G[RANKING]
    if not sequence(R) then
        printf(2, "Ranking must be computed using initial_ranking() ")
        printf(2, "before using maximal_tight_tree()")
        printf(2, "\n")
        abort(1)
    end if

    --
    -- Find all the root nodes, i.e. all nodes with minimum rank.
    --
    sequence roots = find_all(minimum_ranking(G), R)
    integer current_size = 0
    object  T, maxT = 0

    for i = 1 to length(roots) do
        T = tight_tree(G, roots[i])
-- printf(1, "DEBUG Tight tree %d (%d): ", {i, length(T[NODES])})
-- ?T[NODES]
        if T[GRAPH_SIZE] = G[GRAPH_SIZE] then
            return T
        end if

        if T[GRAPH_SIZE] > current_size then
            current_size = T[GRAPH_SIZE]
            maxT = T
        end if
    end for

    return maxT 
end function
