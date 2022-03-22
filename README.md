# Setting the Table
Table templates and examples

<br>

## gt Example

In this example I use the `dplyr` starwars characters tibble to generate a `gt` table with images and icons. To set up the data I `unnest` the films column and employ `pivot_wider` to show which of the seven films each character has screen time in. I use dummy variables (zeros and ones) to set up a table with check marks and add in icons for each of the characters. This is a great option for static tables. A screenshot of the final table is provided below.   

<br>

  <img src="Images/starwars_gt.png" width="80%" height="80%">

<br>
 
## Formattable + Sparklines

Use `formattable` and `sparklines` to create a table with images and icons. 
 
<br>
