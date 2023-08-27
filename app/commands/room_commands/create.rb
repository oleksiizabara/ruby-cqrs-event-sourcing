module RoomCommands
  class Create < ::Command
    attribute :initiator, Types::Any
    attribute :data do
      attribute :name, Types::String
      # attribute :password, Types::String
      # attribute :private, Types::Bool
    end
  end
end
