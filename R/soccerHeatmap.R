#' @include soccerPitch.R
#' @import ggplot2
#' @import dplyr
NULL
#' Draw a heatmap on a soccer pitch.
#' @description Draws a heatmap showing player position frequency in each area of the pitch and adds soccer pitch outlines.
#' 
#' @param df dataframe containing x,y-coordinates of player position
#' @param xBins,yBins integer, the number of horizontal (length-wise) and vertical (width-wise) bins the soccer pitch is to be divided up into. If no value for \code{yBins} is provided, it will take the value of \code{xBins}.
#' @param lengthPitch,widthPitch numeric, length and width of pitch in metres.
#' @param arrow optional, adds arrow showing team attack direction as right (\code{'r'}) or left (\code{'l'})
#' @param colLow,colHigh character, colours for the low and high ends of the heatmap gradient.
#' @param title,subtitle optional, adds title and subtitle to plot
#' @param x,y = name of variables containing x,y-coordinates
#' @return a ggplot object of a heatmap on a soccer pitch.
#' @details uses \code{ggplot2::geom_bin2d} to map 2D bin counts
#' @examples
#' library(dplyr)
#' 
#' # Heatmap of Tromso IL #8 position w/ ~5x5m bins (pitchLength / 5 = 21, pitchWidth / 5 = 13.6) 
#' data(tromso)
#' tromso %>% 
#'   filter(id == 8) %>% 
#'   soccerHeatmap(xBins = 10)
#' 
#' # Heatmap of France w/ 6x3 zones
#' data(statsbomb)
#' statsbomb %>%
#'   filter(type.name == "Pressure" & team.name == "France") %>% 
#'   soccerHeatmap(x = "location.x", y = "location.y", xBins = 6, yBins = 3,
#'                 arrow = "r", 
#'                 title = "France (vs Argentina, 30th June 2016)", 
#'                 subtitle = "Defensive pressure heatmap")
#'
#' @export
soccerHeatmap <- function(df, lengthPitch = 105, widthPitch = 68, xBins = 10, yBins = NULL, arrow = c("none", "r", "l"), colLow = "white", colHigh = "red", title = NULL, subtitle = NULL, x = "x", y = "y") {
  
  # rename variables
  df$x <- df[,x]
  df$y <- df[,y]
  
  # check value for vertical bins and match to horizontal bins if NULL
  if(is.null(yBins)) yBins <- xBins
  
  # filter invalid values outside pitch limits
  df <- df[df$x > 0 & df$x < lengthPitch & df$y > 0 & df$y < widthPitch,]
  
  # define bin ranges
  x.range <- seq(0, lengthPitch, length.out = xBins+1)
  y.range <- seq(0, widthPitch, length.out = yBins+1)
  
  # plot heatmap on blank pitch lines
  p <- soccerPitch(lengthPitch, widthPitch, arrow = arrow, title = title, subtitle = subtitle, theme = "blank") +
    geom_bin2d(data = df, aes(x, y), binwidth = c(diff(x.range)[1], diff(y.range)[1])) +
    scale_fill_gradient(low = colLow, high = colHigh) +
    guides(fill=FALSE)
  
  # redraw pitch lines  
  p <- soccerPitchFG(p)

  return(p)
  
}
