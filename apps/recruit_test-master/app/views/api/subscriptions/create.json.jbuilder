json.flash do
  json.message  @flash[:msg]
  json.result  @flash[:result]
end