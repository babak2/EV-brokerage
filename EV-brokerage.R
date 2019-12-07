library(tidygraph)
library(igraph)
library(ggraph)

#==============================================================================================================================
# Function to calculate Everett and Valente (2016) brokerage scores for both undirected and directed graphs
# To report issues please contact: Babak Mahdavi Ardestani (bmahdaviardestani@medicine.bsd.uchicago.edu)
# Inputs/Parameters: 
#   g: a graph (of type igraph or tidygraph)
#   as.graph (optional): by default the result is returned as data frame; to have result as a graph, set as.graph to TRUE
#   all.values (optional): by default is FALSE; if TRUE it will include all the other calculated values in addition to EV brokerage scores
#   as.graph (optional): by default, the result are returned as df; if TRUE, the output will be returned as a graph 
# Output/Returns: 
#   the score as df (by default) or as a graph if as.graph is set to TRUE
#   if the original grpah has original IDs (names), results will include the original IDs (names)
# Examples:
#    g <- readRDS("granovetter_graph.RDS") #figure 1 in Everett & Valente (2016) article, udirected graph
#    g <- readRDS("campnet_graph.RDS")     #figure 2 in Everett & Valente (2016) article,  direxted graph
#    res.df <- ev_brokerage(g)
#    res.g  <- ev_brokerage(g, as.graph=TRUE)
#    res.df  <- ev_brokerage(g, all.values=TRUE) #includes other calculated values in addition to EV brokerage scores 
#================================================================================================================================
ev_brokerage <- function(g, as.graph= FALSE, all.values=FALSE){
  
  if_else <- dplyr::if_else
  
  if(!is(g, "tbl_graph"))
    g <- as_tbl_graph(g)  
  
  if (is_directed(g)) {
    
    res <- g %>%
      activate(nodes) %>%
      
      mutate(betweenness = centrality_betweenness(),  #1) Calculate standard directed betweeneess of vertices
             in_degree = centrality_degree(mode = "in"),
             out_degree = centrality_degree(mode = "out"),
             in_reachable = local_size(order = graph_order(), mode = "in") - 1,
             out_reachable = local_size(order = graph_order(), mode = "out") - 1) %>%
      
      mutate(ev_in = if_else(betweenness != 0, betweenness + in_reachable, betweenness),   #2a) if betweeness is non-zero add j to it, where j is the number of vertices that can reach vertex
             ev_in = if_else(ev_in != 0, ev_in / in_degree, ev_in),   #3a) Divide each non-zero sum by the in-degree of vertex
             ev_out = if_else(betweenness != 0, betweenness + out_reachable, betweenness), #2b) if betweenness is non-zero add k to it, where k is the number of vertices that vertex can reach
             ev_out = if_else(ev_out != 0, ev_out / out_degree, ev_out),  #3a) Divide each non-zero sum by the out-degree of vertex
             ev_scores = (ev_in + ev_out) / 2) 

    if (vertex_attr_names(res)[1] == "name") 
      res <- select(res, name, ev_scores, ev_in, ev_out, in_degree, out_degree, in_reachable, out_reachable, betweenness) 
    else 
      res <- select(res, ev_scores, ev_in, ev_out, in_degree, out_degree, in_reachable, out_reachable, betweenness) 
    
    if (all.values==FALSE) 
        res <- select(res, ev_scores) 
      
    if (as.graph==FALSE)
      res <-as_tibble(res)
    
    return (res)
  }
  else { 
    
    res <- g %>% 
      mutate(is_pendant = centrality_degree() == 1,                    
             betweenness = centrality_betweenness()) %>%                #1) Calculate standard vertex betweeneess
      
      mutate(ev_step2 = if_else(is_pendant,                               
                                betweenness * 2,                        # 2) Double each score (betweenness) 
                                betweenness * 2 + (graph_order() - 1)), # AND add n − 1 to every non-pendant entry
             ev_scores = if_else(ev_step2 == 0,                   
                                    ev_step2,                        
                                    ev_step2 / centrality_degree())    #3) Divide each non-zero score by vertex degree
      ) 
    if (vertex_attr_names(res)[1] == "name") {
      res <- select(res, name, ev_scores, betweenness, is_pendant) 
      
      if (all.values==TRUE) 
        res <- select(res, name, ev_scores, betweenness) 
      else 
        res <- select(res, name, ev_scores) 
    }
    else {
      res <- select(res, ev_scores, betweenness, is_pendant) 
      
      if (all.values==TRUE) 
        res <- select(res, ev_scores, betweenness) 
      else
        res <- select(res, ev_scores) 
    }
  }
  
  if (as.graph==FALSE)
    res <-as_tibble(res)
  
  return (res)
}




