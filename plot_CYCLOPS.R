library("tidyverse")
library("ggplot2")
library('VennDiagram')
library("scales")
library("cowplot")
library("wesanderson")

# Load dataset
df = read.csv("./CYCLOPS_TOD.csv")

pi_scales <- math_format(.x * pi, format = function(x) x / pi)

# Plot TOD and estimated phases
p_lung = ggplot(df, aes(x=TOD.CT., y=Estimated_Phase_Lung)) +
  geom_point() +
  theme_light(base_size = 24) +
  labs(x="TOD(CT)", y="CYCLOPS Estimated Phase", title = "Lung") +
  theme(plot.title = element_text(hjust = 0.5, size = 20), axis.title = element_text(size=16), axis.text = element_text(size = 12)) +
  scale_x_continuous(limits = c(0, 24), breaks = c(0, 6, 12, 18, 24)) +
  scale_y_continuous(labels = pi_scales, breaks = seq(pi/2, 2*pi, by = pi/2)) 
  
  

p_lung

p_ba9 =  ggplot(df, aes(x=TOD.CT., y=Estimated_Phase_BA9)) +
  geom_point() +
  theme_light(base_size = 24) +
  labs(x="TOD(CT)", y="CYCLOPS Estimated Phases", title = "Brodmann Area 9") +
  theme(plot.title = element_text(hjust = 0.5, size = 20), axis.title = element_text(size=16), axis.text = element_text(size = 12)) +
  scale_x_continuous(limits = c(0, 24), breaks = c(0, 6, 12, 18, 24)) +
  scale_y_continuous(labels = pi_scales, breaks = seq(pi/2, 2*pi, by = pi/2)) 
p_ba9

# Plot two estimated phases
p = ggplot(df, aes(x=Estimated_Phase_Lung, y=Estimated_Phase_BA9)) +
  geom_point() +
  theme_light(base_size = 24) +
  labs(x="Lung", y="Brodmann Area 9", title = "Subjects Estimated Phases") +
  theme(plot.title = element_text(hjust = 0.5, size = 16), axis.title = element_text(size=16), axis.text = element_text(size = 12)) +
  scale_x_continuous(labels = pi_scales, breaks = seq(pi/2, 2*pi, by = pi/2)) +
  scale_y_continuous(labels = pi_scales, breaks = seq(pi/2, 2*pi, by = pi/2)) 

p


# Load Cosinor results of CYCLOPS
lung = read.csv("Cosinor_Output_lung.csv") %>% select(-c(1))
ba9 = read.csv("Cosinor_Output_ba9.csv") %>% select(-c(1))
clock = read.csv("CircaGenes_baboon.csv")


lung_sig = lung %>%
  filter(bon_pval < 0.05, rsq > 0, ptr > 1.66)

ba9_sig = ba9 %>%
  filter(bon_pval < 0.05, rsq >0, ptr > 1.66)

# function Filter_Cosinor_Output(cosdata::Array{Any,2},pval,rsq,ptt) 
# significant_data=cosdata[append!([1],1 + findin(cosdata[2:end,5] .< pval,true)),:];
# phys_sig_data=significant_data[append!([1],1 + findin(significant_data[2:end,11] .> ptt,true)),:];
# strong_data=phys_sig_data[append!([1],1 + findin(phys_sig_data[2:end,10].> rsq,true)),:];
# strong_data
# end
# pval < 0.05
# rsq > 0
# ptr > 1.66

inner_sig = inner_join(lung_sig, ba9_sig, by="Description", suffix=c(".lung", ".ba9")) %>%
  select(-c(11)) #remove geneID of BA9 dataset

i = ggplot(inner_sig, aes(x=phase.lung, y=phase.ba9)) +
  geom_point(alpha=0.5) +
  geom_text(aes(label=if_else(abs(phase.lung - phase.ba9) < pi/16, Description, ""), hjust=0,vjust=0)) +
  theme_light(base_size = 24) +
  labs(x="Lung", y="Brodmann Area 9", title = "Rhythmic Genes Phases") +
  theme(plot.title = element_text(hjust = 0.5, size = 16), axis.title = element_text(size=16), axis.text = element_text(size = 12)) +
  scale_x_continuous(labels = pi_scales, breaks = seq(-pi, pi, by = pi/2)) +
  scale_y_continuous(labels = pi_scales, breaks = seq(-pi, pi, by = pi/2)) 
i

c = ggplot(inner_sig, aes(x=phase.lung, y=phase.ba9)) +
  geom_point(alpha=0.2) +
  geom_text(aes(label=if_else(Description %in% clock$x, Description, ""), hjust=0,vjust=0)) + #align to left bottom
  theme_light(base_size = 24) +
  labs(x="Lung", y="Brodmann Area 9", title = "Rhythmic Genes Phases") +
  theme(plot.title = element_text(hjust = 0.5, size = 16), axis.title = element_text(size=16), axis.text = element_text(size = 12)) +
  scale_x_continuous(labels = pi_scales, breaks = seq(-pi, pi, by = pi/2)) +
  scale_y_continuous(labels = pi_scales, breaks = seq(-pi, pi, by = pi/2)) +
  coord_cartesian(ylim = c(-pi, pi))
c

# cat two plots
cat = plot_grid(p_lung, p_ba9, p, c, align = 'vh', labels = c("A", "B", "C", "D"), label_size = 14)
# Save plot
png("EstimatedPhase_TOD.png", width = 2400, height = 2400, units = "px", pointsize = 12, bg = "white", res = 300)
print(cat)
dev.off()

