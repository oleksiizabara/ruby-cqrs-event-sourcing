class Room < ApplicationRecord
  # has_one :snapshot, class_name: "::Snapshots::Readers::Room", dependent: :destroy, foreign_key: :uuid, primary_key: :uuid
end
