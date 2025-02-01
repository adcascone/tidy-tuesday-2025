library(ggplot2)
library(dplyr)
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

p <- simpsons_script_lines %>% 
  na.omit()%>%
  group_by(character_id) %>% 
  summarize(total_words = sum(word_count)) %>%
  ungroup()%>%
  mutate(pct_words = total_words/sum(total_words))%>%
  filter(pct_words>.0154) %>%
  merge(simpsons_characters, by="character_id")%>%
  ggplot(aes(x=reorder(name, pct_words), y=pct_words*100))+
  geom_bar(stat="identity",aes(fill=name))+
  scale_fill_manual(values=c("#FED43999","#709ae199","#8A919799","#D2AF8199","#FD744699",
                       "#FD744699","#D5E4A299","#197EC099","#F05C3B99","#46732E99"))+
  geom_text(aes(label=paste0(format(round(pct_words*100,1), nsmall=1), "%"), y=pct_words*100+.005), color="black", size=4, hjust=0, family="Rock Salt")+
  coord_flip()+
  theme_classic(base_size=18)+
  theme(text=element_text(family="Rock Salt"),
        plot.title = element_text(size = 20),
        plot.subtitle = element_text(size = 15),
        axis.title.x = element_text(size = 18),
        axis.title.y = element_text(size = 0),
        legend.position = "none")+
  labs(title='Which Simpsons characters speak the most?', 
       x="", 
       y="% of total words spoken by all characters",
       subtitle='Top 10 speaking characters from 2010-2016',
       caption="GitHub: adcascone")

ggsave(plot=p, filename = "./2024-02-04/simpsons_speaking.png", width=4, height=3)

