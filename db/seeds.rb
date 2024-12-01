# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create(user_name: 'Andika',user_acc_number:'123456',user_pin:123456,user_last_balance:0)
User.create(user_name: 'Kristanto',user_acc_number:'654321',user_pin:654321,user_last_balance:0)
Team.create(team_u_name:'Andika',team_pass:'andikak')