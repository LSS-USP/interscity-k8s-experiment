require 'json'

file = File.read('outputs/used_memory.json')
data = JSON.parse(file)

services = {
  "data-collector": {total: 0, instances: [], changes: {}, history: []},
  "resource-adaptor": {total: 0, instances: [], changes: {}, history: []},
  "resource-catalog": {total: 0, instances: [], changes: {}, history: []},
  "resource-discovery": {total: 0, instances: [], changes: {}, history: []},
  "kong": {total: 0, instances: [], changes: {}, history: []},
  "rabbitmq": {total: 0, instances: [], changes: {}, history: []},
  "postgres": {total: 0, instances: [], changes: {}, history: []},
  "mongo": {total: 0, instances: [], changes: {}, history: []},
}

data["data"].each do |resource|
  services.keys.each do |service|
    if resource["resource_id"].include? service.to_s
      services[service][:total] += 1
      new_pod = {}
      new_pod[:start] = resource["data"].first["ts"]
      new_pod[:end] = resource["data"].last["ts"]
      services[service][:instances] << new_pod
    end
  end
end

services.each do |service, data|
  data[:instances].each do |instance|
    start = instance[:start]
    stop = instance[:end]
    unless data[:changes].has_key? start
      data[:changes][start] = 0
    end
    data[:changes][start] += 1

    unless data[:changes].has_key? stop
      data[:changes][stop] = 0
    end
    data[:changes][stop] -= 1
  end
end

services.each do |service, data|
  data[:changes].sort.each do |time, size|
    if data[:history].empty?
      data[:history] << [time, size]
    else
      updated_size = data[:history].last[1] + size
      data[:history] << [time, updated_size]
    end
  end
end

puts services
