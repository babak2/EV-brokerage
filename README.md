# EV Brokerage 

Using betweenness centrality as an underpinning concept, *Everett and Valente (2016)* propose a new brokerage measure and explore its relationship to classic betweenness.

This package contains simple R code for calculating *Everett and Valente (2016)* brokerage scores for both undirected and directed graphs.

For more information about the brokerage measure, see:

**Everett MG, Valente TW.** *Bridging, brokerage, and betweenness.* Social Networks. 2016; 44:202-208. DOI: [10.1016/j.socnet.2015.09.001](https://doi.org/10.1016/j.socnet.2015.09.001)

[Link to the article](https://www.sciencedirect.com/science/article/abs/pii/S0378873315000763)

## Installation

Clone the repository to your local machine:

`git clone https://github.com/babak2/EV-brokerage.git`

or if you have the program as a ZIP file, simply extract the zip file to a directory of your choice.

Change your working directory to EV-brokerage:

`cd EV-brokerage`

## Program Requirements

R or RStudio with the following libraries installed: 
`tidygraph`, `igraph`, `ggraph`


# Usage

Open EV-brokerage.R in R or RStudio


## Inputs/Parameters: 

g: a graph (of type igraph or tidygraph)

as.graph (optional): by default the result is returned as data frame; to have result as a graph, set as.graph to TRUE

all.values (optional): by default is FALSE; if TRUE it will include all the other calculated values in addition to EV brokerage scores

as.graph (optional): by default, the result are returned as df; if TRUE, the output will be returned as a graph 

## Output/Returns: 

the score as df (by default) or as a graph if *as.graph* is set to TRUE

if the original grpah has original IDs (names), results will include the original IDs (names)

## Provided RDS data: 

`granovetter_graph.RDS`: This dataset contains the undirected graph of the Granovetter hypothetical network as shown in Figure 1 of Everett & Valente (2016) article

![Granovetter](./images/granovetter.png)

`campnet_graph.RDS`: This dataset contains the directed graph of the Campnet hypothetical network as shown in Figure 3 of Everett & Valente (2016) article.

![Campnet](./images/campnet.png)

## Examples:

g <- readRDS("granovetter_graph.RDS") 

g <- readRDS("campnet_graph.RDS")     

res.df <- ev_brokerage(g)

to have the result as graph: 
res.g  <- ev_brokerage(g, as.graph=TRUE)

use all.values=TRUE to include other calulated values in addition to EV brokerage scores:
res.df  <- ev_brokerage(g, all.values=TRUE) 


## License

This is licensed under the GNU GENERAL PUBLIC LICENSE. See LICENSE for more information.


## Author 

Babak Mahdavi Ardestani

babak.m.ardestani@gmail.com