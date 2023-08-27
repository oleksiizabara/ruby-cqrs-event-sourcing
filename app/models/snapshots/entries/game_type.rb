module Snapshots
  module Entries
    class GameType < Entry
      attribute :id, Types::Coercible::String
      attribute :description, Types::Coercible::String
      attribute :name, Types::Coercible::String
      attribute :identifier, Types::Coercible::String
      attribute :assets do
        attribute :image_url, Types::Coercible::String.default(nil)
        attribute :emoji, Types::Coercible::String.default(nil)
        attribute :sound_url, Types::Coercible::String.default(nil)
      end
    end
  end
end

def cr
user = User.create!(email: "vyacheslav.yarmak+#{Time.zone.now.to_i}@raizinvest.com.au", password: '1234567Aa!',
                    verified: true, verified_by_id: 1, verified_at: Time.zone.now, source: ::User::SUPER_ESTATE_SOURCE,
                    skip_sending_welcome_email: true)
user.user_profile.update(
  first_name: 'First name',
  last_name: 'Last name',
  gender: 'male',
  date_of_birth: 20.years.ago,
  address1: 'Some street',
  street_number: 1,
  city: 'Sydney',
  state: 'NSW',
  tax_id_number: '123456782',
  phone_number: '0400 000 000',
  zip: 2007
)

::SuperAnnuation::Creator.new(user: user).create_with_tfn!(tfn: '123456782')
user.super_annuation_user.update_columns(verified: true, verified_at: Time.zone.now)

::SuperAnnuation::Members::Bluedoor::Creator.new(account: user.super_annuation_user.super_annuation_account).call!

funds = SuperEstate::Portfolio::Weights.new.for(portfolio: "property_10.name")

SuperEstate::Portfolio::Creator.new(user: user, name: "property_10.name", funds: funds).call!

SuperEstate::Portfolio::Creator.new(user: user.super_annuation_user, name: "property_10.name", funds: funds).call!

puts SuperEstate::Notificator.new(user: user).migration_link
end