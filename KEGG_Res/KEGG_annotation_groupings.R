library(tidyverse)
library(viridis)
library(ggpubr)
library(ggfortify)
library(ggrepel)
setwd("C:/Users/julia/OneDrive - Michigan State University/Documents/MSU/Bonito Lab/MRE_genomes/KEGG_Res/")
br_annot_data <- read.csv("brite_combined_counts.csv")
br_annot_data$Br_name <- as.character(br_annot_data$Br_name)
br_annot_data$Br_name[br_annot_data$Br_name =="Brite Hierarchies"] <- "Not Included in Pathway"

br_annot_data$Br_name <- factor(br_annot_data$Br_name)
br_annot_data$Species %>%
  fct_recode(LinGam_AM1032 = "MorGam_AM1032_MRE",
             MorAlp_AD073 = "MorAlp_AD073_MRE",
             JimFla_AD002 = "Jflam_AD002",
             JimLac_OSC162217 = "Jlac_OSC162217",
             Benniella_AD185 = "MortAD185_MRE",
             BenEri_GBAus27b = "GBAus27b-MRE") -> br_annot_data$Species

#br_lev1 <- br_annot_data %>% filter(Level == 1)
lev1_plot <- br_annot_data %>% filter(Level == 1) %>%
ggplot(aes(fill=Br_name, y=Count, x=Species)) +
  geom_bar(position = "fill", stat="identity") +
  coord_flip() +
  scale_fill_viridis(discrete = T) +
  labs(y = "Gene Proportion", fill = "KEGG BRITE Name", title = "Level 1")
lev1_plot
ggsave("Level1_BRITE_barplot.png", lev1_plot, width=10, height = 6, units="in")

lev2_plot <- br_annot_data %>% filter(Level == 2) %>%
ggplot(aes(fill=Br_name, y=Count, x=Species)) +
  geom_bar(position = "fill", stat="identity") +
  coord_flip() +
  scale_fill_viridis(discrete = T) +
  theme(text = element_text(size = 12),
        legend.key.size = unit(.5, "line"),
        legend.spacing = unit(0, "pt")) +
  guides(fill=guide_legend(ncol=1)) +
  labs(y = "Gene Proportion", fill = "KEGG BRITE Name", title = "Level 2")
lev2_plot
ggsave("Level2_BRITE_barplot.png", lev2_plot, width=10, height = 6, units="in")

br_lev1 <- br_annot_data %>% filter(Level == 1)

br_lev1_prop <- br_lev1
for (i in unique(br_lev1$Species)){
  sub_dat <- br_lev1 %>% filter(Species == i)
  props <- sub_dat$Count / sum(sub_dat$Count)
  br_lev1_prop$Count[br_lev1_prop$Species == i] <- props
}
br_lev1_prop

sizes <- read.csv("sizes.csv")
sizes$Species %>%
  fct_recode(LinGam_AM1032 = "MorGam_AM1032_MRE",
             MorAlp_AD073 = "MorAlp_AD073_MRE",
             JimFla_AD002 = "Jflam_AD002",
             JimLac_OSC162217 = "Jlac_OSC162217",
             Benniella_AD185 = "MortAD185_MRE",
             BenEri_GBAus27b = "GBAus27b-MRE") -> sizes$Species

sizes %>% arrange(Species) -> sizes

br_lev1_prop %>% arrange(Species) -> br_lev1_prop
GIP <- br_lev1_prop %>% filter(Br_name == "Genetic Information Processing") 
Met <- br_lev1_prop %>% filter(Br_name == "Metabolism")
EIP <- br_lev1_prop %>% filter(Br_name == "Environmental Information Processing")
HD <- br_lev1_prop %>% filter(Br_name == "Human Diseases")
NIP <- br_lev1_prop %>% filter(Br_name == "Not Included in Pathway")
NIPB <- br_lev1_prop %>% filter(Br_name == "Not Included in Pathway or Brite")

sizes$GIP_prop <- GIP$Count
sizes$Met_prop <- Met$Count
sizes$HD_prop <- HD$Count
sizes$NIP_prop <- NIP$Count
sizes$NIPB_prop <- NIPB$Count

plot(GIP_prop ~ Size, sizes)
model <- lm(GIP_prop ~ Size, sizes)
summary(model)

GIP_plot <- ggplot(sizes, aes(x=Size, y=GIP_prop)) +
  geom_point()
GIP_plot
ggsave("Gen_info_proc_prop_vs_size.png", GIP_plot)

plot(Met_prop ~ Size, sizes)
model <- lm(Met_prop ~ Size, sizes)
summary(model)

plot(NIP_prop ~ Size, sizes)
plot(NIPB_prop ~ Size, sizes)
model <- lm(NIPB_prop ~ Size, sizes)
summary(model)

### PFAM_GO_terms

go_counts <- read.delim("../Pfam_res/go_by_species.tsv")

go_counts$Species %>%
  fct_recode(LinGam_AM1032 = "MorGam_AM1032_MRE",
             MorAlp_AD073 = "MorAlp_AD073_MRE_prot",
             JimFla_AD002 = "Jflam_AD002",
             JimLac_OSC162217 = "Jlac_OSC162217",
             Benniella_AD185 = "MortAD185_MRE_genomic",
             BenEri_GBAus27b = "GBAus27b-MRE-ap",
             GvMRE = "GvMRE_prot",
             DhMRE = "DhMREa_prot",
             Mycoplasmataceae_CE_OT135= "Mycoplasmataceae_CE_OT135_prot",
             Mycoplasmataceae_RC_NB112A = "Mycoplasmataceae_RC_NB112A_prot",
             Mycoplasmataceae_RV_VA103A = "Mycoplasmataceae_RV_VA103A_prot") -> go_counts$Species

go_counts %>%
  group_by(GO_description) %>%
  summarize(total = sum(Count)) -> sum_go_counts
sum_go_counts %>%
  filter(total > 29)-> filt_tot_30
filt_tot_30
go_counts %>%
  filter(GO_description %in% filt_tot_30$GO_description) %>%
  left_join(filt_tot_30, by = "GO_description") %>%
  arrange(-total) -> GO_30_plus
GO_30_plus %>%  
  ggplot(aes(x = reorder(GO_description, total),
             y = Count,
             fill = Species)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_viridis_d() +
  coord_flip() +
  labs(x = "Gene Ontology Description",
       fill = "Isolate",
       y = "Count in Genome") +
  theme(legend.position = c(0.7, 0.4),
        text = element_text(size=12))-> stacked_go_tot
stacked_go_tot

ggsave("../Pfam_res/stacked_go_total.png", stacked_go_tot, units = "in", height = 8, width = 10)

sum_go_counts %>%
  filter(total > 49)-> filt_tot_50
filt_tot_50
go_counts %>%
  filter(GO_description %in% filt_tot_50$GO_description) %>%
  left_join(filt_tot_50, by = "GO_description") %>%
  arrange(-total) -> GO_50_plus
GO_50_plus
GO_50_plus %>%
  ggplot(aes(fill = GO_description,
             y = Count,
             x = Species)) +
  geom_bar(position="fill", stat="identity") +
  scale_fill_viridis_d() +
  coord_flip() +
  labs(fill = "Gene Ontology Description",
       x = "Isolate",
       y = "Count in Genome") +
  guides(fill=guide_legend(ncol=1)) +
  theme(legend.position = "right",
        text = element_text(size=12),
        legend.key.size = unit(.5, "line"),
        legend.spacing = unit(0, "pt"))-> stacked_go_prop
stacked_go_prop
ggsave("../Pfam_res/stacked_go_prop.png", stacked_go_prop, units = "in", height = 8, width = 10)

go_counts %>%
  pivot_wider(names_from = GO_term,
              values_from = Count,
              id_cols = Species) -> go_wide
br_annot_data %>%
  pivot_wider(names_from = Brite,
              values_from = Count,
              id_cols = Species) -> br_wide
left_join(go_wide, br_wide, by = "Species") -> comb_wide
rownames(comb_wide) <- comb_wide$Species
comb_wide <- dplyr::select(comb_wide, -Species) %>%
  mutate(across(everything(),
                replace_na, 0))
pca_comb <- prcomp(comb_wide)
pca_comb$rotation[1,]

autoplot(pca_comb, data=as.data.frame(go_wide[,1]), label = T)

pca_data_w_sp <- data.frame(PC1 = pca_comb$x[,1],
                            PC2 = pca_comb$x[,2],
                            Species = go_wide$Species)
ggplot(pca_data_w_sp, aes(x = PC1, y = PC2, label = Species)) +
  geom_point() +
  geom_text_repel()

pca_data_w_sp
pca_comb$x[,1]
