# Star Wars gt Table -----------------------------------------------------------

## 1. Setup -----------------------------------------------------------------------

### a. Load required packages --------------------------------------------------
library(tidyverse)
library(gt)


### b. Setting up the data -----------------------------------------------------
sw_table <- starwars %>%
  # Add column that counts number of films per character 
  mutate(n_films = map_int(films, length)) %>%
  # Arrange from high to low and filter to greater than 3 films
  arrange(desc(n_films)) %>%
  filter(n_films > 3) %>%
  # Use unnest on films columns and add a count column to later be converted to a check mark
  unnest(films) %>%
  mutate(count = 1) %>%
  # Use pivot wider to show characters as the ID column, number of films, and all 7 films 
  pivot_wider(names_from = films, values_from = count, values_fill = 0) %>%
  # Select only relevant columns and order the 7 films correctly (Episode I to VII)
  select(name, n_films, `The Phantom Menace`, `Attack of the Clones`, 
         `Revenge of the Sith`, `A New Hope`, `The Empire Strikes Back`, 
         `Return of the Jedi`, `The Force Awakens`) 


### c. Additional aesthetics ---------------------------------------------------
# Create a vector of image paths for character icons 
# Icons from https://symbolicons.com/free
img_paths <- c(
  "r2d2.png", 
  "c3p0.png",
  "obiwan-kenobi.png",
  "luke-skywalker.png",
  "princess-leia.png",
  "chewbacca.png", 
  "yoda.png",
  "emperor-palpatine.png",
  "darth-vader.png",
  "han-solo.png"
)

img_paths <- paste0("gt Starwars Icons/", img_paths)

# Add image paths as first column in the Starwars data frame 
sw_table <- cbind.data.frame(img_paths, sw_table)

# Create a color palette to be used with Number of Films column
pct_pal <- scales::col_numeric(c("#e8cfe1", "#a374c4"), 
                               domain = c(2, 7), 
                               alpha = 0.5)

# html color and code for check mark
check <- "<span style=\"color:#a374c4\">&#10004;</span>"


## 2. Generate the gt table -------------------------------------------------------
sw_table %>% 
  gt() %>%
  # All caps on column headers
  opt_all_caps() %>% 
  # Change font to Franklin Demi 
  opt_table_font(font = list(
    google_font("Franklin Demi"), 
    default_fonts())
  ) %>%
  # Set the alignment 
  cols_align(
    align = "center",
    columns = c(1, 3:10)
  ) %>%
  # Set the column widths
  cols_width(
    columns = 1 ~ px(65),
    columns = 2 ~ px(135),
    columns = 3:10 ~ px(90)
  ) %>%
  # Rename n_films and img_paths columns
  cols_label(
    n_films = "Number of Films",
    img_paths = ""
  ) %>% 
  # Color the Number of Films column
  data_color(
    columns = c(n_films),
    colors = pct_pal
  ) %>%
  # Make the check marks bold
  tab_style(
    style = list(cell_text(weight = "bold")),
    locations = cells_body(columns = 4:10)
  ) %>%
  # Add a title and subtitle
  tab_header(
    title = md("&#10024; **Star Wars Characters by Film Appearance** &#10024;"),
    subtitle = md("**[For Characters in 4+ Films]**")
  ) %>%
  # Provide additional cosmetics - border width and color
  tab_options(
    column_labels.border.top.width = px(18),
    column_labels.border.top.color = "white",
    table.border.top.color = "white",
    table.border.bottom.color = "white"
  ) %>%
  # Use text transform to replace 1s with check marks and 0s with blanks
  text_transform(
    locations = cells_body(columns = 4:10),
    fn = function(x) {
      dplyr::case_when(
        x > 0   ~ paste(check),
        x == 0  ~ "")
    }) %>%
  # Add images using text_transform and local_image function
  text_transform(
    locations = cells_body(columns = img_paths),
    fn = function(x) {
      local_image(
        filename = img_paths,
        height = 25)
    }) %>%
  # Add a source/credit
  tab_source_note(
    source_note = md("Table by [Eden Axelrad](https://github.com/edenaxe) 
                     with icons from [symbolicons](https://symbolicons.com/free)"))
