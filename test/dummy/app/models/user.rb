class User
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :first_name, :string
  attribute :last_name, :string
  attribute :email, :string

  # Make it behave like a persisted record
  def persisted?
    id.present?
  end

  # Needed for form routing
  def to_key
    persisted? ? [ id ] : nil
  end

  def to_param
    id&.to_s
  end
end
