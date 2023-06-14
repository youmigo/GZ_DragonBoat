# Thu Jun 15 01:34:00 2023 edit
# 字符编码：UTF-8
# R 版本：R 4.1.1 x64 for window 11
# cgh163email@163.com
# 个人笔记不负责任，拎了个梨🍐🍈
#.rs.restartR()
require(DT)
require(leaflet)
require(leafletCN)
rm(list = ls());gc()

dt <- read.csv('data/xyz.csv');datatable(dt)
# gz.map <-  'https://geo.datav.aliyun.com/areas_v3/bound/geojson?code=440100_full' |>
#   sf::st_read()


#预备pop数据 Thu Jun 15 01:44:14 2023 ------------------------------
dtle <- data.frame(
  po=paste(dt[,2],dt[,3]),
  xy=dt[,6]
);datatable(dtle)
htmlwidgets::saveWidget(dt[,-6] |> 
                          datatable(), file='web/ft.html')

# po                     xy
# 1   6月18日 深涌景 23.1221499,113.4137107
# 2   6月19日 小洲景    23.06309,113.359179
#转为高德导航 Thu Jun 15 01:48:27 2023 ------------------------------
xy <- dtle$xy
label <- dtle$po
amapurl <-
  data.frame( "<a href='",
              "https://uri.amap.com/marker?position=",
              xy,
              '&name=',
              label,
              '&src=🍐&coordinate=&callnative=1',
              '[\']target=\"_blank\">',
              label,
              "</a>"  )
names(amapurl) <- letters[1:length(amapurl)]
dtok <-
  tidyr::unite(amapurl,"laburl",names(amapurl),sep = "",remove = T) |> 
  cbind(dtle) |> 
  tidyr::separate(#data = dt,
    col = xy,remove=T,
    sep = ',',
    into = c('lat', 'lng'))   #分割列分列
dtok$lng <- dtok$lng |> as.numeric()
dtok$lat <- dtok$lat |> as.numeric()
# laburl	po	lng	lat
# 2	<a href='https://uri.amap.com/marker?position=23.06309,113.359179&name=6月19日 小洲景&src=🍐&coordinate=&callnative=1[']target="_blank">6月19日 小洲景</a>	6月19日 小洲景	23.06309	113.359179
rm(dtle,xy,amapurl,label)
datatable(dtok)
#出图 Thu Jun 15 01:52:13 2023 ------------------------------
#pop标签 Tue Jul 26 01:52:22 2022 ------------------------------
myicon <- makeIcon(iconUrl = "data/icon.svg",
                   iconWidth = 50.45, iconHeight = 50.20)
# Thu Jun  8 19:57:14 2023 --

mapurl <-
  leaflet(data = dtok) |>
  amap() |>
  addPolygons(data = 
                'https://geo.datav.aliyun.com/areas_v3/bound/geojson?code=440100_full' |>
                sf::st_read(), # 广州地图
              fillColor = rainbow(11)
              ,color = 'green') |>
  addCircleMarkers( #底圈，用于分类。
    # data = dtsd,
    lat = ~ lat,
    lng = ~ lng,
    popup = ~ po,
    color = 'green'
    # ,      colorRampPalette(
    #       c('#99CCFF', '#996600'))(dt |>nrow()) #  按行数生成颜色数
    , clusterOptions = markerClusterOptions() #  放遮盖
  ) |>
  # addCircleMarkers(113.433164, 23.627496, popup = "<a href='/html/gzatable.html' target=\"_blank\">查看景点列表</a>") |>
  leafem::addLogo("https://z3.ax1x.com/2021/10/09/5iF8Vx.png",url = "ft.html") |>
  addMarkers( #标注点
    # data = dtsd,
    lat = ~ lat,
    lng = ~ lng,
    popup = ~ laburl
    ,icon = myicon #  pop图表ico
  )
mapurl
htmlwidgets::saveWidget(mapurl, file='web/mapurl.html')

