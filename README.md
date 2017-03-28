# Distributed Stages

This is a simple experiment with running gen_stage consumers on multiple nodes
in a cluster and subscribe to one global producer. I don't know how useful it is
/ what use there could be, but it might be interesting to some people.

Enjoy.

## Setup

```
docker-compose build
docker-compose scale ds=3
docker-compose up
```

## sample logs

```
Starting diststages_ds_1
Starting diststages_ds_3
Starting diststages_ds_2
Attaching to diststages_ds_1, diststages_ds_3, diststages_ds_2
```

^ everything is up

```
ds_1  |
ds_1  | 04:18:49.050 [info]  global: Name conflict terminating {DSP, #PID<18256.155.0>}
ds_1  |
ds_3  |
ds_3  | 04:18:49.146 [info]  global: Name conflict terminating {DSP, #PID<18300.155.0>}
```

^ conflict of a global process detected


```
ds_3  |
ds_3  | :"ds@172.19.0.3": [1000, 1001, 1002, 1003, 1004]
ds_1  | :"ds@172.19.0.2": [1000, 1001, 1002, 1003, 1004]
ds_2  | :"ds@172.19.0.4": [1000, 1001, 1002, 1003, 1004]
ds_3  | :"ds@172.19.0.3": [1005, 1006, 1007, 1008, 1009]
ds_3  |
```

^ no big deal, everything still running according to its own node


```
ds_3  | 04:18:57.486 [error] GenServer DSC terminating
ds_3  | ** (stop) killed
ds_3  | Last message: {:DOWN, #Reference<0.0.1.719>, :process, #PID<0.155.0>, :killed}
ds_1  | :"ds@172.19.0.2": [1005, 1006, 1007, 1008, 1009]
ds_2  | :"ds@172.19.0.4": [1005, 1006, 1007, 1008, 1009]
ds_2  |
ds_2  | 04:19:00.844 [error] GenServer DSC terminating
ds_2  | ** (stop) killed
ds_2  | Last message: {:DOWN, #Reference<0.0.2.626>, :process, #PID<0.155.0>, :killed}
```

^ duplicates were killed

```
ds_3  | :"ds@172.19.0.3": [1015, 1016, 1017, 1018, 1019]
ds_1  | :"ds@172.19.0.2": [1010, 1011, 1012, 1013, 1014]
ds_2  | :"ds@172.19.0.4": [1030, 1031, 1032, 1033, 1034]
ds_2  | :"ds@172.19.0.4": [1035, 1036, 1037, 1038, 1039]
ds_3  | :"ds@172.19.0.3": [1020, 1021, 1022, 1023, 1024]
ds_1  | :"ds@172.19.0.2": [1025, 1026, 1027, 1028, 1029]
ds_3  | :"ds@172.19.0.3": [1040, 1041, 1042, 1043, 1044]
ds_2  | :"ds@172.19.0.4": [1050, 1051, 1052, 1053, 1054]
ds_1  | :"ds@172.19.0.2": [1045, 1046, 1047, 1048, 1049]
ds_3  | :"ds@172.19.0.3": [1060, 1061, 1062, 1063, 1064]
ds_2  | :"ds@172.19.0.4": [1055, 1056, 1057, 1058, 1059]
ds_3  | :"ds@172.19.0.3": [1070, 1071, 1072, 1073, 1074]
ds_2  | :"ds@172.19.0.4": [1075, 1076, 1077, 1078, 1079]
ds_1  | :"ds@172.19.0.2": [1065, 1066, 1067, 1068, 1069]
...
```

^ all consumers subscribe to the one global producer
