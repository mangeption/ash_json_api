# defmodule AshJsonApi.Test.Resources.Comment do
#   use Ash.Resource, name: "comments", type: "comment"
#   use AshJsonApi
#   use Ash.DataLayer.Ets, private?: true

#   json_api do
#     routes do
#       get(:default)
#       index(:default)
#     end

#     fields [:text]
#   end

#   actions do
# read(:default,
# rules: [
#   allow(:static, result: true)
# ]
# )

# create(:default,
# rules: [
#   allow(:static, result: true)
# ]
# )
#   end

#   attributes do
#     attribute(:text, :string)
#   end
# end
