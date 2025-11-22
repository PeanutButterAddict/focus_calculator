# Build (Requies Premake5)
```bat
premake5 gmake
make -C build/
```

# Calculate distraction (24 hr format)
```bat
./focus_calculator [start_time] [end_time]
```

# Calculate focus (12 hr format)
```bat
./focus_calculator [start_time] [end_time] [list of distraction mins in commas -- 50,25,30,...]
```
