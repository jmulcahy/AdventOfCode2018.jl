using Dates
import DataStructures.Stack

function load(filename)
    open(filename) do file
        read(file, String)
    end
end

function make_entry(time_string, message_string)
    dt = DateTime(time_string, "y-m-d H:M")
    if message_string == "falls asleep"
        (date_time = dt, message = :falls_asleep)
    elseif message_string == "wakes up"
        (date_time = dt, message = :wakes_up)
    else
        guard_id = match(r"Guard #(\d+) begins shift", message_string).captures[1]
        (date_time = dt, message = parse(Int64, guard_id))
    end
end

function parse_input(input)
    raw_entries = eachmatch(r"\[(.*)\] (.*)\n", input)
    parsed = [make_entry(re.captures[1], re.captures[2]) for re in raw_entries]
    sort(parsed, by=entry->entry.date_time)
end

function process_schedule(sched)
    current_guard = -1
    last_asleep = DateTime(0)
    guard_times = Dict{Int64, Array{Int64}}()
    for (date_time, message) in sched
        if message == :falls_asleep
            last_asleep = date_time
        elseif message == :wakes_up
            guard_time = get(guard_times, current_guard, zeros(60))
            sleep_minute = Dates.minute(last_asleep)
            awake_minute = Dates.minute(date_time)
            guard_time[(sleep_minute+1):awake_minute] .+= 1
            guard_times[current_guard] = guard_time
        else
            current_guard = message
        end
    end
    guard_times
end

function process_guard_times(guard_times)
    max_time = (-1, -1)
    max_id = -1
    for (guard_id, guard_time) in guard_times
        total_time = findmax(guard_time)
        if total_time[1] > max_time[1]
            max_id = guard_id
            max_time = total_time
        end
    end
    max_id * (max_time[2] - 1)
end


sched = parse_input(load("input_a.txt"))

guard_times = process_schedule(sched)

result = process_guard_times(guard_times)

println(result)

