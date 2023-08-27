module UserCommands
  class Create < ::Command
    attribute :initiator, Types::Nil
    attribute :data do
      attribute :nickname, Types::String
      attribute :email, Types::String
      attribute :password, Types::String
    end
  end
end
