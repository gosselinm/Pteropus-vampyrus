library(spocc)
library(raster)

vampyrus <- occ(query='Pteropus vampyrus', from='gbif')

df = as.data.frame(occ2df(vampyrus$gbif))
map_leaflet(df[,c('name', 'longitude', 'latitude', 'stateProvince', 'country', 'year', 'occurrenceID')])
vampyrus2 <- occ(query='Pteropus vampyrus', limit=1000)
map_leaflet(vampyrus2)
wc = getData('worldclim', var='bio', res = 5)
ext = extent(85, 130, 0, 25)
wc2 = crop(wc, ext)
plot(wc2[[12]], col = topo.colors(99))
points(df$longitude, df$latitude)


