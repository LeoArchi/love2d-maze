function table.length(table)
  local count = 0
  for k,v in pairs(table) do
    count = count + 1
  end
  return count
end
