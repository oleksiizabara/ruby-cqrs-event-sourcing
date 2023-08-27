module GameCommands
  class Create < ::Command
    attribute :initiator, Types.Instance(::User)
    attribute :data do
      attribute :json, Types::Coercible::String | Types::Hash.schema({})
    end
  end
end