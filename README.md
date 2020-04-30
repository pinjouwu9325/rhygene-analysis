# Identify rhythmic genes of datasets without time annotation

Last update: 2020-04-30

## Workflow

<p align="center">
  <img src="https://github.com/pinjouwu9325/rhygene-analysis/blob/master/workflow.png">
</p>

## Tools: CYCLOPS
CYCLOPS reveals human transcriptional rhythms Ron C. Anafi, Lauren J. Francey, John B. Hogenesch, Junhyong Kim Proceedings of the National Academy of Sciences May 2017, 114 (20) 5312-5317; DOI: 10.1073/pnas.1619320114

## Dataset: GTEx (version 8)
* **Dataset**: Each row represents a gene, and each column represents a sample. 
* The first row is the header **[1,:]**. 
* The second column is gene symbol **[:,2]** 
* The expression data strat from the fourth coulmn **[2:end, 4:end]**. 
* Here we used datasets of lung and brain BA9.

## Seed genes: Baboon genes cyclying in more than 20 tissues
Diurnal transcriptome atlas of a primate across major neural and peripheral tissues
BY LUDOVIC S. MURE, HIEP D. LE, GIORGIA BENEGIAMO, MAX W. CHANG, LUIS RIOS, NGALLA JILLANI, MAINA NGOTHO, THOMAS KARIUKI, OURIA DKHISSI-BENYAHYA, HOWARD M. COOPER, SATCHIDANANDA PANDA, SCIENCE16 MAR 2018

* **Seed gene list**: Choosing a good seed gene list is quite tricky. According to the suggestion from Dr. Anafi: The seed genes are supposed to reflect a "best guess" at the transcripts that will show circadian oscillations in the tissue being sorted. I do think using the seed list from the human data is a good way to go. 
* Seed gene list is a two dimentions array with all the seed genes stored at the secondary column **[2:end, 2]**. 
## Set parameter
* **Frac_Var**: Set Number of Dimensions of SVD to maintain this fraction of variance
* **DFrac_Var**: Set Number of Dimensions of SVD to so that incremetal fraction of variance of var is at least this much
* **N_trials**: Number of random initial conditions to try for each optimization
* **MaxSeeds**: For cutrank = number of probes(genes) - Maxseeds
* **total_background_num**: Number of background runs for global background refrence statistics
* **n_cores**: Number of machine cores

## Output
* Estimated phases table
* Cosinor statistics table
  1.  ""            
  2. "Description" (Gene Symbol)
  3. "Name"       (Gene ID)
  4. "pval"       
  5. "bon_pval"   
  6. "phase"      
  7. "amp"        
  8. "fitmean"    
  9. "mean"       
  10. "rsq"        
  11. "ptr"
