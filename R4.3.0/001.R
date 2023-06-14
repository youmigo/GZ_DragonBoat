# Thu Jun 15 01:34:00 2023 edit
# 字符编码：UTF-8
# R 版本：R 4.1.1 x64 for window 11
# cgh163email@163.com
# 个人笔记不负责任，拎了个梨🍐🍈
#.rs.restartR()
require(DT)
rm(list = ls());gc()

dt <- read.csv('data/xyz.csv');datatable(dt)
gz.map <-  'https://geo.datav.aliyun.com/areas_v3/bound/geojson?code=440100_full' |>
  sf::st_read()




#pop标签 Tue Jul 26 01:52:22 2022 ------------------------------
myicon <- makeIcon(iconUrl = "data/icon.svg",
                   iconWidth = 50.45, iconHeight = 50.20)
# Thu Jun  8 19:57:14 2023 --