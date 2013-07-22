json.array!(@articles) do |article|
  json.extract! article,
                :id,
                :name,
                :url
end