library(ggplot2)
library(dplyr)
library(png)
library(showtext)
font_add_google("Rock Salt")
showtext_auto()

simpsons_characters <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-02-04/simpsons_characters.csv')
simpsons_episodes <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-02-04/simpsons_episodes.csv')
simpsons_locations <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-02-04/simpsons_locations.csv')
simpsons_script_lines <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-02-04/simpsons_script_lines.csv')

# filter episodes to include 2010+
simpsons_episodes <- simpsons_episodes |> 
  dplyr::filter(original_air_year >= 2010)

# filter script lines to only include lines for these episodes
simpsons_script_lines <- simpsons_script_lines |> 
  dplyr::semi_join(simpsons_episodes, by = c("episode_id" = "id"))

simpsons_characters <- simpsons_characters%>%
  rename(character_id = "id")

homer <- readPNG("./2025-02-04/character_photos/homer.png") 
marge <- readPNG("./2025-02-04/character_photos/marge.png") 
bart <- readPNG("./2025-02-04/character_photos/bart.png") 
lisa <- readPNG("./2025-02-04/character_photos/lisa.png") 
moe <- readPNG("./2025-02-04/character_photos/moe.png") 
burns <- readPNG("./2025-02-04/character_photos/burns.png") 
skinner <- readPNG("./2025-02-04/character_photos/skinner.png") 
grampa <- readPNG("./2025-02-04/character_photos/grandpa.png") 
ned <- readPNG("./2025-02-04/character_photos/ned.png") 
milhouse <- readPNG("./2025-02-04/character_photos/milhouse.png") 

labels <- c("Homer Simpson" = "<img src='./2025-02-04/character_photos/homer.png' width='8'>",
            "Marge Simpson" = "<img src='./2025-02-04/character_photos/marge.png' width='8'>",
            "Bart Simpson" = "<img src='./2025-02-04/character_photos/bart.png' width='8'>", 
            "Lisa Simpson" = "<img src='./2025-02-04/character_photos/lisa.png' width='8'>",
            "Moe Szyslak" = "<img src='./2025-02-04/character_photos/moe.png' width='8'>",
            "C. Montgomery Burns" = "<img src='./2025-02-04/character_photos/burns.png' width='8'>",
            "Seymour Skinner" = "<img src='./2025-02-04/character_photos/skinner.png' width='8'>",
            "Grampa Simpson" = "<img src='./2025-02-04/character_photos/grandpa.png' width='8'>", 
            "Ned Flanders" = "<img src='./2025-02-04/character_photos/ned.png' width='8'>",
            "Milhouse Van Houten" = "<img src='./2025-02-04/character_photos/milhouse.png' width='8'>"
)

p <- simpsons_script_lines %>% 
  na.omit()%>%
  group_by(character_id) %>% 
  summarize(total_words = sum(word_count)) %>%
  ungroup()%>%
  mutate(pct_words = total_words/sum(total_words))%>%
  filter(pct_words>.0154) %>%
  merge(simpsons_characters, by="character_id")%>%
  #arrange(pct_words)
  #merge(photos, by="name")+
  ggplot(aes(x=reorder(name, pct_words), y=pct_words*100))+
  coord_flip()+
  geom_bar(stat="identity",aes(fill=name, alpha = .5))+
  # scale_fill_manual(values=c("#F14E28","#FED90F","black","#0B7CC0","#F05E2F",
  #                      "#DCCC9E","pink","light blue","pink","lavender"))+
  scale_fill_manual(values = c(rep("#FED90F",10)))+
  scale_x_discrete(labels = labels) +
  theme(axis.text.x = ggtext::element_markdown())+
  #geom_text(aes(label=paste0(format(round(pct_words*100,1), nsmall=1), "%"), y=pct_words*100+.005), color="black", size=3, hjust=0, family="Rock Salt")+
  geom_text(aes(label=paste0(format(round(pct_words*100,1), nsmall=1), "%"), y=pct_words*100+.75), color="black", size=3, vjust=.2, family="Rock Salt")+
  theme_classic(base_size=18)+
  theme(text=element_text(family="Rock Salt"),
        plot.title = element_text(size = 20),
        plot.subtitle = element_text(size = 15),
        axis.title.y = element_blank(),
        axis.title.x = element_text(size = 15, vjust=.5),
        legend.position = "none",
        axis.text.y = ggtext::element_markdown(angle = 30))+ ##change this if not swapping the coordinates
  labs(title='Which Simpsons characters speak the most?',
       y="% of total words spoken by all characters",
       subtitle='Top 10 speaking characters from 2010-2016',
       caption="GitHub: adcascone - Tidy Tuesday 2025 Week 5")
p
ggsave(plot=p, filename = "./2025-02-04/simpsons_speaking-2.png", width=4, height=3,dpi = 300)

## horizontal plot
# this sizing looks great on a phone! 

labels <- c("Homer Simpson" = "<img src='./2025-02-04/character_photos/homer.png' width='16'>",
            "Marge Simpson" = "<img src='./2025-02-04/character_photos/marge.png' width='16'>",
            "Bart Simpson" = "<img src='./2025-02-04/character_photos/bart.png' width='16'>", 
            "Lisa Simpson" = "<img src='./2025-02-04/character_photos/lisa.png' width='16'>",
            "Moe Szyslak" = "<img src='./2025-02-04/character_photos/moe.png' width='16'>",
            "C. Montgomery Burns" = "<img src='./2025-02-04/character_photos/burns.png' width='16'>",
            "Seymour Skinner" = "<img src='./2025-02-04/character_photos/skinner.png' width='16'>",
            "Grampa Simpson" = "<img src='./2025-02-04/character_photos/grandpa.png' width='16'>", 
            "Ned Flanders" = "<img src='./2025-02-04/character_photos/ned.png' width='16'>",
            "Milhouse Van Houten" = "<img src='./2025-02-04/character_photos/milhouse.png' width='16'>"
)

p <- simpsons_script_lines %>% 
  na.omit()%>%
  group_by(character_id) %>% 
  summarize(total_words = sum(word_count)) %>%
  ungroup()%>%
  mutate(pct_words = total_words/sum(total_words))%>%
  filter(pct_words>.0154) %>%
  merge(simpsons_characters, by="character_id")%>%
  #arrange(pct_words)
  #merge(photos, by="name")+
  ggplot(aes(x=reorder(name, -pct_words), y=pct_words*100))+
  #coord_flip()+
  geom_bar(stat="identity",aes(fill=name, alpha = .5))+
  # scale_fill_manual(values=c("#F14E28","#FED90F","black","#0B7CC0","#F05E2F",
  #                      "#DCCC9E","pink","light blue","pink","lavender"))+
  scale_fill_manual(values = c(rep("#FED90F",10)))+
  scale_x_discrete(labels = labels) +
  theme(axis.text.y = ggtext::element_markdown())+
  #geom_text(aes(label=paste0(format(round(pct_words*100,1), nsmall=1), "%"), y=pct_words*100+.005), color="black", size=3, hjust=0, family="Rock Salt")+
  geom_text(aes(label=paste0(format(round(pct_words*100,1), nsmall=1), "%"), y=pct_words*100+.75), color="black", size=5, vjust=.2, family="Rock Salt")+
  theme_classic(base_size=21)+
  theme(text=element_text(family="Rock Salt"),
        plot.title = element_text(size = 25),
        plot.subtitle = element_text(size = 20),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 20, vjust=.5),
        legend.position = "none",
        axis.text.x = ggtext::element_markdown())+ ##change this if not swapping the coordinates
  labs(title='Which Simpsons characters speak the most?',
       y="% of total words spoken \nby all characters",
       subtitle='Top 10 speaking characters from 2010-2016',
       caption="GitHub: adcascone - Tidy Tuesday 2025 Week 5")
p
ggsave(plot=p, filename = "./2025-02-04/simpsons_speaking-2-horizontal.png", width=4, height=3,dpi = 300)
  
