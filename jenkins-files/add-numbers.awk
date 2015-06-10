BEGIN {
  # 0 = feature, 1 = background, 2 = scenario, 3 = step
  state=0
  scenario=0
  step=1
}

/"keyword":/ {
  line=$0
  sub(/^ *"keyword": "/, "", line)
  sub(/ *",$/, "", line)
  switch (line)
  {
    case "Feature":
      state=0
      print $0
      break 
    case "Background":
      state=1
      print $0
      break 
    case "Scenario":
      state=2
      scenario++
      step=1
      print "        \"keyword\": \"[" scenario "] " line "\","
      break 
    case "Given":
    case "When":
    case "Then":
    case "But":
    case "And":
      state=3
      step++
      print "            \"keyword\": \"[" scenario "/" step "] " line "\","
      break 
    default:
      print "Unknown keyword"
      exit 1
  }
}

!/"keyword":/ {
  print $0
}
