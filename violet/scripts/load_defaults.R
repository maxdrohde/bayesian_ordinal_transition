library(showtext)

# Set global font size variable for plots
FONT_SIZE <- 10

set.seed(777)

# Add Google fonts
font_add_google(
  name = "Source Sans Pro",  
  family = "Source Sans Pro"
)

# Automatically use {showtext} for plots
showtext_auto()

# Set global ggplot theme
theme_set(cowplot::theme_cowplot(font_size=FONT_SIZE,
                                 font_family = "Source Sans Pro"))