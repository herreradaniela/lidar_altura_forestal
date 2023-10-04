# Librerías
library(leaflet)
library(leaflet.extras)
library(leafem)
library(raster)
library(sf)
library(htmlwidgets)
library(terra)

# Carga shapes de plantaciones y límites departamentales
plantaciones <- st_read("C:/Users/Daniela Herrera/Desktop/Pasantía/Tesis/macizos_simplif_4326.shp", quiet = TRUE)
st_crs(plantaciones) <- 4326

depto <-st_read("C:/Users/Daniela Herrera/Desktop/Pasantía/Tesis/depto_concordia.shp", quiet = TRUE)
st_crs(deptowgs84) <- 4326

# Carga el raster de altura predicha por el modelo de altura forestal generado con Random Forest
raster_altura <- raster("C:/Users/Daniela Herrera//mapa_altura.tif")
crs(raster_altura) <- 4326

# Genera una paleta de colores para visualizar el raster de altura
pal <- colorNumeric(c("#ffffcc", "#c2e699", "#78c679", "#31a354", "#006837"), values(raster_altura1),
                    na.color = "transparent")

##-- Importante. De acuerdo a la documentación de leaflet, los shapes y rasters deben encontrarse en el crs WGS84.--##
##-- La librería leaflet posteriormente los transforma al EPSG 3857.--##


mapa_altura <- leaflet(options = leafletOptions(maxZoom = 20, minZoom = 0)) %>% 
  addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
  setView(lng=-58.2, lat=-31.28 , zoom= 9) %>% 
  addRasterImage(raster_altura, colors = pal, opacity = 1, maxBytes = Inf, group = "Altura promedio", layerId = "Altura forestal promedio", project = FALSE) %>% 
  addPolygons(data = deptowgs84,stroke = TRUE, color= "#000000", fillOpacity = 0, opacity= 0.5, weight = 3, group = "Departamento de Concordia",
              highlight = highlightOptions(weight = 3,
                                           color = "grey",
                                           bringToFront = TRUE)) %>% 
  addPolygons(data = plantawgs84,stroke = TRUE, color= "#054F13", fillOpacity = 0, opacity = 0.5, weight = 0.5, group="Macizos forestales") %>%
  addLayersControl(overlayGroups = c("Altura promedio", "Macizos forestales", "Departamento de Concordia")) %>% 
  addLegend(pal = pal,
            values = values(raster_altura),
            opacity = 0.8,
            title = "Altura",
            position = "bottomleft") %>% 
  addImageQuery(raster_altura, type="click", layerId = "Altura promedio", position = "bottomright", digits = 2, prefix ="")%>%
  addMiniMap(
    tiles = providers$OpenStreetMap.Mapnik,
    toggleDisplay = TRUE) 
mapa_altura

## Permite exportar el visor a un archivo html
saveWidget(prueba1, 'C:/Users/Daniela Herrera/Desktop/index.html', selfcontained = FALSE)
