include internal.e
include std/sequence.e
include std/search.e
include std/math.e


    function count(sequence x, object dummy)
        return length(x)
    end function


    function mark_outgoing_edges(
        sequence markers, 
        integer v, 
        sequence out_nodes)
        --
        -- For each outgoing node of v deduct 1 from its
        -- corresponding marker 
        --
        object nodes = out_nodes[v]

        for i = 1 to length(nodes) do
            markers[nodes[i]] -= 1
        end for

        return markers
    end function


global function initial_ranking(object G)
--
-- Return a list of list of nodes in order of rank:
--
-- { 
--     {1 4},     -- Rank 0 nodes
--     {2 3 5},   -- Rank 1 nodes
--     ...
-- }
--
    --
    -- For convenience, preprocess edges to find for each
    -- node its incoming and outgoing nodes.
    --
    G = compute_in_out_nodes(G)

    sequence E = G[EDGES]
    sequence rank_list = {}

    --
    -- Initialization
    -- Need a data structure to mark in-edges for each node.
    -- Like so:
    --
    -- { 
    --    0,      -- # of in-edges for node1 
    --    1,      -- # of in-edges for node2
    --    3,      -- # of in-edges for node3
    --    ...
    -- }
    --
    sequence markers = apply(G[IN_NODES], routine_id("count"))

    --
    -- Main loop.  Continue until the markers list has no more 
    -- nodes that have zero in-edges.
    --
    sequence queue
    while find(0, markers) do
        --
        -- All nodes that have 0 in-edges now form the 
        -- next level in rank_list.
        --
        queue = find_all(0, markers)
        rank_list = append(rank_list, queue)

        --
        -- Then mark these nodes as used.
        --
        markers = find_replace(0, markers, -1)

        --
        -- Delete edges going out from these nodes by 
        -- reducing the marker counters
        --
        for i = 1 to length(queue) do
            markers = mark_outgoing_edges(markers, queue[i], G[OUT_NODES])
        end for
    end while
  
    G[RANKING] = assign_rank_to_nodes(G, rank_list)

    return G
end function


function assign_rank_to_nodes(object G, sequence R)
--
-- Given the ranking list return a list that has rankings 
-- in node position for easy retrieval given a node.
--
    sequence S = repeat(-999999999, max(G[NODES]))
    for i = 1 to length(R) do
        for j = 1 to length(R[i]) do
            S[R[i][j]] = i-1
        end for
    end for
    return S
end function


global function minimum_ranking(object G)
    return min(extract(G[RANKING], G[NODES]))
end function
