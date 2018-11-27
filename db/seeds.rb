# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'factory_bot'
FactoryBot.find_definitions
users = FactoryBot.create_list(:client, 5)
users.each { |user| FactoryBot.create_list(:lot, 5, user: user) }
Lot.all.each do |lot|
  users.each do |user|
    FactoryBot.create(:bid, user: user, lot: lot) if user.id != lot.user.id
  end
end
Lot.all.each do |lot|
  if lot.id.even?
    bid = FactoryBot.create(:bid, proposed_price: lot.estimated_price + 100, lot: lot)
    FactoryBot.create(:order, bid: bid)
  end
end
