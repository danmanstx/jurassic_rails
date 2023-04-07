# jurassic_rails
It's 1993 and you're the lead software developer for the new Jurassic Park! Park operations needs a system to keep track of the different cages around the park and the different dinosaurs in each one. You'll need to develop a JSON formatted RESTful API to allow the builders to create new cages. It will also allow doctors and scientists the ability to edit/retrieve the statuses of dinosaurs and cages.

## Requirements
- [x] All requests should respond with the correct HTTP status codes and a response, if necessary, representing either the success or error conditions.
- [x] Data should be persisted using some flavor of SQL.
- [x] Each dinosaur must have a name.

  presence validation on `name`

- [x] Each dinosaur is considered an herbivore or a carnivore, depending on its species.

  enum on `species` table to hold values `:herbivore :carnivore`

- [x] Carnivores can only be in a cage with other dinosaurs of the same species.

  validation `carnivore_species_only` on cages, using `validates_associated :cage` when creating a dino

- [x] Each dinosaur must have a species (See enumerated list below, feel free to add others).

  `species` has a validation on `dinosaur`

- [x] Herbivores cannot be in the same cage as carnivores.
- [x] Use Carnivore dinosaurs like Tyrannosaurus, Velociraptor, Spinosaurus and Megalosaurus.
- [x] Use Herbivores like Brachiosaurus, Stegosaurus, Ankylosaurus and Triceratops.

these example dinos are included with the `seed` file

## technical requirements
- [x] This project should be done in Ruby on Rails 6 or newer.
- [x] This should be done using version control, preferably git.
- [x] The project should include a README that addresses anything you may not have completed. It should also address what additional changes you might need to make if the application were intended to run in a concurrent environment.

### Bonus
- [x] Cages have a maximum capacity for how many dinosaurs it can hold.

  `Cage` has a `capacity` column to specify the max for each `cage`,
  validation `occupancy` enforces this.

- [x] Cages know how many dinosaurs are contained.

  `dinosaurs_count` is a column on each cage to track how many dinos are in there.

- [x] Cages have a power status of ACTIVE or DOWN.

  `enum` was used to track `power_status` and uses `:down, :active`

- [x] Cages cannot be powered off if they contain dinosaurs.

  validation `power_off_dino_check`

- [x] Dinosaurs cannot be moved into a cage that is powered down.

  validation `power_off_dino_check`

- [x] Must be able to query a listing of dinosaurs in a specific cage.

  endpoint for listing of dinos in a cage `/api/v1/cage/:cage_id/dinosaurs`

- [x] When querying dinosaurs or cages they should be filterable on their attributes (Cages on their  power status and dinosaurs on species).

  index endpoints like `/api/v1/dinosaurs` and `/api/v1/cages` are filterable on `power_status` and `species` params

- [x] Automated tests that ensure the business logic implemented is correct.

  model and request specs added using `rspec`

### original boilerplate setup
`rails _6.1.7.3_ new jurassic-rails-api --api --database=postgresql -T`

added `'rspec-rails'`

ran `rails g rspec:install`

ran boilerplate for models

`rails g model Cage name:string capacity:integer power_status:integer`

`rails g model Dinosaur name:string species:references cage:references`

`rails g model Species name:string diet:integer`

### setup and running
`rails db:create`

`rails db:migrate`

`rails db:seed`

`rails s`

### testing
`rspec spec`

if any issues can reset test db with following
`RAILS_ENV=test rails db:reset`

## Concurrency Discussion





