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
users.map {|user| FactoryBot.create_list(:lot, 5, user: user)}
users.map {|user|
  user.lots.map {|lot|
    lot_maximum_price = lot.bids.maximum(:proposed_price)
    price = lot_maximum_price.nil? ? rand(1000) : lot_maximum_price +rand(1000)
    FactoryBot.create(:bid, lot: lot, user: user, proposed_price: price)
  }
}