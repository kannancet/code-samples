json.users @users do |user|
  json.id   user.id
  json.email user.email
  json.name user.name
  json.gender user.gender
  json.country user.country
  json.birth_date (Date.today.year - user.birth_date.to_date.year)
end
