
% Get the Graph structure:
graph = read_gml('sample.gml');

% Show the Graph structure:
show_graph = graph
show_nodes = graph.node
show_node2 = graph.node(2)
show_edges = graph.edge

% Change example edge value
graph.edge(3).value = 9;

% Adjacency Matrix: row: Source, column: Target
A = get_adjacency_matrix(graph)

