--
-- Convert graph input parameters to internal format for faster processing.
--

include std/sequence.e
include std/math.e

--
-- The graph works with numeric nodes only for convenience.
-- The user can easily make an index for their nodes and pass
-- in only numeric values.  A utility function to do so will 
-- be given below, see convert_graph.
-- 
-- Notice the numeric nodes do not need to be consecutive.
-- For example it is possible to pass in the following as
-- nodes:
--
-- {1, 3, 5, 7, 9}
--
-- This will be useful for internal algorithms that split an
-- initial tree into forests for example.
--
global enum
    NODES,
    EDGES,
    GRAPH_SIZE,
    IN_NODES,
    OUT_NODES,
    RANKING,
    GRAPH_N


    function edge_map(sequence edge, sequence V)
        return {find(edge[1], V), find(edge[2], V)}
    end function


    function node_map(object node, sequence V)
        return find(node, V)
    end function


/*
    procedure print_nodes(integer f, sequence N, sequence V)
    --
    -- N is in list of integer form.  Map from V then print
    --
        sequence s = extract(V, N)
        for i = 1 to length(s) do
            printf(f, "%s ", s[i])
        end for
        printf(f, "\n")
    end procedure
*/

--
-- Given V = { "A", "B", "C", ... }     -- convert to { 1, 2, 3 }
--
--       E = { {"A", "B"},              -- convert to numeric as well
--             {"B", "C"},
--             {"A", "C"}, ... }
--
-- Return 
--
--     A graph object
--
global function convert_graph(sequence V, sequence E)
    --
    -- First normalize E to use integers
    --
    integer graph_size = length(V)
    sequence numericV = series(1, 1, graph_size)
    sequence numericE = apply(E, routine_id("edge_map"), V)

    sequence G = repeat(0, GRAPH_N-1)
    G[NODES] = numericV
    G[EDGES] = numericE
    G[GRAPH_SIZE] = graph_size

    return G
end function


global function new_graph(sequence V, sequence E)
    --
    -- V and E already in integers (otherwise use the
    -- convert graph function)
    integer graph_size = length(V)
    sequence G = repeat(0, GRAPH_N-1)
    G[NODES] = V
    G[EDGES] = E
    G[GRAPH_SIZE] = length(V)

    return G
end function


--
-- For convenience compute in-nodes and out-nodes for 
-- each node in the graph.
--
-- This is the format of the in and out node info.
--
--      IN_NODES = { {},      -- Node1 has no in-edges
--                   {1},     -- Node2 has node 1 as an in-edge
--                   {1, 2},  -- Node3 has nodes 1 and 2 as in-edges
--                   ... }
--
--     OUT_NODES = { {1, 3},  -- Same concept as above but for out-edges
--                   {3},
--                   {},
--                   ... }
--
global function compute_in_out_nodes(object G)
    sequence V = G[NODES]
    sequence E = G[EDGES]
    integer max_size = max(V)
    sequence in_result = repeat({}, max_size)
    sequence out_result = repeat({}, max_size)

    for i = 1 to G[GRAPH_SIZE] do
        sequence in_nodes = {}
        sequence out_nodes = {}
        integer current_node = V[i]
        for j = 1 to length(E) do
            if current_node = E[j][2] then
                in_nodes = append(in_nodes, E[j][1])
            end if
            if current_node = E[j][1] then
                out_nodes = append(out_nodes, E[j][2])
            end if
        end for
        in_result[current_node] = in_nodes
        out_result[current_node] = out_nodes
    end for

    G[IN_NODES] = in_result
    G[OUT_NODES] = out_result

    return G
end function


--
-- Edge length.  
-- Must compute ranking before using this.
--
global function edge_length(object G, sequence edge)
    object R = G[RANKING]

    if not sequence(R) then
        printf(2, "Ranking must be computed using initial_ranking() ")
        printf(2, "before using edge_length()")
        printf(2, "\n")
        abort(1)
    end if

    --
    -- Edge length is simply rank(edge head) - rank(edge tail)
    --
    return abs(R[edge[2]] - R[edge[1]])
end function


--
-- For simple case where edge weights are not considered,
-- edge slack is edge length - 1
--
global function edge_slack(object G, sequence edge)
    return edge_length(G, edge) - 1
end function
