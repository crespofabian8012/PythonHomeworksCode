import os
import random
import numpy as np
from ete2 import Tree
#import pylab
#from Bio import Phylo
from Bio import Phylo
from Bio.Phylo.Consensus import *
from numpy import matrix
from numpy import linalg
from numpy import linalg as LA
from nexus import NexusReader
#from TreeConstruction import *

import pandas as pnd
#from dendropy.datamodel.treecollectionmodel import TreeList


def MetodoCluster():
    import dendropy
    from dendropy.calculate import treecompare
    import math
    import collections
    import csv
    from dendropy.calculate import statistics
    from dendropy.utility import GLOBAL_RNG
    from dendropy.utility import container
    from dendropy.utility import error
    with open("/Users/patricioburchard/Downloads/Cercosaura_Final.nex") as src:
        pdm = dendropy.PhylogeneticDistanceMatrix.from_csv(src, is_first_row_column_names=True,is_first_column_row_names=True, is_allow_new_taxa=True,delimiter=",",)

    # Calculate the tree
    upgma_tree = pdm.upgma_tree()

    # Print it
    print(upgma_tree.as_string("nexus"))
    return 0


#listar todos los archivos de .p de un directorio
path = '/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/'

# Lista vacia para incluir los ficheros
lstFiles = []
lstDir = os.walk(path)

for root, dirs, files in lstDir:
    for fichero in files:
        (nombreFichero, extension) = os.path.splitext(fichero)
        if (extension == ".p"):
            lstFiles.append(nombreFichero + extension)
            # print (nombreFichero+extension)

print(lstFiles)
print len(lstFiles)


#abrir archivo de cada particion
infile = open('/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part1.nex.run1.p', 'r')
print(infile.readline())
data = infile.read().strip()
M = [[num for num in line.strip().split()] for line in data.split('\n')]
print M
print zip(M)
infile.close()


rAC= [item[4] for item in M]
rAG= [item[5] for item in M]
rAT= [item[6] for item in M]
rCG= [item[7] for item in M]
rCT= [item[8] for item in M]
rGT= [item[9] for item in M]
piA=[item[10] for item in M]
piC=[item[11] for item in M]
piG=[item[12] for item in M]
piT=[item[13] for item in M]
alpha=[item[14] for item in M]
print(rAC)
print(len(rAC))
#simulaciones

nsimulaciones=1000
for i in range(1,2):
#for i in range(1,nsimulaciones):
    samplerAC = float(random.choice(rAC[len(rAC)/2: len(rAC)]))

    samplerAG = float(random.choice(rAG[len(rAG) / 2: len(rAG)]))
    samplerAT= float(random.choice(rAT[len(rAT) / 2: len(rAT)]))
    samplerCG = float(random.choice(rCG[len(rCG) / 2: len(rCG)]))
    samplerCT = float(random.choice(rCT[len(rCT) / 2: len(rCT)]))
    samplerGT = float(random.choice(rGT[len(rGT) / 2: len(rGT)]))
    matrizQ=matrix( [[-(samplerAG +samplerAC+ samplerAT),samplerAG ,samplerAC, samplerAT],
                     [samplerAG,-(samplerAG +samplerCG+ samplerGT), samplerCG,samplerGT],
                     [samplerAC,samplerCG,-(samplerAC +samplerCG+ samplerCT), samplerCT ],
                     [samplerAT, samplerGT,  samplerCT,-(samplerGT +samplerCT+ samplerAT) ]
                     ])
    print("Q")
    print(matrizQ)
    w, v = LA.eig(matrizQ)
    print(w)
    print(v)
    print(np.diag(w))
    print(np.exp(np.diag(w)))
    print(np.diag(np.exp(w)))
    print(v.T.I )
    print("aqui")
    matrizP= v.T.I * np.diag(np.exp(w)) * v.T
    print(sum(matrizP[1,:]))
    print(matrizP)
    # t = Tree("((a,b),c);")

#print(samplerAC)
t = Tree("((A, B)Internal_1:0.7, (C, D)Internal_2:0.5)root:1.3;", format=1)
t.add_features(size=4)
print t.get_ascii(attributes=["name", "dist", "size"])


#tree = Phylo.parse("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part1.nex.con.tre", "nexus").next()
#tree = Phylo.read("/Users/patricioburchard/Downloads/Cercosaura_FinalPAUP.tre", "nexus")
#tree.rooted = True
#Phylo.draw(tree)
#infile = open('/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part1.nex.run1.p', 'r')
#t.show()
n = NexusReader('/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part1.nex.con.tre')
n.read_file('/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part1.nex.con.tre')

print(n.blocks)
#print(sorted(n.data.taxa))
#print(n.trees.ntrees[0])
for tree in n.trees:
    print(tree)
    #tree1 = dendropy.Tree.get_from_string(tree,"nexus")
import dendropy
#from dendropy import Tree
#from dendropy import TreeList
x = dendropy.Tree()
tree_list1 = dendropy.TreeList()
tree_list1.read_from_path("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part1.nex.con.tre",  schema="nexus")
# tree1 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part1.nex.con.tre", "r"), schema="nexus")
# tree2 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part2.nex.con.tre", "r"), schema="nexus")
# tree3 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part3.nex.con.tre", "r"), schema="nexus")
# tree4 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part4.nex.con.tre", "r"), schema="nexus")
# tree5 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part5.nex.con.tre", "r"), schema="nexus")
# tree6 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part8.nex.con.tre", "r"), schema="nexus")
# tree7 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part9.nex.con.tre", "r"), schema="nexus")
# tree8 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part11.nex.con.tre", "r"), schema="nexus")
# tree9 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part13.nex.con.tre", "r"), schema="nexus")
# tree10 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part14.nex.con.tre", "r"), schema="nexus")
# tree11 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part15.nex.con.tre", "r"), schema="nexus")

tree1 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part1.nex.trprobs", "r"), schema="nexus")
tree2 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part2.nex.trprobs", "r"), schema="nexus")
tree3 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part3.nex.trprobs", "r"), schema="nexus")
tree4 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part4.nex.trprobs", "r"), schema="nexus")
tree5 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part5.nex.trprobs", "r"), schema="nexus")
tree6 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part8.nex.trprobs", "r"), schema="nexus")
tree7 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part9.nex.trprobs", "r"), schema="nexus")
tree8 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part11.nex.trprobs", "r"), schema="nexus")
tree9 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part13.nex.trprobs", "r"), schema="nexus")
tree10 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part14.nex.trprobs", "r"), schema="nexus")
tree11 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part15.nex.trprobs", "r"), schema="nexus")

treeLis1 = dendropy.TreeList()
treeLis2 = dendropy.TreeList()
treeLis3 = dendropy.TreeList()
treeLis4 = dendropy.TreeList()
treeLis5 = dendropy.TreeList()
treeLis6 = dendropy.TreeList()
treeLis7 = dendropy.TreeList()
treeLis8 = dendropy.TreeList()
treeLis9 = dendropy.TreeList()
treeLis10 = dendropy.TreeList()
treeLis11 = dendropy.TreeList()
treeLis1.read(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part1.nex.trprobs", "r"), schema="nexus")
treeLis2.read(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part2.nex.trprobs", "r"), schema="nexus")
treeLis3.read(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part3.nex.trprobs", "r"), schema="nexus")
treeLis4.read(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part4.nex.trprobs", "r"), schema="nexus")
treeLis5.read(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part5.nex.trprobs", "r"), schema="nexus")
treeLis6.read(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part8.nex.trprobs", "r"), schema="nexus")
treeLis7.read(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part9.nex.trprobs", "r"), schema="nexus")
treeLis8.read(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part11.nex.trprobs", "r"), schema="nexus")
treeLis9.read(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part13.nex.trprobs", "r"), schema="nexus")
treeLis10.read(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part14.nex.trprobs", "r"), schema="nexus")
treeLis11.read(file=open("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part15.nex.trprobs", "r"), schema="nexus")
print(len(treeLis1))



#x.read_from_path("/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part1.nex.con.tre", "nexus")
#print(x.as_ascii_plot())
#Phylo.convert('/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part1.nex.con.tre', 'nexus','/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part1.nex.con.nhk', 'newick')
#tree = Phylo.parse(n.trees.ntrees[0], 'phyloxml')
#print(tree)
#tree1=Phylo.parse('/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part1.nex.con.tre', 'nexus')

#tree2=Phylo.parse('/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part2.nex.con.tre', 'nexus')


#########
# tree_str = "[&R] (A, (B, (C, (D, E))));"
# tree = dendropy.Tree.get_from_string(
# tree_str,
# "newick")
# print("Original:")
# print(tree.as_ascii_plot())
# tree.is_rooted = False
# print("After `is_rooted=False`:")
# print(tree.as_ascii_plot())
# tree.update_bipartitions()
# print("After `update_bipartitions()`:")
# print(tree.as_ascii_plot())
# tree2 = dendropy.Tree.get_from_string(
# tree_str,
# "newick")
# tree2.is_rooted = False
# tree2.update_bipartitions(suppress_unifurcations=False)
# print("After `update_bipartitions(suppress_unifurcations=False)`:")
# print(tree2.as_ascii_plot())

###tree3=Phylo.parse('/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part3.nex.con.tre', 'nexus')

##tree4=Phylo.parse('/Users/patricioburchard/Downloads/Particiones_grupos_de_especies/part4.nex.con.tre', 'nexus')

#trees=tree1,tree2,tree3,tree4,tree5,tree6,tree7,tree8,tree9,tree10,tree11


# from Bio import Phylo
# from Bio.Phylo.Consensus import *
# from Bio import AlignIO
# from Bio.Phylo.TreeConstruction import DistanceTreeConstructor
# msa = AlignIO.read('Tests/TreeConstruction/msa.phy', 'phylip')
# msas = bootstrap(msa, 100)
# from Bio.Phylo.TreeConstruction import DistanceCalculator
# calculator = DistanceCalculator('blosum62')
# constructor = DistanceTreeConstructor(calculator)
# trees = bootstrap_trees(msa, 100, constructor)
#
#
# consensus_tree = bootstrap_consensus(msa, 100, constructor, majority_consensus)
# strict_tree = strict_consensus(trees)
# adam_tree = adam_consensus(trees)
# majority_tree = majority_consensus(trees, 0.5)


trees = dendropy.TreeList()
trees.insert(1,tree1)
trees.insert(1,tree2)
trees.insert(1,tree3)
trees.insert(1,tree4)
trees.insert(1,tree5)
trees.insert(1,tree6)
trees.insert(1,tree7)
trees.insert(1,tree8)
trees.insert(1,tree9)
trees.insert(1,tree10)
trees.insert(1,tree11)

print("reconstruccion de arbol binario")
print(trees[0])
print(trees)


cadenaTrees =""
for tree in trees:
    tree.prune_taxa_with_labels(["Alopoglossus viridiceps"])
    print(tree.as_string('newick'))
    cadenaTrees= 'tree  '+ tree.as_string('newick')+'; '+'\n'+ cadenaTrees
    t = dendropy.Tree.get_from_string(tree.as_string('newick'), "newick")
    t.print_plot()
print(cadenaTrees)
con_tree = trees.consensus(min_freq=0)
print("aqui")
print(con_tree.as_string(schema='newick'))
pdm1= tree1.phylogenetic_distance_matrix()
print(pdm1)

#Phylo.draw(majority_tree)
con_tree.print_plot()


post_trees = dendropy.TreeList()
post_trees.read(file=open("/Users/patricioburchard/Downloads/afro-juju-l.u.st-f833b1f44215/L.U.St_Version2.0/fixtures/Drosophila.nex", "r"),schema="nexus")
#tree113 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/afro-juju-l.u.st-f833b1f44215/L.U.St_Version2.0/fixtures/Drosophila.nex", "r"), schema="nexus")

for tree in post_trees:

    print(tree.as_string('newick'))
    t = dendropy.Tree.get_from_string(tree.as_string('newick'), "newick")
    #t.print_plot()


tree145 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/afro-juju-l.u.st-f833b1f44215/L.U.St_Version2.0/Drosophila_ML_Result", "r"),
                            schema="newick")

#tree145.print_plot()
#tree145 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/afro-juju-l.u.st-f833b1f44215/L.U.St_Version2.0/Lagartijas_ML_Result2", "r"),
                # schema="newick")
#tree145 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/afro-juju-l.u.st-f833b1f44215/L.U.St_Version2.0/Lagartijas_ML_Result3", "r"),
                        #    schema="newick")

tree145 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/leomrtns-guenomu-117fc51f1fa4/species.tre", "r"),
                            schema="nexus")

con_tree = trees.consensus(min_freq=95)
tree145.print_plot()

tree145.as_ascii_plot()

tree345 = dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/StartingTreesNex.nex", "r"), schema="nexus")
tree345.print_plot()

#tree345.as_ascii_plot()
#print(tree345.as_string('newick'))
#StartingTreesNex.nex




#assert treecompare.weighted_robinson_foulds_distance(tree1, tree2) == 0.0
#assert treecompare.weighted_robinson_foulds_distance(tree2, tree3) == 0.0
#assert treecompare.weighted_robinson_foulds_distance(tree3, tree4) == 0.0

tree_str = "[&R] (((Nt_bicarinatus_MRT968462,Nt_rudis_MRT926008),(Pl_glabellum_LG940,Pl_cordylinum_LG1006)), ((C_oshaughnessyi_QCAZ7048,C_oshaughnessyi_LSUMZH13584),(C_oshaughnessyi_QCAZ9537,C_oshaughnessyi_QCAZ10720)));"
tree = dendropy.Tree.get_from_string(tree_str, "newick")
print("Original:")
print(tree.as_ascii_plot())


tree2 =dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Cercosaura_Final.nex.con.tre", "r"), schema="nexus")

treeLis345 = dendropy.TreeList(taxon_namespace=tree2.taxon_namespace)
treeLis345.read(file=open("/Users/patricioburchard/Downloads/Cercosaura_Finalmb2.nex.trprobs", "r"), schema="nexus")
#tree2 =dendropy.Tree.get(file=open("/Users/patricioburchard/Downloads/Cercosaura_Final.nex.con.tre", "r"), schema="nexus")

print(len(treeLis345))
print(treeLis345.taxon_namespace)
print(len(treeLis345.taxon_namespace))
distanciasRF=[]
distanciasSimetricas=[]
distanciasEuclideanas=[]

distanciasMasonGamerKellog=[]
for tree in treeLis345:
    #print(len(tree.taxon_namespace))
    distanciasRF.append(dendropy.calculate.treecompare.weighted_robinson_foulds_distance(tree, tree2))
    distanciasSimetricas.append(dendropy.calculate.treecompare.symmetric_difference(tree, tree2))#unweighted robinson foulds
    distanciasEuclideanas.append(dendropy.calculate.treecompare.euclidean_distance(tree, tree2))
    #distanciasMasonGamerKellog.append(dendropy.calculate.treecompare.mason_gamer_kellogg_score(tree, tree2))
print(distanciasRF)
print(distanciasSimetricas)
print(distanciasEuclideanas)
print(reduce(lambda x, y: x + y, distanciasRF) / len(distanciasRF))
print(reduce(lambda x, y: x + y, distanciasSimetricas) / len(distanciasSimetricas))
print(reduce(lambda x, y: x + y, distanciasEuclideanas) / len(distanciasEuclideanas))
#print(reduce(lambda x, y: x + y, distanciasMasonGamerKellog) / len(distanciasMasonGamerKellog))

print(reduce(lambda x, y: x + y, distanciasEuclideanas) / len(distanciasEuclideanas))