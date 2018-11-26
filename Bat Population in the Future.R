library(spocc)
library(raster)

vampyrus <- occ(query='Pteropus vampyrus', from='gbif')

df = as.data.frame(occ2df(vampyrus$gbif))
map_leaflet(df[,c('name', 'longitude', 'latitude', 'stateProvince', 'country', 'year', 'occurrenceID')])
vampyrus2 <- occ(query='Pteropus vampyrus', limit=1000)
map_leaflet(vampyrus2)
wc = getData('CMIP5', var='tmin', res=10, rcp=85, model='AC', year=70)
ext = extent(85, 130, 0, 25)
wc2 = crop(wc, ext)
plot(wc2[[12]], col = topo.colors(99))
points(df$longitude, df$latitude)

library(spocc)
library(dismo)

library(ENMeval)
occdat <- occ2df(vampyrus2)

loc=occdat[,c('longitude', 'latitude')]
extr = extract(predictors, loc)
loc = loc[!is.na(extr[,1]),]


eval = ENMevaluate(occ=as.data.frame(loc), env = predictors, method='block', parallel=FALSE, fc=c("L", "LQ"), RMvalues=seq(0.5, 2, 0.5), rasterPreds=T)

est.loc = extract(eval@predictions[[best]], as.data.frame(loc))
est.bg = extract(eval@predictions[[best]], eval@bg.pts)
ev = evaluate(est.loc, est.bg)
thr = threshold(ev)
plot(eval@predictions[[best]] > thr$equal_sens_spec, col = c('lightgrey', 'black'))
