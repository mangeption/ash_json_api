locals_without_parens = [
  get: 2,
  get: 3,
  join_fields: 2,
  create: 1,
  update: 2,
  create: 1,
  create: 2,
  delete: 1,
  delete: 2,
  index: 2,
  index: 3,
  fields: 1,
  include: 1,
  relationship: 1,
  relationship: 2,
  relationship: 3,
  related: 1,
  related: 2,
  related: 3,
  relationship_routes: 2,
  relationship_routes: 1
]

[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: locals_without_parens,
  export: [
    locals_without_parens: locals_without_parens
  ]
]