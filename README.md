# Build 
```sh
zig build
```

# Usage 

```sh
# To calculate Distraction Time, Give it 2 arguements 
# Time format is HH:MM 24hrs
focus_calculator [distraction_start_time] [distraction_end_time]
# example
focus_calculator 11:26 13:17 
# To calculate the results of the whole day
# distraction time format is MM,MM,MM 
focus_calculator [work_start_time] [work_end_time] [distraction_time_in_commas]
# example
focus_calculator 8:26 23:41 24,51,107,93,50
```
