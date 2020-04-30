library("tidyverse")

# Load GTEx and CYCLOPS outputs
gtex = read.csv("./GTEx_v8_attributes.csv", row.names = 1)
lung = read.csv("./GTEx_estimatedPhase_lung.csv") %>%
  rename(Estimated_Phase_Lung = Estimated_Phase)
ba9 = read.csv("./GTEx_estimatedPhase_ba9.csv") %>%
  rename(Estimated_Phase_BA9 = Estimated_Phase)

# Join
lung_full = right_join(filter(gtex, SMTSD == "Lung"), lung, by="SAMPID")
ba9_full = right_join(filter(gtex, SMTSD == "Brain - Frontal Cortex (BA9)"), ba9, by="SAMPID")

lung_sub = select(lung_full, c("SUBJID", "SAMPID", "TOD.CT.", "Estimated_Phase_Lung"))
ba9_sub = select(ba9_full, c("SUBJID", "SAMPID", "TOD.CT.", "Estimated_Phase_BA9"))

full = full_join(lung_sub, ba9_sub, by = "SUBJID")
inner = inner_join(lung_sub, ba9_sub, by = "SUBJID") %>%
  filter(!is.na(TOD.CT..x)) %>%
  select(-c("SAMPID.y", "TOD.CT..y")) %>%
  rename(SAMPID = SAMPID.x, TOD.CT.=TOD.CT..x)

write.csv(inner, file = "CYCLOPS_TOD.csv", fileEncoding = "utf-8", row.names = FALSE)