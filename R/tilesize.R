
StatTileSize <- ggproto("StatTileSize", Stat,
                        required_aes = c("x", "y", "scale"),

                        setup_data = function(data, params) {

                              xres <- resolution(data$x) / 2
                              yres <- resolution(data$y) / 2

                              scl <- scales::rescale(data$scale, 0:1)
                              if(params$sizedims == "xy") scl <- sqrt(scl)
                              scl <- scales::rescale(scl, params$sizelims)

                              xscl <- yscl <- 1
                              if(grepl("x", params$sizedims)) xscl <- scl
                              if(grepl("y", params$sizedims)) yscl <- scl

                              data$xmin <- data$x - xres * xscl
                              data$xmax <- data$x + xres * xscl
                              data$ymin <- data$y - yres * yscl
                              data$ymax <- data$y + yres * yscl

                              data
                        },

                        compute_group = function(data, scales,
                                                 sizedims, sizelims) {
                              return(data)
                        }
)


#' A version of geom_tile with variable cell size
#'
#' This stat is analogous to geom_tile or geom_raster, but with an additional
#' aesthetic parameter that controls the size of the tile.
#'
#' @param data,mapping,na.rm,show.legend,inherit_aes Standard ggplot2
#'   parameters common across geoms and stats.
#' @param sizedims String specifying which dimensions to scale: either "xy"
#'   (default), "x", or "y".
#' @param sizelims Length-2 numeric vector specifying the range of relative
#'   cell widths used to represent the `size` variable. Under the default,
#'   c(0, 1), the smallest value will have an area of zero and the largest
#'   will occupy a full cell space. Values greater than 1 are allowed.
#' @param ... Other arguments passed on to `layer()`.
#' @export
geom_tile_size <- function(mapping = NULL, data = NULL,
                           na.rm = FALSE, show.legend = NA, inherit.aes = TRUE,
                           sizedims = "xy", sizelims = c(0, 1), ...) {
      layer(
            geom = GeomRect,
            data = data,
            mapping = mapping,
            stat = StatTileSize,
            position = "identity",
            show.legend = show.legend,
            inherit.aes = inherit.aes,
            params = list(
                  sizedims = sizedims,
                  sizelims = sizelims,
                  na.rm = na.rm,
                  ...
            )
      )
}


#' @describeIn geom_tile_size Stat corresponding to geom_tile_size
#' @export
stat_tile_size <- function(mapping = NULL, data = NULL,
                           na.rm = FALSE, show.legend = NA, inherit.aes = TRUE,
                           sizedims = "xy", sizelims = c(0, 1), ...) {
      layer(
            stat = StatTileSize,
            data = data,
            mapping = mapping,
            geom = "rect",
            position = "identity",
            show.legend = show.legend,
            inherit.aes = inherit.aes,
            params = list(
                  sizedims = sizedims,
                  sizelims = sizelims,
                  na.rm = na.rm,
                  ...
            )
      )
}


