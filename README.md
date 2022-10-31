# core-data-vs-realm
ios project that evaluates time taken for CRUD operations by Core Data and Realm. If switch is on, it will use core data. Else it will use Realm
![File](https://user-images.githubusercontent.com/41371462/191283023-a84fa470-2130-47d9-ad13-54c313153d2d.jpg)

# Performance results
# Realm

| Entries  | Create | Read  | Update | Delete  |
| -------- |:------:| -----:|:------:| -----:|
|10|28|24|11|7|
|100|458|53|49|8|
|1000|4221|216|184|14|
|10000|58187|1785|1434|26|

# Core Data

| Entries  | Create | Read  | Update | Delete  |
| -------- |:------:| -----:|:------:| -----:|
|10|43|49|66|39|
|100|135|161|253|135|
|1000|970|1172|2156|901|
|10000|9159|11242|22089|9142|
